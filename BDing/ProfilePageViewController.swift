//
//  ProfilePageViewController.swift
//  BDingTest
//
//  Created by Milad on 2/20/17.
//  Copyright © 2017 Milad. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import DLRadioButton
import DynamicColor
import Lottie

class ProfilePageViewController: UIViewController ,UIImagePickerControllerDelegate, UIScrollViewDelegate , UINavigationControllerDelegate , CLLocationManagerDelegate , ShowcaseDelegate{
    
    
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var messageButton: UIButton!
    
    @IBOutlet weak var profilePicButton: DCBorderedButton!
    
    @IBOutlet weak var coinIcon: UIImageView!
    
    @IBOutlet weak var viewContainerAtBottom: UIView!
    
    let locationManager = CLLocationManager()
   
    @IBOutlet weak var name: UILabel!
    
    
    @IBOutlet weak var socialName: UILabel!
    
    
    @IBOutlet weak var coinValue: UILabel!
    
    @IBOutlet weak var closeImage: UIImageView!
    
    @IBOutlet weak var closeReportButton: UIButton!
    
    @IBOutlet weak var porseshhaButton: DCBorderedButton!
    
    @IBOutlet var container: UIView!
    
    @IBOutlet weak var completionDing: UILabel!
    
    @IBOutlet weak var inviteDing: UILabel!
    
    var imagePicker = UIImagePickerController()
    
    let showcase = MaterialShowcase()
    
    var showcaseCounter : Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        var im : UIImage? = nil
        
        animationView = LOTAnimationView(name: "finall")
        
        self.profilePicButton.frame.size.height = self.profilePicButton.frame.size.width
        
        self.profilePicButton.layer.cornerRadius = self.profilePicButton.frame.height / 2
        
        self.inviteDing.text = GlobalFields.invitationDing
        
        self.completionDing.text = GlobalFields.completionDing
        
        animationView.frame.size.height = 30
        
        animationView.frame.size.width = 30
        
        animationView.frame.origin.y = self.profilePicButton.frame.height / 2 - 15
        
        animationView.frame.origin.x = self.profilePicButton.frame.width / 2 - 15
        
        animationView.contentMode = UIViewContentMode.scaleAspectFit
        
        animationView.alpha = 0
        
        self.profilePicButton.addSubview(animationView)
        
        animationView.loopAnimation = true
        
