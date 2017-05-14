//
//  SignUpViewController.swift
//  BDingTest
//
//  Created by Milad on 2/15/17.
//  Copyright © 2017 Milad. All rights reserved.
//

import UIKit


class SignUpViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var signUpScrollView: UIScrollView!

    @IBOutlet weak var scrollViewSubView: UIView!
    
    @IBOutlet weak var mobile: UITextField!
    
    @IBOutlet weak var noticeText: UILabel!

    @IBOutlet weak var activate1: UILabel!
    
    @IBOutlet weak var termsLink: DCBorderedButton!
    
    @IBOutlet weak var activate3: UILabel!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var familyName: UITextField!
    
    @IBOutlet weak var gender: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var expandedBox: UIView!
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var confirmationPass: UITextField!
    
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        for subView in scrollViewSubView.subviews {
            MyFont().setMediumFont(view: subView, mySize: 13)
        }
        MyFont().setMediumFont(view: noticeText, mySize: 9)
        MyFont().setMediumFont(view: activate3, mySize: 9)
        MyFont().setMediumFont(view: activate1, mySize: 9)
        MyFont().setMediumFont(view: termsLink, mySize: 9)
        
        
        signUpScrollView.addSubview(scrollViewSubView)
        
        signUpScrollView.contentSize = scrollViewSubView.frame.size
        
        self.addDoneButtonOnKeyboard()
        
        mobile.delegate = self
        
        userName.delegate = self
        
        password.delegate = self
        
        confirmationPass.delegate = self
        
        name.delegate = self
        
        familyName.delegate = self
        
        gender.delegate = self
        
        DropDown.startListeningToKeyboard()
        
        // The view to which the drop down will appear on
        dropDown.anchorView = gender.plainView
        
        dropDown.direction = .bottom
        
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)! - 15)
        
        dropDown.sizeToFit()
        
        dropDown.dataSource = ["مرد","زن"]
        
        dropDown.width = gender.frame.width + 3
        
        dropDown.cellHeight = 40
        
        dropDown.textFont = UIFont(name: "IRANSansWeb-Medium", size: 13)!
        
        dropDown.hide()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.gender.text = item
            self.dropDown.hide()
            self.email.becomeFirstResponder()
            self.email.window?.makeKeyAndVisible()
            
        }
        
        mobile.delegate = self
        
        email.delegate = self
        
        name.tag = 0
        
        familyName.tag = 0
        
        mobile.tag = 0
        
        email.tag = 0
        

        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        switch textField {
            
        case mobile:
            userName.becomeFirstResponder()
            userName.window?.makeKeyAndVisible()
            break
            
        case userName:
            password.becomeFirstResponder()
            password.window?.makeKeyAndVisible()
            break
            
        case password:
            confirmationPass.becomeFirstResponder()
            confirmationPass.window?.makeKeyAndVisible()
            break
            
        case name:
            familyName.becomeFirstResponder()
            familyName.window?.makeKeyAndVisible()
            break
            
        case familyName:
            gender.becomeFirstResponder()
            gender.window?.makeKeyAndVisible()
            self.dropDown.show()
            break
            
        case gender:
            if(dropDown.selectedItem != "مرد" && dropDown.selectedItem != "زن"){
                return false
            }
            break
            
            gender.text = dropDown.selectedItem
            dropDown.hide()
            email.becomeFirstResponder()
            email.window?.makeKeyAndVisible()
            
//        case email:
//            print("inja bas confirm kone!")
            
        default:
            textField.resignFirstResponder()
            UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.signUpScrollView.contentOffset.y = 0
                
            }, completion:nil)
        }
        
        
        
        // Do not add a line break
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            print(textField.frame.origin.y)
            
            print(self.signUpScrollView.contentOffset.y)
            
            self.signUpScrollView.contentOffset.y = textField.frame.origin.y + 40
            
            if(textField == self.name || textField == self.familyName || textField == self.gender || textField == self.email){
                print("expaaaanded BoOoxX")
                print(self.expandedBox.frame.origin.y)
                self.signUpScrollView.contentOffset.y += self.expandedBox.frame.origin.y
                
            }
            
            if(textField == self.gender){
                
                self.dropDown.show()
                
//                self.signUpScrollView.contentOffset.y += 80
                
            }
            
        }, completion:nil)
        
        print(textField.frame.origin.y)
        
    }
    
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0,y: 0,width: 320,height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "NEXT", style: UIBarButtonItemStyle.done, target: self, action: #selector(SignUpViewController.doneButtonAction))
        
        done.tintColor = UIColor.green
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.mobile.inputAccessoryView = doneToolbar
        ////////////////////2/////////////////////
        let doneToolbar2: UIToolbar = UIToolbar(frame: CGRect(x: 0,y: 0,width: 320,height: 50))
        doneToolbar2.barStyle = UIBarStyle.default
        
        let flexSpace2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done2: UIBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.done, target: self, action: #selector(SignUpViewController.doneButtonAction2))
        
        done2.tintColor = UIColor.green
        
        var items2 = [UIBarButtonItem]()
        items2.append(flexSpace2)
        items2.append(done2)
        
        doneToolbar2.items = items2
        doneToolbar2.sizeToFit()
        
//        self.email.inputAccessoryView = doneToolbar2
        
    }
    
    func doneButtonAction()
    {
        self.userName.becomeFirstResponder()
        userName.window?.makeKeyAndVisible()
    }
    
    func doneButtonAction2()
    {
//        self.confirmationPass.becomeFirstResponder()
    }
    

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
        
    }
    
    
    @IBAction func expanding(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            if(self.expandedBox.alpha == 0){
                
                self.expandedBox.alpha = 1
                self.signUpScrollView.isScrollEnabled = true
                self.signUpScrollView.contentOffset.y = 0
                
            }else{
                
                self.expandedBox.alpha = 0
                self.signUpScrollView.isScrollEnabled = false
                self.signUpScrollView.contentOffset.y = -30
                
            }
            
        }, completion:nil)
        
        
    }
    
    
    
    @IBAction func register(_ sender: Any) {
        //, MOBILE : mobile.text
        
        
        if(password.text != confirmationPass.text){
            
            print("alo alo man jujuam ... he he")
            
            return
            
        }
        
        if((password.text?.characters.count)! < 6){
            
            print("alo alo un jujue")
            
            return
            
        }
        
        if(!(email.text?.contains("@"))! && (email.text != "" && email.text != nil)){
            
            print("email doros nis!!!")
            
            return
            
        }
        
        var gender2 : String = self.gender.text!
        
        if(gender2 == "مرد"){
            
            gender2 = "male"
            
        }else if(gender2 == "زن"){
            
            gender2 = "female"
            
        }
        
        let m = SignUpRequestModel(USERNAME: mobile.text, PASSWORD: password.text, SOCIALNAME: userName.text, GENDER: gender2, BDATE: nil, NAME: name.text, FAMILYNAME: familyName.text, EMAIL: email.text)
        
        print(m.getParams())
        
        request(URLs.signUpUrl , method: .post , parameters: m.getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON: \(JSON)")
                
                if(SignUpResponseModel.init(json: JSON as! JSON).code == "200"){
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ActivationCodeViewController") as! ActivationCodeViewController
                    
                    nextViewController.userName = self.mobile.text
                    
                    nextViewController.password = self.password.text
                    
                    nextViewController.upRequest = m
                    
                    self.present(nextViewController, animated:true, completion:nil)
                    
                }
                
            }
            
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
