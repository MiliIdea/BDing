//
//  FurtherInformationViewController.swift
//  BDing
//
//  Created by MILAD on 11/22/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit
import DLRadioButton
import Lottie

class FurtherInformationViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var nameTextfield: UITextField!
    
    @IBOutlet weak var familyTextfield: UITextField!
    
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var birthdateButton: UIButton!
    
    @IBOutlet weak var womanButton: DLRadioButton!
    
    @IBOutlet weak var manButton: DLRadioButton!
    
    @IBOutlet weak var blurView: UIView!
    
    var animationView : LOTAnimationView?
    
    var gender : String?
    
    // MARK: - Birthdate input view
    
    @IBOutlet weak var birthdateInputView: DCBorderedView!
    
    @IBOutlet weak var birthdateDatePicker: UIDatePicker!
    
    // MARK: - Gift view
    
    @IBOutlet weak var giftView: DCBorderedView!
    
    @IBOutlet weak var giftText: UILabel!
    
    @IBOutlet weak var giftLottie: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.birthdateDatePicker.calendar = NSCalendar(identifier: NSCalendar.Identifier.persian) as Calendar!
        
        self.birthdateDatePicker.locale = NSLocale(localeIdentifier: "fa_IR") as Locale
        
        nameTextfield.delegate = self
        
        familyTextfield.delegate = self
        
        emailTextfield.delegate = self
        
        nameTextfield.text = GlobalFields.PROFILEDATA?.name
        
        familyTextfield.text = GlobalFields.PROFILEDATA?.family
        
        emailTextfield.text = GlobalFields.PROFILEDATA?.email
        
        if(GlobalFields.PROFILEDATA?.birthdate != nil && GlobalFields.PROFILEDATA?.birthdate != ""){
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "dd/MM/yyyy"
            
            formatter.calendar = Calendar(identifier: .gregorian)
            
            let d = formatter.date(from: (GlobalFields.PROFILEDATA?.birthdate)!)
            
            formatter.dateFormat = "yyyy/MM/dd"
            
            formatter.calendar = Calendar(identifier: .persian)
            
            self.birthdateButton.setTitle(formatter.string(from: d!), for: UIControlState.normal)
            
            self.birthdateDatePicker.setDate(d!, animated: false)
        }
        

        if(GlobalFields.PROFILEDATA?.gender == "male"){
            setMan("")
        }else{
            setWoman("")
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
    
    @IBAction func setMan(_ sender: Any) {
        self.manButton.isSelected = true
        self.womanButton.isSelected = false
        gender = "male"
    }
    
    @IBAction func setWoman(_ sender: Any) {
        self.manButton.isSelected = false
        self.womanButton.isSelected = true
        gender = "female"
    }
    
    @IBAction func setAllEdit(_ sender: Any) {
        
        let formatter = DateFormatter()
        
        var dat : String! = ""
        
        if(self.birthdateButton.title(for: .normal) != ""){
            
            formatter.dateFormat = "yyyy/MM/dd"
            
            formatter.calendar = Calendar(identifier: .persian)
            
            let d = formatter.date(from: self.birthdateButton.title(for: .normal)!)
            
            formatter.dateFormat = "dd/MM/yyyy"
            
            formatter.calendar = Calendar(identifier: .gregorian)
            
            dat = formatter.string(from: d!)
            
        }
        
        request(URLs.userUpdate , method: .post , parameters: UserUpdateRequestModel.init(NAME: self.nameTextfield.text, FAMILY: familyTextfield.text, EMAIL: emailTextfield.text, BIRTHDATE: dat ,PIC: nil ,GENDER: self.gender).getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()

            if let JSON = response.result.value {

                print("JSON ----------User Update----------->>>> " , JSON)

                let obj = ProfileResponseModel.init(json: JSON as! JSON)
                if(obj?.code == "5005"){
                    GlobalFields().goErrorPage(viewController: self)
                }
                if ( obj?.code == "200" ){

                    GlobalFields.PROFILEDATA?.name = self.nameTextfield.text
                    
                    GlobalFields.PROFILEDATA?.family = self.familyTextfield.text
                    
                    GlobalFields.PROFILEDATA?.email = self.emailTextfield.text
                    
                    GlobalFields.PROFILEDATA?.gender = self.gender
                    
                    let formatter = DateFormatter()
                    
                    formatter.dateFormat = "yyyy/MM/dd"
                    
                    formatter.calendar = Calendar(identifier: .persian)
                    
                    let d = formatter.date(from: self.birthdateButton.title(for: .normal)!)
                    
                    formatter.dateFormat = "dd/MM/yyyy"
                    
                    formatter.calendar = Calendar(identifier: .gregorian)
                    
                    GlobalFields.PROFILEDATA?.birthdate = formatter.string(from: d!)
                    
                    GlobalFields.PROFILEDATA?.all_coin = obj?.data?.all_coin
                    
                    if(obj?.data?.get_coin == "yes"){
                        
                        self.showGiftView()
                        
                        GlobalFields.get_coin = "yes"
                        
                    }else{
                        
                        Notifys().notif(message: "تغییرات با موفقیت ثبت شد!"){ alarm in
                            
                            self.present(alarm, animated: true,completion: nil)
                            
                        }
                        
                    }
                    
                }

            }

        }
        
    }
    
    @IBAction func showBirthdateInputView(_ sender: Any) {
        
        self.birthdateInputView.alpha = 1
        
        self.blurView.alpha = 0.5
        
    }
    
    @IBAction func confirmBirthdatePicker(_ sender: Any) {
        
        //set
        
        self.birthdateDatePicker.calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian) as Calendar!
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy/MM/dd"
        
        formatter.calendar = Calendar(identifier: .persian)
        
        self.birthdateButton.setTitle(formatter.string(from: self.birthdateDatePicker.date), for: UIControlState.normal)
        
        dismissBirthdateView("")
        
    }
    
    
    @IBAction func dismissBirthdateView(_ sender: Any) {
        
        self.birthdateInputView.alpha = 0
        
        self.blurView.alpha = 0
        
    }
    
    // GiftView
    
    @IBAction func closeGiftView(_ sender: Any) {
        
        giftView.alpha = 0
        
        self.blurView.alpha = 0
        
    }
    
    func showGiftView(){
        
        giftView.alpha = 1
        
        self.blurView.alpha = 0.5
        
        self.animationView = LOTAnimationView(name: "Gift")
        
        self.animationView?.frame = self.giftLottie.frame
        
        self.animationView?.contentMode = UIViewContentMode.scaleAspectFit
        
        self.animationView?.alpha = 1
        
        self.giftView.addSubview(self.animationView!)
        
        self.animationView?.loopAnimation = true
        
        self.animationView?.play()
        
        let text : String = "تبریک! شما " + GlobalFields.completionDing! + " دینگ هدیه دریافت کردید با دعوت از دوستانتان دینگ بیشتری کسب کنید"
        
        giftText.text = text
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            
        case nameTextfield:
            familyTextfield.becomeFirstResponder()
            familyTextfield.window?.makeKeyAndVisible()
            break
        case familyTextfield:
            emailTextfield.becomeFirstResponder()
            emailTextfield.window?.makeKeyAndVisible()
            break
        case emailTextfield:
            self.view.endEditing(true)
            self.showBirthdateInputView("")
            break
        default:
            self.view.endEditing(true)
            
        }
        
        return true
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    
    
    
    
    
    
    
    

}
