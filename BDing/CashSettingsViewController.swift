
//  CashSettingsViewController.swift
//  BDing
//
//  Created by MILAD on 2/27/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit

class CashSettingsViewController: UIViewController {
    @IBOutlet weak var isOnScreenSw: UISwitch!
    
    @IBOutlet weak var isOnRefreshing: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(UIApplication.shared.isIdleTimerDisabled){
            
            isOnScreenSw.setOn(true, animated: false)
        }
        
        if(GlobalFields.autoUpdate){
            
            isOnRefreshing.setOn(true, animated: false)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func switchScreen(_ sender: Any) {
        
        var swi : UISwitch = sender as! UISwitch
        
        if(swi.isOn){
            UIApplication.shared.isIdleTimerDisabled = true
        }else{
            UIApplication.shared.isIdleTimerDisabled = false
        }
        
    }
    
    @IBAction func autoUpdate(_ sender: Any) {
        
        var swi : UISwitch = sender as! UISwitch
        
        if(swi.isOn){
            GlobalFields.autoUpdate = true
        }else{
            GlobalFields.autoUpdate = false
        }
        
    }
    
    
}
