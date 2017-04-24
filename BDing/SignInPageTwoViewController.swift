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

class SignInPageTwoViewController: UIViewController {

    
    @IBOutlet weak var titler: UILabel!
    
    @IBOutlet weak var passwordTextView: UITextField!
    
    @IBOutlet weak var vorudButton: DCBorderedButton!
    
    @IBOutlet weak var smallText: UILabel!
    
    @IBOutlet weak var signUpLink: UIButton!
    
    var user : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MyFont().setMediumFont(view: self.titler, mySize: 13)
        MyFont().setMediumFont(view: self.passwordTextView, mySize: 15)
        MyFont().setMediumFont(view: self.vorudButton, mySize: 13)
        MyFont().setMediumFont(view: self.smallText, mySize: 10)
        MyFont().setMediumFont(view: self.signUpLink, mySize: 10)
        
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
    
    @IBAction func signInPressing(_ sender: Any) {
        
        let s = SignInRequestModel(USERNAME: user, PASSWORD: passwordTextView.text)
        
        print(s.getParams())
        
        request(URLs.signInUrl , method: .post , parameters: s.getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON -----------SIGNIN---------->>>> " , JSON)
                
                let obj = SignInResponseModel.init(json: JSON as! JSON)
                
                if ( obj.code == "200" ){
                    
                    print(obj.token ?? "null")
                    
                    SaveAndLoadModel().deleteAllObjectIn(entityName: "USER")
 
                    let b = SaveAndLoadModel().save(entityName: "USER", datas: ["user":s.USERNAME , "password":s.PASSWORD , "token":obj.token! , "userID" : obj.userID!])
                    print(b)
                    
                    ///
                    
                    self.loadTabView()
                    
                    print(SaveAndLoadModel().load(entity: "USER")?.count ?? "nothing!")
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                    
                    self.present(nextViewController, animated:true, completion:nil)
                    
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
    
        request(URLs.getBeaconList , method: .post , parameters: BeaconListRequestModel(LAT: lat, LONG: long, REDIUS: nil, SEARCH: nil, CATEGORY: nil, SUBCATEGORY: nil).getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------BEACON----------->>>> ")

                let obj = BeaconListResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                    
                    GlobalFields.BEACON_LIST_DATAS = obj?.data
                    
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
                    
                }
                
            }
            
        }
        
        
        
        
        
    }

}
