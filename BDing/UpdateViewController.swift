//
//  UpdateViewController.swift
//  BDing
//
//  Created by MILAD on 12/16/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit

class UpdateViewController: UIViewController {

    @IBOutlet weak var downloadButton: DCBorderedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadButton.cornerRadius = downloadButton.frame.height / 2
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func download(_ sender: Any) {
        
        UIApplication.shared.openURL(NSURL(string: "https://new.sibapp.com/applications/bding") as! URL)
        
    }
    
    @IBAction func enterToApp(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        
        self.present(nextViewController, animated:true, completion:nil)
        
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
