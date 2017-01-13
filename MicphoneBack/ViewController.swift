//
//  ViewController.swift
//  MicphoneBack
//
//  Created by Ricky on 17/1/11.
//  Copyright © 2017年 Ricky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Test C library pointer conversion
//        struct Context {
//            var city = "Tokyo"
//        }
//        
//        var context: Context = Context()
//        let rawPtr = UnsafeMutableRawPointer(&context)
//        let opaquePtr = OpaquePointer(rawPtr)
//        let contextPtr = UnsafeMutablePointer<Context>(opaquePtr)
//        
//        context.city // "Tokyo"
//        contextPtr.pointee.city = "New York"
//        context.city // "New York"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTest(_ sender: Any) {

    }

}

