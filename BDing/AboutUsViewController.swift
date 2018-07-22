//
//  AboutUsViewController.swift
//  BDing
//
//  Created by MILAD on 5/24/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var textDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MyFont().setLightFont(view: textDescription, mySize: 15)
        
        MyFont().setWebFont(view: versionLabel, mySize: 16)
        
        versionLabel.text = ((Bundle.main.infoDictionary?["CFBundleShortVersionString"]) as! String) + "." + (Bundle.main.infoDictionary?["CFBundleVersion"] as! String)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
