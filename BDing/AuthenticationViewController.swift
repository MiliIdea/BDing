//
//  AuthenticationViewController.swift
//  BDing
//
//  Created by MILAD on 9/27/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit
import Lottie
import CoreLocation

class AuthenticationViewController: UIViewController , UITextFieldDelegate {

    // MARK: - GlobalFields
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loginUnderLineLabel: UILabel!
    
    @IBOutlet weak var signUpView: UIView!
    
    @IBOutlet weak var loginView: UIView!
    
    var animationView : LOTAnimationView?
    
    @IBOutlet weak var topImage: UIImageView!
    
    
    // MARK: - LoginFields
    
    @IBOutlet weak var loginUserBorder: DCBorderedView!
    
    @IBOutlet weak var loginPasswordBorder: DCBorderedView!
    
    @IBOutlet weak var loginUserField: UITextField!
    
    @IBOutlet weak var loginPasswordField: UITextField!
    
    @IBOutlet weak var loginLoginButton: DCBorderedButton!
    
    @IBOutlet weak var loginForgottenButton: UIButton!
    
    var beaconBool : Bool = false
    
    var catBool : Bool = false
    
    var profileBool : Bool = false
    
    var loginBool : Bool = false
    
    var haveUpdate : Bool = false
    // MARK: - SignUpFields
    
    @IBOutlet weak var signUpUserBorder: DCBorderedView!
    
    @IBOutlet weak var signUpMobileBorder: DCBorderedView!
    
    @IBOutlet weak var signUpPasswordBorder: DCBorderedView!
    
    @IBOutlet weak var signUpUserField: UITextField!
    
    @IBOutlet weak var signUpMobileField: UITextField!
    
    @IBOutlet weak var signUpPasswordField: UITextField!
    
    @IBOutlet weak var signUpsignUpButton: DCBorderedButton!
    
    // MARK: - InvitationCodeFields
    
    @IBOutlet weak var invitationCodeText: UITextField!
    
    @IBOutlet weak var invitationCodeBorder: DCBorderedView!
    
    @IBOutlet weak var invitationCodeView: UIView!
    
    
    @IBOutlet weak var invitationSignUpButton: DCBorderedButton!
    
    @IBOutlet weak var invitationLabelText: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginUserField.delegate = self
        
        loginPasswordField.delegate = self
        
        signUpUserField.delegate = self
        
        signUpMobileField.delegate = self
        
        signUpPasswordField.delegate = self
        
        loginLoginButton.cornerRadius = loginLoginButton.frame.height / 2
        
        signUpsignUpButton.cornerRadius = signUpsignUpButton.frame.height / 2
        
        setColorViews()
        
        loginPageClicked("")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - LoginMethods
    
