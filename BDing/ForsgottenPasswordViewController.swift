//
//  ForsgottenPasswordViewController.swift
//  BDing
//
//  Created by MILAD on 10/2/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit
import Lottie

class ForsgottenPasswordViewController: UIViewController {
    
    @IBOutlet weak var mobile: UITextField!
    
    @IBOutlet weak var mobileBorder: DCBorderedView!
    
    var animationView : LOTAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recycle(_ sender: Any) {
        
        animationView = LOTAnimationView(name: "finall")
        
        animationView?.frame.size.height = 50
        
        animationView?.frame.size.width = 50
        
        animationView?.frame.origin.y = self.view.frame.height / 2 - 25
        
        animationView?.frame.origin.x = self.view.frame.width / 2 - 25
        
        animationView?.contentMode = UIViewContentMode.scaleAspectFit
        
        animationView?.alpha = 1
        
        self.view.addSubview(animationView!)
        
        animationView?.loopAnimation = true
        
        animationView?.play()
        
        request(URLs.forgotPassword , method: .post , parameters: ForgotpasswordRequestModel(USERNAME: mobile.text).getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------FORGOT PASSWORD----------->>>> " , JSON)
                
                let obj = CategoryListResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                    
                    self.view.endEditing(true)
                    
                    self.animationView?.pause()
                    
                    self.animationView?.alpha = 0
                    
                    Notifys().notif(message: "رمز عبور جدید شما برایتان ارسال شد!"){ alarm in
                        
                        self.present(alarm, animated: true, completion: nil)
                        
                    }
                    
                    self.navigationController?.popViewController(animated: true)
                    
                }else{
                    
                    self.view.endEditing(true)
                    
                    self.animationView?.pause()
                    
                    self.animationView?.alpha = 0
                    
                    Notifys().notif(message: "نام کاربری شما یافت نشد!"){ alarm in
                        
                        self.present(alarm, animated: true, completion: nil)
                        
                    }
                    
                }
                
                
            }
            
        }
        

        
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
