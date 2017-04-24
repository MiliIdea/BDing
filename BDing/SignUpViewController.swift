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
    
    @IBOutlet weak var mobileOrEmail: UITextField!
    
    @IBOutlet weak var noticeText: UILabel!

    @IBOutlet weak var activate1: UILabel!
    
    @IBOutlet weak var termsLink: DCBorderedButton!
    
    @IBOutlet weak var activate3: UILabel!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var familyName: UITextField!
    
    @IBOutlet weak var gender: UITextField!
    
    @IBOutlet weak var mobile: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var expandedBox: UIView!
    
    
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
            self.mobile.becomeFirstResponder()
            
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
            
        case mobileOrEmail:
            password.becomeFirstResponder()
            
//        case password:
//            print("inja bas confirm kone!")
            
        case name:
            familyName.becomeFirstResponder()
            
        case familyName:
            gender.becomeFirstResponder()
            self.dropDown.show()
            
        case gender:
            if(dropDown.selectedItem != "مرد" && dropDown.selectedItem != "زن"){
                return false
            }
            
            gender.text = dropDown.selectedItem
            dropDown.hide()
            mobile.becomeFirstResponder()
        
        case mobile:
            email.becomeFirstResponder()
            
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
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.signUpScrollView.contentOffset.y = textField.frame.origin.y + 40
            
            if(textField == self.gender){
                
                self.dropDown.show()
                
                self.signUpScrollView.contentOffset.y += 80
                
            }
            
        }, completion:nil)
        
        print(textField.frame.origin.y)
        
    }
    
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0,y: 0,width: 320,height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.done, target: self, action: #selector(SignUpViewController.doneButtonAction))
        
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
        
        self.mobileOrEmail.inputAccessoryView = doneToolbar2
        
    }
    
    func doneButtonAction()
    {
        self.email.becomeFirstResponder()
    }
    
    func doneButtonAction2()
    {
        self.password.becomeFirstResponder()
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
        
        let m = SignUpRequestModel(USERNAME: mobileOrEmail.text, PASSWORD: password.text)
        
        print(m.getParams())
        
        request(URLs.signUpUrl , method: .post , parameters: m.getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON: \(JSON)")
                
                if(SignUpResponseModel.init(json: JSON as! JSON).code == "200"){
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignInPageOneViewController") as! SignInPageOneViewController
                    
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