    @IBAction func signingIn(_ sender: Any) {
        
        let s = SignInRequestModel(USERNAME: loginUserField.text, PASSWORD: loginPasswordField.text)
        
        print(s.getParams())
        
        self.view.endEditing(true)
        
        loginFirstAnimate()
        
        request(URLs.signInUrl , method: .post , parameters: s.getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print(response)
            print(String(describing: response.debugDescription))
            print(String(describing: response.description))
            
            if let JSON = response.result.value {
                
                print("JSON -----------SIGNIN---------->>>> " , JSON)
                
                let obj = SignInResponseModel.init(json: JSON as! JSON)
                
                if(obj.code == "5005"){
                    GlobalFields().goErrorPage(viewController: self)
                }
                
                if ( obj.code == "200" ){
                    
                    print(obj.token ?? "null")
                    
                    SaveAndLoadModel().deleteAllObjectIn(entityName: "USER")
                    
                    let b = SaveAndLoadModel().save(entityName: "USER", datas: ["user":s.USERNAME , "password":s.PASSWORD , "token":obj.token! , "userID" : obj.userID!])
                    
                    
                    ///
                    
                    self.loadTabView()
                    
                    print(SaveAndLoadModel().load(entity: "USER")?.count ?? "nothing!")
                    
                    if(obj.data?.has_update == "true"){
                        self.haveUpdate = true
                    }
                    
                    self.loginBool = true
                    
                    self.goNextView()
                    
                }else if(obj.code == "9000"){
                    
                    GlobalFields().goFourceUpdatePage(viewController: self)
                    
                }else if(obj.code == "8001"){
                    
                    GlobalFields().goMaintenancePage(viewController: self)
                    
                }else{
                    
                    self.secondAnimate()
                    
                    self.view.endEditing(false)
                    
                    Notifys().notif(message: obj.msg ?? "شماره تلفن یا رمز عبور اشتباه می باشد!"){ alarm in
                        
                        self.present(alarm, animated: true, completion: nil)
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func loginFirstAnimate(){
        
        self.view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.loginLoginButton.frame.size.width = self.loginLoginButton.frame.height
            
            self.loginLoginButton.normalTextColor = self.loginLoginButton.normalBackgroundColor
            
            self.loginLoginButton.frame.origin.x = self.loginView.frame.width / 2 - self.loginLoginButton.frame.height / 2
            
            }){completion in
                
                self.animationView = LOTAnimationView(name: "finall")
                
                self.animationView?.frame.size.height = self.loginLoginButton.frame.height
                
                self.animationView?.frame.size.width = self.loginLoginButton.frame.height
                
                self.animationView?.frame.origin.y = self.loginView.frame.origin.y + self.loginLoginButton.frame.origin.y
                
                self.animationView?.frame.origin.x = self.view.frame.width / 2 - self.loginLoginButton.frame.height / 2
                
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
            
            self.loginLoginButton.frame.size.width = self.view.frame.width * 145 / 375
            
            self.loginLoginButton.normalTextColor = UIColor.init(hex: "ffffff")
            
            self.loginLoginButton.frame.origin.x = self.loginView.frame.width / 2 - (self.view.frame.width * 145 / 375) / 2
            
        }){completion in
            
            self.animationView?.alpha = 0
            
            self.animationView?.stop()
            
        }
        
    }
    
    
    func loadTabView() {
        
        // get profile
        
        request(URLs.getProfile , method: .post , parameters: ProfileRequestModel().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------PROFILE----------->>>> " , JSON)
                
                let obj = ProfileResponseModel.init(json: JSON as! JSON)
                
                if(obj?.code == "5005"){
                    GlobalFields().goErrorPage(viewController: self)
                }
                
                if ( obj?.code == "200" ){
                    
                    GlobalFields.PROFILEDATA = obj?.data
                    
                    self.profileBool = true
                    
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
        
        long = String(currentLocation.coordinate.longitude)
        
        lat = String(currentLocation.coordinate.latitude)
        
        if(lat == "0" && long == "0"){
            
            long = String(51.4212297)
            
            lat = String(35.6329044)
            
        }
        
        print("lat and long")
        print(lat)
        print(long)
        
        //get category
        
        
        request(URLs.getCategory , method: .post , parameters: CategoryRequestModel().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------Category----------->>>> ")
                
                let obj = CategoryListResponseModel.init(json: JSON as! JSON)
                
                if(obj?.code == "5005"){
                    GlobalFields().goErrorPage(viewController: self)
                }
                
                if ( obj?.code == "200" ){
                    
                    GlobalFields.CATEGORIES_LIST_DATAS = obj?.data
                    
                    self.catBool = true
                    
                    self.goNextView()
                    
                }
                
            }
            
        }
        
        
        request(URLs.getPayUuids , method: .post , parameters: PayUuidsRequestModel().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------PAY UUID----------->>>> " , JSON)
                
                let obj = PayUuidResponseModel.init(json: JSON as! JSON)
                
                if(obj?.code == "5005"){
                    GlobalFields().goErrorPage(viewController: self)
                }
                
                if ( obj?.code == "200" ){
                    
                    GlobalFields.PAY_UUIDS = obj?.result
                    
                }
                
            }
            
        }
        
        
        
        
        
    }
    
    func goNextView(){
        
        if(self.profileBool && !self.beaconBool && self.catBool && self.loginBool){
            
            if(self.haveUpdate == true){
                
                GlobalFields().goUpdatePage(viewController: self)
                
            }else{
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                
                self.present(nextViewController, animated:true, completion:nil)
                
            }
            
        }
        
    }

    
    //MARK: - SignUpMethods
    
    @IBAction func signingUp(_ sender: Any) {
        
        let m = CheckRequestModel.init(USERNAME: signUpMobileField.text, SOCIALNAME: signUpUserField.text)
        
        print(m.getParams())
        
        signUpFirstAnimate()
        
        self.view.isUserInteractionEnabled = false
        
        request(URLs.checkSignUp , method: .post , parameters: m.getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON: \(JSON)")
                
                if(CheckResponseModel.init(json: JSON as! JSON).code == "5005"){
                    GlobalFields().goErrorPage(viewController: self)
                }
                
                if(CheckResponseModel.init(json: JSON as! JSON).code == "200"){
                    
                    self.view.isUserInteractionEnabled = true
                    
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    
                        self.invitationCodeView.alpha = 1
                        
                    },completion : nil)
                    
                    GlobalFields.invitationDing = CheckResponseModel.init(json: JSON as! JSON).data?.invite_friends
                    
                    GlobalFields.completionDing = CheckResponseModel.init(json: JSON as! JSON).data?.completing_the_profile
                    
                    let text : String = "اگر معرف دارید کد آن را وارد کنید و " + GlobalFields.registered_with_invite_code! + " امتیاز دریافت کنید"
                    
                    self.invitationLabelText.text = text
                    
                    self.secondSignUpAnimate()
                    
                }else if(CheckResponseModel.init(json: JSON as! JSON).code == "501"){
                    
                    self.secondSignUpAnimate()
                    
                    Notifys().notif(message: CheckResponseModel.init(json: JSON as! JSON).msg ?? "قبلا ثبت نام کرده اید!"){alarm in
                        
                        self.present(alarm, animated: true, completion: nil)
                        
                    }
                    
                }else {
                    
                    self.secondSignUpAnimate()
                    
                    Notifys().notif(message: CheckResponseModel.init(json: JSON as! JSON).msg){alarm in
                        
                        self.present(alarm, animated: true, completion: nil)
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func goConditionsLink(_ sender: Any) {
        
        UIApplication.shared.openURL(NSURL(string: "http://bding.ir/fa/terms")! as URL)
        
    }
    
    func signUpFirstAnimate(){
        
        self.view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.signUpsignUpButton.frame.size.width = self.signUpsignUpButton.frame.height
            
            self.signUpsignUpButton.normalTextColor = self.signUpsignUpButton.normalBackgroundColor
            
            self.signUpsignUpButton.frame.origin.x = self.signUpView.frame.width / 2 - self.signUpsignUpButton.frame.height / 2
            
        }){completion in
            
            self.animationView = LOTAnimationView(name: "finall")
            
            self.animationView?.frame.size.height = self.signUpsignUpButton.frame.height
            
            self.animationView?.frame.size.width = self.signUpsignUpButton.frame.height
            
            self.animationView?.frame.origin.y = self.signUpView.frame.origin.y + self.signUpsignUpButton.frame.origin.y
            
            self.animationView?.frame.origin.x = self.view.frame.width / 2 - self.signUpsignUpButton.frame.height / 2
            
            self.animationView?.contentMode = UIViewContentMode.scaleAspectFit
            
            self.animationView?.alpha = 1
            
            self.view.addSubview(self.animationView!)
            
            self.animationView?.loopAnimation = true
            
            self.animationView?.play()
            
        }
        
    }
    
    func secondSignUpAnimate(){
        
        self.view.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.signUpsignUpButton.frame.size.width = self.view.frame.width * 145 / 375
            
            self.signUpsignUpButton.normalTextColor = UIColor.init(hex: "ffffff")
            
            self.signUpsignUpButton.frame.origin.x = self.signUpView.frame.width / 2 - (self.view.frame.width * 145 / 375) / 2
            
        }){completion in
            
            self.animationView?.alpha = 0
            
            self.animationView?.stop()
            
        }
        
    }
    
