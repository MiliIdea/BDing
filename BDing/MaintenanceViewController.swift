//
//  MaintenanceViewController.swift
//  BDing
//
//  Created by MILAD on 12/16/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit

class MaintenanceViewController: UIViewController {

    
    @IBOutlet weak var maintenanceLabel: UILabel!
    
    @IBOutlet weak var okButton: DCBorderedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var str : String = ""
        
        str = "سرور بی دینگ در حال بروزرسانی است. لطفا " + GlobalFields.maintenanceTime! + " دیگر مجددا تلاش کنید. از صبر شما ممنونیم"
        
        maintenanceLabel.text = str
        
        okButton.cornerRadius = okButton.frame.height / 2
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ok(_ sender: Any) {
        //bayad biad birun az app
        exit(0)
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
