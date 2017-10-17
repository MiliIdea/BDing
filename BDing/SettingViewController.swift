//
//  SettingViewController.swift
//  BDing
//
//  Created by MILAD on 5/29/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit
import Lottie

class SettingViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate , UITextFieldDelegate{
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var rangePickerView: DCBorderedView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var changePasswordView: DCBorderedView!
    
    @IBOutlet weak var oldPass: UITextField!
   
    @IBOutlet weak var newPass: UITextField!
    
    @IBOutlet weak var reNewPass: UITextField!
    
    @IBOutlet weak var rangeButton: UIButton!
    
    
    var pickerDataSource = ["500", "1000", "1500", "2000"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

//        MyFont().setFontForAllView(view: self.view)
        
        rangeButton.setTitle(String(GlobalFields.BEACON_RANG), for: .normal)
        
        rangePickerView.alpha = 0
        
        changePasswordView.alpha = 0
        
        blurView.alpha = 0
        
        self.pickerView.dataSource = self
        
        self.pickerView.delegate = self
        
        oldPass.delegate = self
        
        newPass.delegate = self
        
        reNewPass.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        switch textField {
            
        case oldPass:
            newPass.becomeFirstResponder()
            newPass.window?.makeKeyAndVisible()
            break
        
        case newPass:
            reNewPass.becomeFirstResponder()
            reNewPass.window?.makeKeyAndVisible()
            break
            
        case reNewPass:
            self.view.endEditing(true)
            break
            
        default:
            textField.resignFirstResponder()
            
        }
        
        // Do not add a line break
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func changeRange(_ sender: Any) {
        
        rangePickerView.alpha = 1
        
        blurView.alpha = 0.9
        
    }
    
  
    @IBAction func changePassword(_ sender: Any) {
        
        changePasswordView.alpha = 1
        
        blurView.alpha = 0.9
        
    }
    
    @IBAction func confirmPicker(_ sender: Any) {
        
        let row = self.pickerView.selectedRow(inComponent: 0)
        
        if(row == 0){
            
            GlobalFields.BEACON_RANG = 500
            
        }else if(row == 1){
            
            GlobalFields.BEACON_RANG = 1000
            
        }else if(row == 2){
            
            GlobalFields.BEACON_RANG = 1500
            
        }else{
            
            GlobalFields.BEACON_RANG = 2000
            
        }
        
        rangeButton.setTitle(String(GlobalFields.BEACON_RANG), for: .normal)
        
        rangePickerView.alpha = 0
        
        changePasswordView.alpha = 0
        
        blurView.alpha = 0
        
    }
    
    @IBAction func canselPicker(_ sender: Any) {
        
        
        rangePickerView.alpha = 0
        
        changePasswordView.alpha = 0
        
        blurView.alpha = 0
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        
         _ = navigationController?.popViewController(animated: true)
        
    }
    
    var animationView : LOTAnimationView = LOTAnimationView.init()
    
    @IBAction func confirmNewPass(_ sender: Any) {
        
        if(newPass.text == reNewPass.text){
            
            animationView = LOTAnimationView(name: "finall")
            
            animationView.frame.size.height = 50
            
            animationView.frame.size.width = 50
            
            animationView.frame.origin.y = self.view.frame.height / 2 - 25
            
            animationView.frame.origin.x = self.view.frame.width / 2 - 25
            
            animationView.contentMode = UIViewContentMode.scaleAspectFit
            
            animationView.alpha = 1
            
            self.view.addSubview(animationView)
            
            animationView.loopAnimation = true
            
            animationView.play()
            
            self.view.isUserInteractionEnabled = false
            
            request(URLs.changePassword , method: .post , parameters: ChangePasswordRequestModel.init(NEW_PASS: newPass.text, OLD_PASS: oldPass.text).getParams(), encoding: JSONEncoding.default).responseJSON { response in
                print()
                
                print(ChangePasswordRequestModel.init(NEW_PASS: self.newPass.text, OLD_PASS: self.oldPass.text).getParams())
                
                if let JSON = response.result.value {
                    
                    self.animationView.pause()
                    
                    self.animationView.alpha = 0
                    
                    self.view.isUserInteractionEnabled = true
                    
                    print("JSON ----------SET NEW PASS----------->>>> " ,JSON)
                    //create my coupon response model
                    
                    if(CouponListResponseModel.init(json: JSON as! JSON)?.code == "200"){
                        
                        
                        self.rangePickerView.alpha = 0
                        
                        self.changePasswordView.alpha = 0
                        
                        self.blurView.alpha = 0
                        
                        
                    }
                    
                    print(JSON)
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func canselNewPass(_ sender: Any) {
        
        
        rangePickerView.alpha = 0
        
        changePasswordView.alpha = 0
        
        blurView.alpha = 0
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerDataSource.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerDataSource[row]
        
    }
    

    @IBAction func resetIndicator(_ sender: Any) {
        
        SaveAndLoadModel().deleteAllObjectIn(entityName: "SHOWCASE")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
}






