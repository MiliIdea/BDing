//
//  SignInViewController.swift
//  BDingTest
//
//  Created by Milad on 2/14/17.
//  Copyright © 2017 Milad. All rights reserved.
//

import UIKit

import Lottie

import CoreData

import CoreLocation

class SignInPageOneViewController: UIViewController {

    @IBOutlet weak var resumeButton: DCBorderedButton!
    
    @IBOutlet weak var mobileHint: UITextField!
    
    @IBOutlet weak var karbariText: UILabel!
    
    @IBOutlet weak var navigationTitle: UINavigationBar!
    
    @IBOutlet weak var signUpLink: UIButton!
    
    @IBOutlet weak var text: UILabel!
    
    var beaconBool : Bool = false
    
    var catBool : Bool = false
    
    var profileBool : Bool = false
    
    var animationView : LOTAnimationView?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MyFont().setMediumFont(view: self.resumeButton, mySize: 13)
        
        MyFont().setMediumFont(view: self.karbariText, mySize: 13)
        
        MyFont().setMediumFont(view: self.navigationTitle, mySize: 13)
        
        MyFont().setMediumFont(view: self.signUpLink, mySize: 10)
        
        MyFont().setMediumFont(view: self.text, mySize: 10)
        
        MyFont().setMediumFont(view: self.mobileHint, mySize: 15)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "pageOneToPageTwo"){
            let svc = segue.destination as! SignInPageTwoViewController
            
            svc.user = mobileHint.text!
            
        }
    }
 
    @IBAction func resumePressing(_ sender: DCBorderedButton) {
        
    }
    
    
    
}
