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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let object = RKAURecoderandPlayer()
    
    @IBAction func onTest(_ sender: Any) {
        
        object.configRecorder()
        object.start()
    }

}

