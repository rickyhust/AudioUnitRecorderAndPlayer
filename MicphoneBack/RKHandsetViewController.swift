//
//  RKHandsetViewController.swift
//  MicphoneBack
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 Ricky. All rights reserved.
//

import UIKit
import AVFoundation

class RKHandsetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: nil)
    }
    
    var player:AVAudioPlayer! = nil
    
    @IBAction func onPlayandStop(_ sender: Any) {
        let btn = sender as! UIButton
        if !btn.isSelected {
            do{
                var fileURL = Bundle.main.url(forResource: "huanqin", withExtension: "mp3")
                player = try AVAudioPlayer(contentsOf: fileURL!)
            }
            catch {
                return
            }
            
            player.play()
            btn.isSelected = true
            
            sensorStatus(status: true)
            
            //method 1

            
            //method 2
//            do{
//                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
//            }
//            catch let error as NSError{
//                
//            }
//
//            do{
//                try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
//            }
//            catch let error as NSError{
//                
//            }
            
            
        }
        else{
            player.stop()
            player = nil
            btn.isSelected = false
            
            sensorStatus(status: false)
        }
    }
    
    func sensorStatus(status:Bool){
        UIDevice.current.isProximityMonitoringEnabled = status
        if status{
            NotificationCenter.default.addObserver(self, selector: #selector(sensorStateChange), name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: nil)
        }
        else{
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: nil)
        }
    }
    
    func sensorStateChange(){
        if UIDevice.current.proximityState{
            //method 1
            do{
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)

            }
            catch let error as NSError{
                
            }
            
            //method 2
//            do{
//                try AVAudioSession.sharedInstance().overrideOutputAudioPort(.none)
//            }
//            catch let error as NSError{
//                
//            }
            
        }
        else{
            //method 1
            do{
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            }
            catch let error as NSError{
                
            }
            
            //method 2
//            do{
//                try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
//            }
//            catch let error as NSError{
//                
//            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