        if(loadProfilePicAsDB() == nil){
            
            animationView.alpha = 1
            DispatchQueue.main.async(execute: { () -> Void in
                
                self.animationView.play()
                
            })
            
            request("http://"+(GlobalFields.PROFILEDATA?.url_pic)! , method: .post , parameters: ProfileRequestModel().getParams(), encoding: JSONEncoding.default).responseJSON { response in
                print()
                
                if let image = response.result.value {
                    
                    print("JSON ----------Profile Pic----------->>>> " , image)
                    
                    let obj = PicDataModel.init(json: image as! JSON)
                    
                    if(obj?.data != nil && obj?.data != ""){
                        
                        let imageData = NSData(base64Encoded: (obj?.data!)!, options: .ignoreUnknownCharacters)
                        
                        
                        im = UIImage(data: imageData as! Data)!
                        
                        self.profilePicButton.setBackgroundImage(im?.af_imageAspectScaled(toFill: self.profilePicButton.frame.size), for: .normal)
                        
                        self.profilePicButton.contentMode = UIViewContentMode.scaleAspectFill
                        
                        var coding: String = ("http://"+(GlobalFields.PROFILEDATA?.url_pic)!)
                        
                        coding.append("ProfilePic")
                        
                        SaveAndLoadModel().save(entityName: "IMAGE", datas: ["imageCode": coding.md5() , "imageData": obj?.data!])
                        
                        LoadPicture.cache.setObject(imageData!, forKey: coding.md5() as AnyObject)
                        
                        
                        self.animationView.pause()
                        
                        self.animationView.alpha = 0
                        
                    }
                    
                }
                
            }
            
        }else{
            
            let im : UIImage = loadProfilePicAsDB()!
            
            self.profilePicButton.setBackgroundImage(im.af_imageAspectScaled(toFill: self.profilePicButton.frame.size), for: .normal)
            
            self.profilePicButton.contentMode = UIViewContentMode.scaleAspectFill
        }
    
        
    }
    
    
    
    func dismissed() {
        
    }
    
    func isThereThisPicInDB (code: String) -> String?{
        
        for i in SaveAndLoadModel().load(entity: "IMAGE")!{
            
            if(i.value(forKey: "imageCode") as! String == code){
                
                return i.value(forKey: "imageData") as! String
                
            }
            
        }
        
        return nil
        
    }
    
    func loadProfilePicAsDB() -> UIImage?{
        
        var tempCode : String! = ("http://"+(GlobalFields.PROFILEDATA?.url_pic)!)
        
        tempCode?.append("ProfilePic")
        
        let result: String? = isThereThisPicInDB(code: (tempCode?.md5())!)
        
        if(result != nil){
            
            if LoadPicture.cache.object(forKey: tempCode?.md5() as AnyObject) != nil {
                
                return UIImage(data: LoadPicture.cache.object(forKey: tempCode?.md5() as AnyObject) as! Data)!
                
            }else{
                
                let imageData = NSData(base64Encoded: result!, options: .ignoreUnknownCharacters)
                
                LoadPicture.cache.setObject(imageData!, forKey: tempCode?.md5() as AnyObject)
                
                return UIImage(data: imageData as! Data)!
                
            }
            
        }else{
            
            return nil
            
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Profile")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        if(GlobalFields.get_coin == "yes"){

            self.closeReport("")

        }
        
        coinValue.text = GlobalFields.PROFILEDATA?.all_coin
        
        let s : String? = GlobalFields.PROFILEDATA?.social_name
        
        socialName.text = "@" + s!
        
        name.text = (GlobalFields.PROFILEDATA?.name)! + " " + (GlobalFields.PROFILEDATA?.family)!

        if(GlobalFields.PROFILEDATA?.get_coin == "yes"){

            self.closeImage.frame.size.height = 0
            
            self.closeReportButton.frame.size.height = 0
            
            self.closeImage.alpha = 0
            
            self.closeReportButton.alpha = 0
            
            self.viewContainerAtBottom.frame.origin.y = self.closeReportButton.frame.origin.y
            
        }
        
        self.coinValue.text = GlobalFields.PROFILEDATA?.all_coin

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    var animationView : LOTAnimationView = LOTAnimationView.init()
    
    @IBAction func setProfilePic(_ sender: Any) {
        
//        self.btnEdit.setTitleColor(UIColor.white, for: .normal)
//        self.btnEdit.isUserInteractionEnabled = true
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            animationView.alpha = 1
            DispatchQueue.main.async(execute: { () -> Void in
                
                self.animationView.play()
                
            })
            request(URLs.userUpdate , method: .post , parameters: UserUpdateRequestModel.init(NAME: nil, FAMILY: nil, EMAIL: nil ,BIRTHDATE: nil , PIC: UIImagePNGRepresentation(pickedImage)!.base64EncodedString() , GENDER: nil).getParams(), encoding: JSONEncoding.default).responseJSON { response in
                print()
                
                if let JSON = response.result.value {
                    
                    print("JSON ----------User Update----------->>>> " , JSON)
                    
                    let obj = ProfileResponseModel.init(json: JSON as! JSON)
                    
                    if(obj?.code == "5005"){
                        GlobalFields().goErrorPage(viewController: self)
                    }
                    
                    if ( obj?.code == "200" ){
                        
                        self.animationView.pause()
                        
                        self.animationView.alpha = 0
                        
                        self.profilePicButton.contentMode = UIViewContentMode.scaleAspectFill
                        
                        self.profilePicButton.setBackgroundImage(pickedImage.af_imageAspectScaled(toFill: self.profilePicButton.frame.size), for: .normal)
                        
                        var coding: String = ("http://"+(GlobalFields.PROFILEDATA?.url_pic)!)
                        
                        coding.append("ProfilePic")
                        
                        let imageData = NSData(base64Encoded: UIImagePNGRepresentation(pickedImage)!.base64EncodedString(), options: .ignoreUnknownCharacters)
                        
                        SaveAndLoadModel().deleteAllObjectIn(entityName: "IMAGE")
                        
                        SaveAndLoadModel().save(entityName: "IMAGE", datas: ["imageCode": coding.md5() , "imageData": UIImagePNGRepresentation(pickedImage)!.base64EncodedString()])
                        
                        LoadPicture.cache.setObject(imageData!, forKey: coding.md5() as AnyObject)
                        
                        
                    }
                    
                }
                
            }
            
            
            
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func exitAccount(_ sender: Any) {
        
        SaveAndLoadModel().deleteAllObjectIn(entityName: "USER")
        
        var coding: String = ("http://"+(GlobalFields.PROFILEDATA?.url_pic)!)
        
        coding.append("ProfilePic")
        
        SaveAndLoadModel().deleteSpecificItemIn(entityName: "IMAGE", keyAttribute: "imageCode", item: coding.md5())
        
    }
    
    
    
    @IBAction func goCashier(_ sender: Any) {
        print(CLoginRequestModel.init().getParams())
        print()
        request(URLs.cLogin , method: .post , parameters: CLoginRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print(response)
            print()
            if let JSON = response.result.value {
                
                print("JSON ----------Login Cashier----------->>>> " , JSON)
                
                let obj = CLoginResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                    
                    request(URLs.cReportCash , method: .post , parameters: CReportCashRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
                        print()
                        
                        if let JSON2 = response.result.value {
                            
                            print("JSON ----------Cash Report----------->>>> " , JSON2)
                            
                            let obj2 = CReportCashResponseModel.init(json: JSON2 as! JSON)
                            
                            if ( obj2?.code == "200" ){
                               
                                let objVC : UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "CashDeskHomeViewController"))! as UIViewController
                                
                                self.navigationController?.isToolbarHidden = true
 
                                self.tabBarController?.tabBar.isHidden = true
                                
                            self.navigationController?.pushViewController(objVC, animated: true)
//                                let objNavi : UINavigationController = UINavigationController(rootViewController: objVC)
//
//                                objNavi.hidesBarsOnTap = true
//
//                                objNavi.isToolbarHidden = true
//
//                                objNavi.isNavigationBarHidden = true
                                
//                                let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
//
//                                appDelegate.window?.rootViewController = objNavi
//                                self.navigationController?.pushViewController(objNavi, animated: true)
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    let loading : UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    @IBAction func closeReport(_ sender: Any) {

        if(sender is String){
            self.closeImage.frame.size.height = 0
            
            self.closeReportButton.frame.size.height = 0
            
            self.closeImage.alpha = 0
            
            self.closeReportButton.alpha = 0
            
            self.viewContainerAtBottom.frame.origin.y = self.closeReportButton.frame.origin.y
        }else{
            
            if(self.closeReportButton.alpha == 1){
                
                UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    
                    self.closeImage.frame.size.height = 0
                    
                    self.closeReportButton.frame.size.height = 0
                    
                    self.closeImage.alpha = 0
                    
                    self.closeReportButton.alpha = 0
                    
                    self.viewContainerAtBottom.frame.origin.y = self.closeReportButton.frame.origin.y
                    
                }, completion: nil)
                
            }
            
        }
        
    }
    
}

















