//
//  ActivationCodeViewController.swift
//  BDing
//
//  Created by MILAD on 5/10/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit

import CoreData

import CoreLocation

import Lottie


class ActivationCodeViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var emailAndTellNotify: UILabel!
    
    @IBOutlet weak var timeRemaining: UILabel!
    
    @IBOutlet weak var resendButton: UIButton!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    
    var upRequest : SignUpRequestModel?
    
    var userName : String?
    
    var password : String?
    
    var beaconBool : Bool = false
    
    var catBool : Bool = false
    
    var profileBool : Bool = false
    
    var loginBool : Bool = false
    
    var animationView : LOTAnimationView?
    
    var timeIsZero : Bool = false
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        MyFont().setFontForAllView(view: self.view)
        
        setTargetForAllView(view: view)
        
        var note : String = ""
        
        note.append("ما یک کد فعالسازی شش رقمی به ")
        
        note.append(userName!)
        
        note.append(" ارسال کردیم.")
        
        self.emailAndTellNotify.text = note
        
        timeIsZero = false
        
        timeRemaining.text = "100"
        
        var timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update(){
        
        if(timeIsZero == false){
            
            resendButton.isEnabled = false
            
            timeRemaining.alpha = 1
            
//            resendButton.backgroundColor = UIColor.lightGray
            
            timeRemaining.text = String((Int(timeRemaining.text!)! - 1))
            
            if(timeRemaining.text == "0"){
                
                timeIsZero = true
                
                timeRemaining.alpha = 0
                
//                resendButton.setTitleColor(MyColors.greenColor , for : UIControlState.normal)
                
                
                
            }
            
        }else{
            
            timeRemaining.alpha = 0
            
            resendButton.isEnabled = true
            
//            resendButton.setTitleColor(MyColors.greenColor , for : UIControlState.normal)
            
        }
        
    }
    
    
    func textChanged(sender: Any!) {
        
        print("changed")
        
        let t = (sender as! UITextField)
        
        if(t.tag < 6){
            
            (self.view.viewWithTag(t.tag + 1) as! UITextField).becomeFirstResponder()
            
        }else if(t.tag == 6){
            
            self.view.endEditing(true)
            
            //send code
            
            var code : String = ""
            
            for i in 1...6 {
                
                code.append((self.view.viewWithTag(i) as! UITextField).text!)
                
            }
            
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
            
            request(URLs.activationCode , method: .post , parameters: ActivationCodeRequestModel(USERNAME: userName, CODE: code).getParams(), encoding: JSONEncoding.default).responseJSON { response in
                print()
                
                if let JSON = response.result.value {
                    
                    print("JSON ----------ACTIVATIONCODE----------->>>> " , JSON)
                    
//                    code = 200;
//                    msg = "active account";
//                    status = true;
//                    type = success;
                    
                    let obj = ProfileResponseModel.init(json: JSON as! JSON)
                    
                    if ( obj?.code == "200" ){
                        
                        //automat bayad login konam
                        
                        self.signIn()
                        
                        
                    }
                    
                }
                
            }
            
            
        }
        
        
    }
    
    func textSelected(sender: Any!) {
        
        print("changed")
        
        let t = (sender as! UITextField)
        
        t.text = ""
        
        
    }
    
    

    @IBAction func reSendCode(_ sender: Any) {
        
        if(timeIsZero){
          
            timeIsZero = false
            
            timeRemaining.text = "100"
            
            timeRemaining.alpha = 1
            
//            resendButton.setTitleColor(UIColor.lightGray , for : UIControlState.normal)
            
            resendButton.isEnabled = false
            
            //resend data
            
            request(URLs.signUpUrl , method: .post , parameters: upRequest?.getParams(), encoding: JSONEncoding.default).responseJSON { response in
                print()
                
                if let JSON = response.result.value {
                    
                    print("JSON: \(JSON)")
                    
                    if(SignUpResponseModel.init(json: JSON as! JSON).code == "200"){
                        
                        //notify ferestade shod
                        self.navigationController?.pushViewController(SignInPageOneViewController() as! UIViewController, animated: true)
                        
                    }
                    
                }
                
            }
            
            
            
            
        }

        
        
    }

    @IBAction func editInfo(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func setTargetForAllView(view : UIView){
        
        for v in view.subviews{
            
            if(v is UITextField){
                
                var t: UITextField = v as! UITextField
                
                t.delegate = self
                
                t.addTarget(
                    nil,
                    action: #selector(self.textChanged(sender:)),
                    for: UIControlEvents.editingChanged
                )
                
                t.addTarget(
                    nil,
                    action: #selector(self.textSelected(sender:)),
                    for: UIControlEvents.editingDidBegin
                )
            }
            
            if(v.subviews.count != 0){
                
                self.setTargetForAllView(view: v)
                
            }else{
                
                if(v is UITextField){
                    
                    var t: UITextField = v as! UITextField
                    
                    t.delegate = self
                    
                    t.addTarget(
                        nil,
                        action: #selector(self.textChanged(sender:)),
                        for: UIControlEvents.editingChanged
                    )
                    
                    t.addTarget(
                        nil,
                        action: #selector(self.textSelected(sender:)),
                        for: UIControlEvents.editingDidBegin
                    )
                    
                }
                
            }
            
        }
        
    }
    
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    
    func signIn(){
        
        let s = SignInRequestModel(USERNAME: userName, PASSWORD: password)
        
        print(s.getParams())
        
        self.view.endEditing(true)
        
        request(URLs.signInUrl , method: .post , parameters: s.getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON -----------SIGNIN---------->>>> " , JSON)
                
                let obj = SignInResponseModel.init(json: JSON as! JSON)
                
                if ( obj.code == "200" ){
                    
                    print(obj.token ?? "null")
                    
                    SaveAndLoadModel().deleteAllObjectIn(entityName: "USER")
                    
                    let b = SaveAndLoadModel().save(entityName: "USER", datas: ["user":s.USERNAME , "password":s.PASSWORD , "token":obj.token! , "userID" : obj.userID!])
                    
                    
                    ///
                    
                    self.loadTabView()
                    
                    
                    print(SaveAndLoadModel().load(entity: "USER")?.count ?? "nothing!")
                    
                    self.loginBool = true
                    
                    self.goNextView()
                    
                }else if(obj.code == "9000"){
                    
                    
                    
                
                }else{
                    
                    self.animationView?.pause()
                    
                    self.animationView?.alpha = 0
                    
                    self.view.endEditing(false)
                    
                }
                
            }
            
        }
        
    }
        
    
    func goNextView(){
        
        if(self.profileBool && !self.beaconBool && self.catBool && self.loginBool){
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
            
            self.present(nextViewController, animated:true, completion:nil)
            
        }
        
    }
    
    
    func loadTabView() {
        
        // get profile
        
        request(URLs.getProfile , method: .post , parameters: ProfileRequestModel().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------PROFILE----------->>>> " , JSON)
                
                let obj = ProfileResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                    
                    self.profileBool = true
                    
                    GlobalFields.PROFILEDATA = obj?.data
                    
                    self.goNextView()
                }
                
            }
            
        }
        
        // get index Home
        
        var lat: String
        
        var long: String
        
        let locManager = CLLocationManager()
        
        locManager.requestWhenInUseAuthorization()
        
        var currentLocation = CLLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized){
            
            currentLocation = locManager.location!
            
        }
        
        //        long = String(currentLocation.coordinate.longitude)
        //
        //        lat = String(currentLocation.coordinate.latitude)
        
        long = String(51.4212297)
        
        lat = String(35.6329044)
        
//        request(URLs.getBeaconList , method: .post , parameters: BeaconListRequestModel(LAT: lat, LONG: long, REDIUS: nil, SEARCH: nil, CATEGORY: nil, SUBCATEGORY: nil).getParams(allSearch : true), encoding: JSONEncoding.default).responseJSON { response in
//            print()
//            
//            if let JSON = response.result.value {
//                
//                print("JSON ----------BEACON----------->>>> ")
//                
//                let obj = BeaconListResponseModel.init(json: JSON as! JSON)
//                
//                if ( obj?.code == "200" ){
//                    
//                    GlobalFields.BEACON_LIST_DATAS = obj?.data
//                    
//                    self.beaconBool = true
//                    
//                    self.goNextView()
//                    
//                }
//                
//            }
//            
//        }
        
        //get category
        
        
        request(URLs.getCategory , method: .post , parameters: CategoryRequestModel().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------Category----------->>>> ")
                
                let obj = CategoryListResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                    
                    GlobalFields.CATEGORIES_LIST_DATAS = obj?.data
                    
                    self.catBool = true
                    
                    self.goNextView()
                    
                }
                
            }
            
        }
        
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
    
    }











