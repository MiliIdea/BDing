//
//  SignInPageTwoViewController.swift
//  BDingTest
//
//  Created by Milad on 2/15/17.
//  Copyright © 2017 Milad. All rights reserved.
//

import UIKit

import CoreData

import CoreLocation

import Lottie


class SignInPageTwoViewController: UIViewController {
    
    @IBOutlet weak var titler: UILabel!
    
    @IBOutlet weak var passwordTextView: UITextField!
    
    @IBOutlet weak var vorudButton: DCBorderedButton!
    
    @IBOutlet weak var smallText: UILabel!
    
    @IBOutlet weak var signUpLink: UIButton!
    
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var forgotPopUpView: DCBorderedView!
    
    @IBOutlet weak var userNameForgot: UITextField!
    
    
    var beaconBool : Bool = false
    
    var catBool : Bool = false
    
    var profileBool : Bool = false
    
    var loginBool : Bool = false
    
    var user : String = ""
    
    var animationView : LOTAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MyFont().setMediumFont(view: self.titler, mySize: 13)
        MyFont().setMediumFont(view: self.passwordTextView, mySize: 15)
        MyFont().setMediumFont(view: self.vorudButton, mySize: 13)
        MyFont().setMediumFont(view: self.smallText, mySize: 10)
        MyFont().setMediumFont(view: self.signUpLink, mySize: 10)
        
        blurView.alpha = 0
        
        forgotPopUpView.alpha = 0
        
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
    }
    
    func setGradientLayer(myView: UIView , color1: CGColor , color2: CGColor) -> CALayer {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = myView.bounds
        
        gradientLayer.colors = [color1, color2]
        
        gradientLayer.startPoint = CGPoint(x: 0,y: 0.5)
        
        gradientLayer.endPoint = CGPoint(x: 1,y: 0.5)
        
        return gradientLayer
        
    }
    
    @IBAction func signInPressing(_ sender: Any) {
        
        let s = SignInRequestModel(USERNAME: user, PASSWORD: passwordTextView.text)
        
        print(s.getParams())
        
        self.view.endEditing(true)
        
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
                    
                    
                }else{
                    
                    self.animationView?.pause()
                    
                    self.animationView?.alpha = 0
                    
                    self.view.endEditing(false)
                    
                }
                
            }
            
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
    
        request(URLs.getBeaconList , method: .post , parameters: BeaconListRequestModel(LAT: lat, LONG: long, REDIUS: String(GlobalFields.BEACON_RANG), SEARCH: nil, CATEGORY: nil, SUBCATEGORY: nil).getParams(allSearch : true), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------BEACON----------->>>> " , JSON)

                let obj = BeaconListResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                    
                    GlobalFields.BEACON_LIST_DATAS = obj?.data
                    
                    self.beaconBool = true
                    
                    self.goNextView()
                    
                }
                
            }
            
        }
        
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
        
        
        request(URLs.getPayUuids , method: .post , parameters: PayUuidsRequestModel().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------PAY UUID----------->>>> " , JSON)
                
                let obj = PayUuidResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                    
                    GlobalFields.PAY_UUIDS = obj?.result
                    
                }
                
            }
            
        }
        
        
        
        
        
    }
    
    func goNextView(){
        
        if(self.profileBool && self.beaconBool && self.catBool && self.loginBool){
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
            
            self.present(nextViewController, animated:true, completion:nil)
            
        }
        
    }
    
    
    
    @IBAction func recyclePass(_ sender: Any) {
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.blurView.backgroundColor = UIColor.lightGray
            
            self.blurView.alpha = 0.3
            
            self.forgotPopUpView.alpha = 1 
            
        },completion : nil)
        
    }
    
    @IBAction func cansel(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.blurView.alpha = 0
            
            self.forgotPopUpView.alpha = 0
            
            self.view.endEditing(true)
            
        },completion : nil)
        
    }
    
    @IBAction func sendForgotUsername(_ sender: Any) {
        
        
        request(URLs.forgotPassword , method: .post , parameters: ForgotpasswordRequestModel(USERNAME: userNameForgot.text).getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------FORGOT PASSWORD----------->>>> " , JSON)
                
                let obj = CategoryListResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                    
                    self.view.endEditing(true)
                    
                    self.cansel("")
                    
                }
                
            }
            
        }
        
        
    }
 

}









