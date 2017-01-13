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
        struct Context {
            var city = "Tokyo"
        }
        
        var context: Context = Context()
        let rawPtr = UnsafeMutableRawPointer(&context)
        let b = rawPtr as? UnsafeMutableRawPointer
        let opaquePtr = OpaquePointer(rawPtr)
        let contextPtr = UnsafeMutablePointer<Context>(opaquePtr)
        
        var s = context.city // "Tokyo"
        contextPtr.pointee.city = "New York"
        s = context.city // "New York"
        
        print(s)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTest(_ sender: Any) {

    }

}

