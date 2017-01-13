//
//  RKAURecorderandPlayer.swift
//  MicphoneBack
//
//  Created by Ricky on 17/1/11.
//  Copyright © 2017年 Ricky. All rights reserved.
//

import Foundation
import AudioToolbox

class RKAURecoderandPlayer {
    deinit{
        if audioUnit != nil{
            stop()
            AudioUnitInitialize(audioUnit!)
        }
    }
    
    //Two Method Swith
    private let method = 1      //0 on callback  1 tow callback
    
    //audio unit
    private var audioUnit:AudioComponentInstance?
    
    //bus/element
    private let kOutputBus = AudioUnitElement(0)
    private let kInputBus = AudioUnitElement(1)
    
    //pcm bufer list
    private var audioBuffers = [(AudioBuffer, Int)]()
    
    private let recordingCallback:AURenderCallback = {
        (inRefCon, ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, ioData) -> OSStatus in
        //get self
        let rkau:RKAURecoderandPlayer = Unmanaged<RKAURecoderandPlayer>.fromOpaque(inRefCon).takeUnretainedValue()
        var status = noErr;
        
        if(rkau.method == 0)
        {
            status = AudioUnitRender(rkau.audioUnit!, ioActionFlags, inTimeStamp, 1, inNumberFrames, ioData!);
        }
        else{
            //alloc buffer
            var buf = UnsafeMutableRawPointer.allocate(bytes: Int(inNumberFrames * 2), alignedTo: MemoryLayout<Int8>.alignment)
            //init value to 0
            let bindptr = buf.bindMemory(to: Int8.self, capacity: Int(inNumberFrames * 2))
            bindptr.initialize(to: 0)
            var buffer = AudioBuffer(mNumberChannels: 1, mDataByteSize: inNumberFrames * 2, mData: buf)
//            memset(buffer.mData, 0, Int(buffer.mDataByteSize))
            
//            //alloc buffer
//            var buf1 = UnsafeMutableRawPointer.allocate(bytes: Int(inNumberFrames * 2), alignedTo: MemoryLayout<Int8>.alignment)
//            //init value to 0
//            let bindptr1 = buf1.bindMemory(to: Int8.self, capacity: Int(inNumberFrames * 2))
//            bindptr1.initialize(to: 0)
//            var buffer1 = AudioBuffer(mNumberChannels: 1, mDataByteSize: inNumberFrames * 2, mData: buf1)
            
            //create buffer list
            var bufferList = AudioBufferList(mNumberBuffers: 1, mBuffers: buffer)
            
            //get microphone data
            status = AudioUnitRender(rkau.audioUnit!, ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, &bufferList)
            
            //-1
            //add buffer to buffer list
            rkau.audioBuffers.append((buffer,Int(inNumberFrames * 2)))
            
            //-2
//            //copy buffer to temp buffer
//            //alloc temp buffer
//            var tempBuf = UnsafeMutableRawPointer.allocate(bytes: Int(inNumberFrames * 2), alignedTo: MemoryLayout<Int8>.alignment)
//            //init value to 0
//            let bindptr2 = buf.bindMemory(to: Int8.self, capacity: Int(inNumberFrames * 2))
//            bindptr2.initialize(to: 0)
//            
//            //create audio buffer
//            var tempBuffer = AudioBuffer(mNumberChannels: 1, mDataByteSize: inNumberFrames * 2, mData: tempBuf)
//
//            //copy microphone data to temp buffer
//            tempBuffer.mNumberChannels = bufferList.mBuffers.mNumberChannels
//            tempBuffer.mDataByteSize = bufferList.mBuffers.mDataByteSize
//            memcpy(tempBuffer.mData, bufferList.mBuffers.mData, Int(bufferList.mBuffers.mDataByteSize))
//            
//            //add temp buffer to pcm buffer list
//            rkau.audioBuffers.append((tempBuffer,Int(inNumberFrames * 2)))
//            
//            buf.deallocate(bytes: Int(inNumberFrames * 2), alignedTo: MemoryLayout<Int8>.alignment)
        }
        
        return status
    }
    
