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
    
    @IBOutlet weak var recycleButton: DCBorderedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recycleButton.cornerRadius = recycleButton.frame.height / 2
        mobileBorder.cornerRadius = mobileBorder.frame.height / 2
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recycle(_ sender: Any) {
        
        firstAnimate()
        
        request(URLs.forgotPassword , method: .post , parameters: ForgotpasswordRequestModel(USERNAME: mobile.text).getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------FORGOT PASSWORD----------->>>> " , JSON)
                
                let obj = CategoryListResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                    
                    self.view.endEditing(true)
                    
//                    Notifys().notif(message: "رمز عبور جدید شما برایتان ارسال شد!"){ alarm in
//
//                        self.present(alarm, animated: true,completion: nil)
//
//                    }
                    
                    self.back("oke")
                    
                    self.secondAnimate()
                    
                }else{
                    
                    self.view.endEditing(true)
            
                    Notifys().notif(message: "نام کاربری شما یافت نشد!"){ alarm in
                        
                        self.present(alarm, animated: true, completion: nil)
                        
                    }
                    
                    self.secondAnimate()
                    
                }
                
                
            }
            
        }
        

        
    }
    
    
    func firstAnimate(){
        
        self.view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.recycleButton.frame.size.width = self.recycleButton.frame.height
            
            self.recycleButton.normalTextColor = self.recycleButton.normalBackgroundColor
            
            self.recycleButton.frame.origin.x = self.view.frame.width / 2 - self.recycleButton.frame.height / 2
            
        }){completion in
            
            self.animationView = LOTAnimationView(name: "finall")
            
            self.animationView?.frame.size.height = self.recycleButton.frame.height
            
            self.animationView?.frame.size.width = self.recycleButton.frame.height
            
            self.animationView?.frame.origin.y =  self.recycleButton.frame.origin.y
            
            self.animationView?.frame.origin.x = self.view.frame.width / 2 - self.recycleButton.frame.height / 2
            
            self.animationView?.contentMode = UIViewContentMode.scaleAspectFit
            
            self.animationView?.alpha = 1
            
            self.view.addSubview(self.animationView!)
            
            self.animationView?.loopAnimation = true
            
            self.animationView?.play()
            
        }
        
    }
    
    func secondAnimate(){
        
        self.view.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.recycleButton.frame.size.width = self.view.frame.width * 145 / 375
            
            self.recycleButton.normalTextColor = UIColor.init(hex: "ffffff")
            
            self.recycleButton.frame.origin.x = self.view.frame.width / 2 - (self.view.frame.width * 145 / 375) / 2
            
        }){completion in
            
            self.animationView?.alpha = 0
            
            self.animationView?.stop()
            
        }
        
    }
    
    
    
    
    
    @IBAction func back(_ sender: Any) {
        
        if((sender is String)){
            self.navigationController?.popViewController(animated: true)
            (self.navigationController?.topViewController as! AuthenticationViewController).loginUserField.text = self.mobile.text
            
        }else{
        
            self.navigationController?.popViewController(animated: true)
            
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