    //MARK: InvitationMethodes
    
    @IBAction func invitationSignUp(_ sender: Any) {
        
        let m = SignUpRequestModel(USERNAME: signUpMobileField.text, PASSWORD: signUpPasswordField.text, SOCIALNAME: signUpUserField.text, GENDER: "", BDATE: "", NAME: "", FAMILYNAME: "", EMAIL: "" , INVITE: self.invitationCodeText.text)
        
        print(m.getParams())
        
        invitationFirstAnimate()
        
        self.view.isUserInteractionEnabled = false
        
        request(URLs.signUpUrl , method: .post , parameters: m.getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON: \(JSON)")
                
                if(SignUpResponseModel.init(json: JSON as! JSON).code == "5005"){
                    GlobalFields().goErrorPage(viewController: self)
                }
                
                if(SignUpResponseModel.init(json: JSON as! JSON).code == "200"){
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    self.view.isUserInteractionEnabled = true
                    
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ActivationCodeViewController") as! ActivationCodeViewController
                    
                    nextViewController.userName = self.signUpMobileField.text
                    
                    nextViewController.password = self.signUpPasswordField.text
                    
                    nextViewController.upRequest = m
                    
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    
                    self.secondInvitationAnimate()
                    
                }else if(SignUpResponseModel.init(json: JSON as! JSON).code == "501"){
                    
                    self.secondInvitationAnimate()
                    
                    Notifys().notif(message: SignUpResponseModel.init(json: JSON as! JSON).msg ?? "قبلا ثبت نام کرده اید!"){alarm in
                        
                        self.present(alarm, animated: true, completion: nil)
                        
                    }
                    
                }else {
                    
                    self.secondInvitationAnimate()
                    
                    Notifys().notif(message: SignUpResponseModel.init(json: JSON as! JSON).msg){alarm in
                        
                        self.present(alarm, animated: true, completion: nil)
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    func invitationFirstAnimate(){
        
        self.view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.invitationSignUpButton.frame.size.width = self.invitationSignUpButton.frame.height
            
            self.invitationSignUpButton.normalTextColor = self.invitationSignUpButton.normalBackgroundColor
            
            self.invitationSignUpButton.frame.origin.x = self.signUpView.frame.width / 2 - self.invitationSignUpButton.frame.height / 2
            
        }){completion in
            
            self.animationView = LOTAnimationView(name: "finall")
            
            self.animationView?.frame.size.height = self.signUpsignUpButton.frame.height
            
            self.animationView?.frame.size.width = self.signUpsignUpButton.frame.height
            
            self.animationView?.frame.origin.y = self.signUpView.frame.origin.y + self.invitationSignUpButton.frame.origin.y
            
            self.animationView?.frame.origin.x = self.view.frame.width / 2 - self.invitationSignUpButton.frame.height / 2
            
            self.animationView?.contentMode = UIViewContentMode.scaleAspectFit
            
            self.animationView?.alpha = 1
            
            self.view.addSubview(self.animationView!)
            
            self.animationView?.loopAnimation = true
            
            self.animationView?.play()
            
        }
        
    }
    
    func secondInvitationAnimate(){
        
        self.view.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.invitationSignUpButton.frame.size.width = self.view.frame.width * 145 / 375
            
            self.invitationSignUpButton.normalTextColor = UIColor.init(hex: "ffffff")
            
            self.invitationSignUpButton.frame.origin.x = self.signUpView.frame.width / 2 - (self.view.frame.width * 145 / 375) / 2
            
        }){completion in
            
            self.animationView?.alpha = 0
            
            self.animationView?.stop()
            
        }
        
    }
    
    
    
    
    //MARK: - GlobalMethods
    
