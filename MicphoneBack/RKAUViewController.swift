//
//  RKAUViewController.swift
//  MicphoneBack
//
//  Created by Ricky on 17/1/11.
//  Copyright © 2017年 Ricky. All rights reserved.
//

import UIKit

class RKAUViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let rkAU = RKAURecoderandPlayer()
    var bConfigured = false

    @IBAction func onStartorStop(_ sender: Any) {
        if !bConfigured
        {
            bConfigured = rkAU.configRecorder()
        }
        
        let btn = sender as! UIButton
        if btn.isSelected{
            rkAU.stop()
            btn.isSelected = false
        }
        else{
            rkAU.start()
            btn.isSelected = true
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