    private let playbackCallback:AURenderCallback = {
        (inRefCon, ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, ioData) -> OSStatus in
        let rkau:RKAURecoderandPlayer = Unmanaged<RKAURecoderandPlayer>.fromOpaque(inRefCon).takeUnretainedValue()
        
        //        for (int i=0; i < ioData->mNumberBuffers; i++) { // in practice we will only ever have 1 buffer, since audio format is mono
        //            AudioBuffer buffer = ioData->mBuffers[i];
        //            if ([[ars audioBuffer] length]>AUDIO_FRAME_SIZE*30 && [[ars audioBuffer] length]>(AUDIO_FRAME_SIZE*(ars.recIndex+1))) {
        //                NSData *curData = [[ars audioBuffer] subdataWithRange:NSMakeRange(AUDIO_FRAME_SIZE*ars.recIndex, AUDIO_FRAME_SIZE)];
        //                memcpy(buffer.mData, [curData bytes], AUDIO_FRAME_SIZE);
        //                buffer.mDataByteSize = AUDIO_FRAME_SIZE;
        //                ars.recIndex++;
        //            }else{
        //                NSLog(@"no rec data coming at the time :%f",[[NSDate new] timeIntervalSince1970]);
        //                NSMutableData *tmpData = [[NSMutableData alloc]init];
        //                for (int i=0; i<AUDIO_FRAME_SIZE; i++) {
        //                    [tmpData appendBytes:"\x00" length:1];
        //                }
        //                memcpy(buffer.mData, [tmpData bytes], AUDIO_FRAME_SIZE);
        //                buffer.mDataByteSize = AUDIO_FRAME_SIZE;
        //            }
        //
        //
        //        }
        
        if ioData == nil{
            return noErr
        }
        
        var bufferCount = ioData!.pointee.mNumberBuffers
        if bufferCount != 1{
            //get Audio Buffer List from ioData
            let abl = UnsafeMutableAudioBufferListPointer(ioData)
            for buffer in abl!{
                //to do...
            }
        }
        else{
            if rkau.audioBuffers.count > 0{
                var tempBuffer = rkau.audioBuffers[0]
                memcpy(ioData!.pointee.mBuffers.mData, tempBuffer.0.mData, Int(tempBuffer.0.mDataByteSize))
                ioData!.pointee.mNumberBuffers = 1
                
                tempBuffer.0.mData?.deallocate(bytes:tempBuffer.1, alignedTo: MemoryLayout<Int8>.alignment)
                
                rkau.audioBuffers.removeFirst()
            }
            else{
                // copy slient data to ioData
            }
            
        }
        
        return noErr
    }
    
    open func configRecorder() -> Bool {
        var status:OSStatus
        var desc:AudioComponentDescription = AudioComponentDescription(componentType: kAudioUnitType_Output, componentSubType: kAudioUnitSubType_VoiceProcessingIO, componentManufacturer: kAudioUnitManufacturer_Apple, componentFlags: 0, componentFlagsMask: 0)
        let inputComponent = AudioComponentFindNext(nil, &desc)
        if inputComponent == nil{
            return false
        }
        
        status = AudioComponentInstanceNew(inputComponent!, &audioUnit)
        if(status != noErr){
            return false
        }
        
        //Enable IO for Recording
        var flag:UInt32 = 1
        status |= AudioUnitSetProperty(audioUnit!, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, kInputBus, &flag, UInt32(MemoryLayout<UInt32>.size))
        
        //Enable IO for Playback
        flag = 1
        status |= AudioUnitSetProperty(audioUnit!, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Output, kOutputBus, &flag, UInt32(MemoryLayout<UInt32>.size))
        
        if status != noErr{
            return false
        }
        
        //set recording and playback audio format
        var audioFormat = AudioStreamBasicDescription(mSampleRate: 8000.0, mFormatID: kAudioFormatLinearPCM, mFormatFlags: kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked, mBytesPerPacket: 2, mFramesPerPacket: 1, mBytesPerFrame: 2, mChannelsPerFrame: 1, mBitsPerChannel: 16, mReserved: 0)
        
        status |= AudioUnitSetProperty(audioUnit!, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, kInputBus, &audioFormat, UInt32(MemoryLayout<AudioStreamBasicDescription>.size))
        
        status |= AudioUnitSetProperty(audioUnit!, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, kOutputBus, &audioFormat, UInt32(MemoryLayout<AudioStreamBasicDescription>.size))
        
        
        var callbackStruct = AURenderCallbackStruct(inputProc: recordingCallback, inputProcRefCon: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
        
        if method == 1{
            status |= AudioUnitSetProperty(audioUnit!, kAudioOutputUnitProperty_SetInputCallback, kAudioUnitScope_Global, kInputBus, &callbackStruct, UInt32(MemoryLayout<AURenderCallbackStruct>.size))
        }
        else{
            status |= AudioUnitSetProperty(audioUnit!, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, kOutputBus, &callbackStruct, UInt32(MemoryLayout<AURenderCallbackStruct>.size))
        }
        if method == 1{
            callbackStruct = AURenderCallbackStruct(inputProc: playbackCallback, inputProcRefCon: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
            status |= AudioUnitSetProperty(audioUnit!, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Global, kOutputBus, &callbackStruct, UInt32(MemoryLayout<AURenderCallbackStruct>.size))
        }
        
        
        flag = 0
        status |= AudioUnitSetProperty(audioUnit!, kAudioUnitProperty_ShouldAllocateBuffer, kAudioUnitScope_Output, kInputBus, &flag, UInt32(MemoryLayout<UInt32>.size))
        
        status |= AudioUnitInitialize(audioUnit!)
        
        
        return status == noErr
    }
    
    open func start() -> Bool{
        if audioUnit == nil{
            return false
        }
        else{
            return AudioOutputUnitStart(audioUnit!) == noErr
        }
    }
    
    open func stop(){
        if audioUnit != nil{
            AudioOutputUnitStop(audioUnit!);
        }
    }
}