    @IBAction func loginPageClicked(_ sender: Any) {
        
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.signUpView.alpha = 0
            
            self.invitationCodeView.alpha = 0
            
            
            self.loginUnderLineLabel.frame.origin.x = self.view.frame.width / 2
            
            self.loginUnderLineLabel.alpha = 0
            
            self.signUpButton.setTitleColor(UIColor.init(hex: "D6DCE0"), for: .normal)
            self.loginButton.setTitleColor(UIColor.init(hex: "F7941D"), for: .normal)
            
            self.topImage.alpha = 0
            
        }){comepltion in
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.loginView.alpha = 1
                
                self.invitationCodeText.text = ""
                
                self.loginUnderLineLabel.frame.origin.x = self.loginButton.frame.origin.x
                
                self.loginUnderLineLabel.frame.size.width = self.loginButton.frame.width
                
                self.loginUnderLineLabel.backgroundColor = UIColor.init(hex: "F7941D")
                
                self.loginUnderLineLabel.alpha = 1
                
                self.topImage.alpha = 1
                
                self.topImage.image = UIImage.init(named: "loginImage")
                
            },completion : nil)
            
        }
        
    }
    
    @IBAction func signUpPageClicked(_ sender: Any) {
        
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.loginView.alpha = 0
            
            self.invitationCodeView.alpha = 0
            
            self.loginUnderLineLabel.frame.origin.x = self.view.frame.width / 2 - self.loginUnderLineLabel.frame.size.width
            
            self.loginUnderLineLabel.alpha = 0
            
            self.loginButton.setTitleColor(UIColor.init(hex: "D6DCE0"), for: .normal)
            self.signUpButton.setTitleColor(UIColor.init(hex: "2490FC"), for: .normal)
            
            self.topImage.alpha = 0
            
        }){comepltion in
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.signUpView.alpha = 1  
                
                self.invitationCodeText.text = ""
                
                self.loginUnderLineLabel.frame.origin.x = self.signUpButton.frame.origin.x
                
                self.loginUnderLineLabel.frame.size.width = self.signUpButton.frame.width
                
                self.loginUnderLineLabel.backgroundColor = UIColor.init(hex: "2490FC")
                
                self.loginUnderLineLabel.alpha = 1
                
                self.topImage.alpha = 1
                
                self.topImage.image = UIImage.init(named: "signUpImage")
                
            },completion : nil)
            
        }
        
        
        
    }
    
    @IBAction func swipeRightGesture(_ sender: Any) {
        
        signUpPageClicked("")
        
    }
    
    @IBAction func swipeLeftGesture(_ sender: Any) {
        
        loginPageClicked("")
     
    }
    
    @IBAction func tap(_ sender: Any) {
        
        self.view.endEditing(false)
        self.setColorViews()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
        case loginUserField:
            setColorViews()
            loginUserBorder.borderColor = UIColor.init(hex: "F7941D")
            loginUserField.becomeFirstResponder()
            loginUserField.window?.makeKeyAndVisible()
            break
            
        case loginPasswordField:
            setColorViews()
            loginPasswordBorder.borderColor = UIColor.init(hex: "F7941D")
            loginPasswordField.becomeFirstResponder()
            loginPasswordField.window?.makeKeyAndVisible()
            break
            
            
        case signUpUserField:
            setColorViews()
            signUpUserBorder.borderColor = UIColor.init(hex: "2490FC")
            signUpUserField.becomeFirstResponder()
            signUpUserField.window?.makeKeyAndVisible()
            break
            
        case signUpMobileField:
            setColorViews()
            signUpMobileBorder.borderColor = UIColor.init(hex: "2490FC")
            signUpMobileField.becomeFirstResponder()
            signUpMobileField.window?.makeKeyAndVisible()
            break
            
        case signUpPasswordField:
            setColorViews()
            signUpPasswordBorder.borderColor = UIColor.init(hex: "2490FC")
            signUpPasswordField.becomeFirstResponder()
            signUpPasswordField.window?.makeKeyAndVisible()
            break
            
        case invitationCodeText:
            setColorViews()
            invitationCodeBorder.borderColor = UIColor.init(hex: "2490FC")
            invitationCodeText.becomeFirstResponder()
            invitationCodeText.window?.makeKeyAndVisible()
            break
            
        default:
            break
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            
        case loginUserField:
            loginPasswordField.becomeFirstResponder()
            loginPasswordField.window?.makeKeyAndVisible()
            setColorViews()
            loginPasswordBorder.borderColor = UIColor.init(hex: "F7941D")
            break
        
        case signUpUserField:
            signUpMobileField.becomeFirstResponder()
            signUpMobileField.window?.makeKeyAndVisible()
            setColorViews()
            signUpMobileBorder.borderColor = UIColor.init(hex: "2490FC")
            break
            
        case signUpMobileField:
            signUpPasswordField.becomeFirstResponder()
            signUpPasswordField.window?.makeKeyAndVisible()
            setColorViews()
            signUpPasswordBorder.borderColor = UIColor.init(hex: "2490FC")
            break
        
        case signUpPasswordField:
            setColorViews()
            self.view.endEditing(true)
            break
            
        case loginPasswordField:
            setColorViews()
            self.view.endEditing(true)
            break
            
        case invitationCodeText:
            setColorViews()
            invitationCodeBorder.borderColor = UIColor.init(hex: "2490FC")
            self.view.endEditing(true)
            break
            
        default:
            self.view.endEditing(true)
            
        }
        
        return true
        
    }
    
    func setColorViews(){
        
        loginUserBorder.borderColor = UIColor.init(hex: "D6DCE0")
        
        loginPasswordBorder.borderColor = UIColor.init(hex: "D6DCE0")
        
        signUpUserBorder.borderColor = UIColor.init(hex: "D6DCE0")
        
        signUpPasswordBorder.borderColor = UIColor.init(hex: "D6DCE0")
        
        signUpMobileBorder.borderColor = UIColor.init(hex: "D6DCE0")
        
        invitationCodeBorder.borderColor = UIColor.init(hex: "D6DCE0")
        //d6dce0
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
