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

class ProfilePageViewController: UIViewController ,UIImagePickerControllerDelegate, UIScrollViewDelegate , UINavigationControllerDelegate , CLLocationManagerDelegate{
    
    @IBOutlet weak var backgroundProfilePic: UIImageView!
    
    @IBOutlet weak var scrollViewProfile: UIScrollView!
    
    @IBOutlet weak var botViewInScrollView: UIView!
    
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var messageButton: UIButton!
    
    @IBOutlet weak var viewInScrollView: UIView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var semicircularView: UIImageView!
    
    @IBOutlet weak var profilePicButton: DCBorderedButton!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var coinIcon: UIImageView!
    
    @IBOutlet weak var patternView: UIView!
    
    @IBOutlet weak var appSettingsIcon: UIImageView!
    
    
    let locationManager = CLLocationManager()
    
    
    
    //num of pattern images in background
    let xNum = 4
    
    var profilePicEdge: CGFloat = 0.0
    
    var profilePicOffsetY: CGFloat = 0.0
    
    var profilePicOffsetX: CGFloat = 0.0
    
    var heightOfSemiCircular: CGFloat = 0.0
    
    var offsetOfsemiCircular: CGFloat = 0.0
    
    var nameStartXY: CGPoint = CGPoint()
    
    var nameStartWH: CGPoint = CGPoint()
    
    var coinValueStartXY: CGPoint = CGPoint()
    
    var coinValueStartWH: CGPoint = CGPoint()
    
    var coinIconStartXY: CGPoint = CGPoint()
    
    var coinIconStartWH: CGPoint = CGPoint()
    
    var startNameFontSize: CGFloat = 0.0
    
    var startCoinFontSize: CGFloat = 0.0
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var coinValue: UILabel!
    
    @IBOutlet weak var reportLabel: UILabel!
    
    @IBOutlet weak var closeReportButton: UIButton!
    
    @IBOutlet weak var payWithTolls: DCBorderedButton!
    
    @IBOutlet weak var takeCoupon: DCBorderedButton!
    
    @IBOutlet weak var payHistory: DCBorderedButton!
    
    @IBOutlet weak var myCoupons: DCBorderedButton!
    
    @IBOutlet weak var inputBoarderView: DCBorderedView!
    
    @IBOutlet weak var porseshhaButton: DCBorderedButton!
    
    @IBOutlet weak var aboutUsButton: DCBorderedButton!
    
    @IBOutlet var container: UIView!
    
    // input popups
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var pickerContainerView: DCBorderedView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    

    
    
    @IBOutlet weak var inputContainerView: DCBorderedView!
    
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var inputTitle: UILabel!
    
    @IBOutlet weak var inputGenderViewContainer: UIView!
    
    @IBOutlet weak var maleRadio: DLRadioButton!
    
    @IBOutlet weak var femaleRadio: DLRadioButton!
    
    
    // pay with coins 
    
    @IBOutlet weak var myCoinsValueLabel: UILabel!
    
    @IBOutlet weak var payTitleLabel: UILabel!
    
    @IBOutlet weak var inputPayTextField: UITextField!
    
    @IBOutlet weak var payContainer: DCBorderedView!
    
    
 //profile data 
    
    
    @IBOutlet weak var nameButton: UIButton!
    
    @IBOutlet weak var familyNameButton: UIButton!
    
    @IBOutlet weak var genderButton: UIButton!
    
    @IBOutlet weak var mobileButton: UIButton!
    
    @IBOutlet weak var emailButton: UIButton!
    
    @IBOutlet weak var BirthDayButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        MyFont().setFontForAllView(view: self.view , elseView: payContainer)
        
        for subView in inputBoarderView.subviews {
            if (subView is UILabel){
                MyFont().setLightFont(view: subView, mySize: 13)
            }else {
                MyFont().setMediumFont(view: subView, mySize: 13)
            }
        }
        
        MyFont().setMediumFont(view: name, mySize: 14)
        MyFont().setBoldFont(view: coinValue, mySize: 19)
        MyFont().setMediumFont(view: reportLabel, mySize: 10)
        MyFont().setMediumFont(view: payWithTolls, mySize: 13)
        MyFont().setMediumFont(view: takeCoupon, mySize: 13)
        MyFont().setMediumFont(view: payHistory, mySize: 13)
        MyFont().setMediumFont(view: myCoupons, mySize: 13)
        MyFont().setMediumFont(view: porseshhaButton, mySize: 13)
        MyFont().setMediumFont(view: aboutUsButton, mySize: 13)
        
        // image is 400 * 252
        let wV = patternView.frame.width
        let hV = patternView.frame.height
        let hr = (252/400)*(wV/CGFloat(xNum))
        let wr = wV/CGFloat(xNum)
        
        for i in 0...xNum - 1{
            
            for j in 0...Int(floor(Double(hV/hr))) - 1{
                
                let image = UIImageView(frame: CGRect(x: CGFloat(i)*wr, y: CGFloat(j)*hr, width: wr, height: hr))
                
                image.image = UIImage(named: "bding_pattern_white")
                
                patternView.addSubview(image)
                
            }
            
        }
        
        
        
        scrollViewProfile.delegate = self
        
        scrollViewProfile.addSubview(viewInScrollView)
        
        scrollViewProfile.contentSize = viewInScrollView.frame.size
        
//        scrollViewProfile.contentSize.height += 10
        
        heightOfSemiCircular = semicircularView.frame.height
        
        offsetOfsemiCircular = semicircularView.frame.origin.y
        
        profilePicEdge = profilePicButton.frame.height
        
        profilePicOffsetY = profilePicButton.frame.origin.y
        
        profilePicOffsetX = profilePicButton.frame.origin.x
        
        profilePicButton.layer.zPosition = 1
        
        //---
        
        name.adjustsFontSizeToFitWidth = true
        
        startNameFontSize = name.font.pointSize
        
        //---
        
        coinValueStartXY.x = coinValue.frame.origin.x
        
        coinValueStartXY.y = coinValue.frame.origin.y
        
        coinValueStartWH.x = coinValue.frame.width
        
        coinValueStartWH.y = coinValue.frame.height
        
        startCoinFontSize = coinValue.font.pointSize
        
        //---
        
        coinIconStartXY.x = coinIcon.frame.origin.x
        
        coinIconStartXY.y = coinIcon.frame.origin.y
        
        coinIconStartWH.x = coinIcon.frame.width
        
        coinIconStartWH.y = coinIcon.frame.height
        
        //---
        
        reportLabel.clipsToBounds = true
        
        reportLabel.layer.cornerRadius = 8
        
        disAppearInputView()
        
        disAppearDatePickerView()
        
        //fill profile data
        
        inputGenderViewContainer.alpha = 0
        
        maleRadio.icon = maleRadio.icon.af_imageAspectScaled(toFit: CGSize.init(width: 50, height: 50))
        
        maleRadio.iconSelected = maleRadio.iconSelected.af_imageAspectScaled(toFit: CGSize.init(width: 50, height: 50))
        
        femaleRadio.icon = femaleRadio.icon.af_imageAspectScaled(toFit: CGSize.init(width: 50, height: 50))
        
        femaleRadio.iconSelected = femaleRadio.iconSelected.af_imageAspectScaled(toFit: CGSize.init(width: 50, height: 50))
        
        ///
        
        
        /// fill data was here
        
        
        var im : UIImage? = nil
        
        if(loadProfilePicAsDB() == nil){
            
            request("http://"+(GlobalFields.PROFILEDATA?.url_pic)! , method: .post , parameters: ProfileRequestModel().getParams(), encoding: JSONEncoding.default).responseJSON { response in
                print()
                
                if let image = response.result.value {
                    
                    print("JSON ----------Profile Pic----------->>>> " , image)
                    
                    let obj = PicDataModel.init(json: image as! JSON)
                    
                    if(obj?.data != nil){
                        
                        let imageData = NSData(base64Encoded: (obj?.data!)!, options: .ignoreUnknownCharacters)
                        
                        
                        im = UIImage(data: imageData as! Data)!
                        
                        self.profilePicButton.setBackgroundImage(im?.af_imageAspectScaled(toFill: self.profilePicButton.frame.size), for: .normal)
                        
                        self.profilePicButton.contentMode = UIViewContentMode.scaleAspectFill
                        
                        self.backgroundProfilePic.image = im?.af_imageAspectScaled(toFill: self.backgroundProfilePic.frame.size)
                        
                        self.backgroundProfilePic.contentMode = UIViewContentMode.scaleAspectFill
                        
                        var coding: String = ("http://"+(GlobalFields.PROFILEDATA?.url_pic)!)
                        
                        coding.append("ProfilePic")
                        
                        SaveAndLoadModel().save(entityName: "IMAGE", datas: ["imageCode": coding.md5() , "imageData": obj?.data!])
                        
                        LoadPicture.cache.setObject(imageData!, forKey: coding.md5() as AnyObject)
                        
                        
                    }
                    
                }
                
            }
            
        }else{
            
            let im : UIImage = loadProfilePicAsDB()!
            
            self.profilePicButton.setBackgroundImage(im.af_imageAspectScaled(toFill: self.profilePicButton.frame.size), for: .normal)
            
            self.profilePicButton.contentMode = UIViewContentMode.scaleAspectFill
            
            self.backgroundProfilePic.image = im.af_imageAspectScaled(toFill: self.backgroundProfilePic.frame.size)
            
            self.backgroundProfilePic.contentMode = UIViewContentMode.scaleAspectFill
            
        }
        
        
        ///
//        coinValue and coinIcon should set origin.x here
        
        let fixedHeight = self.coinValue.frame.size.height
        
        self.coinValue.frame.size = self.coinValue.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: fixedHeight))
        
        var sumW = coinValue.frame.width + coinIcon.frame.width
        
        coinIcon.frame.origin.x = self.view.frame.width / 2 - sumW / 2
        
        coinValue.frame.origin.x = coinIcon.frame.origin.x + coinIcon.frame.width
        
        coinValue.frame.origin.y = coinIcon.frame.origin.y
        
        
        nameStartXY.y = name.frame.origin.y
        
        print(name.frame.width)
        
        let fixedH = self.name.frame.size.height
        
        self.name.frame.size = self.name.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: fixedH))
        
        name.textAlignment = NSTextAlignment.center
        
        name.frame.origin.x = self.view.frame.width / 2 - self.name.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: fixedH)).width / 3
        
        nameStartXY.x = name.frame.origin.x
        
        nameStartWH.x = name.frame.width
        
        nameStartWH.y = name.frame.height
        
        scrollViewDidScroll(self.scrollViewProfile)
    
        if(Int((GlobalFields.PROFILEDATA?.all_coin)!)! >= 5000 && checkProfileGift() == true){
            
            self.closeReport("")
            
        }
        
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
        
        nameButton.setTitle(GlobalFields.PROFILEDATA?.name, for: UIControlState.normal)
        
        familyNameButton.setTitle(GlobalFields.PROFILEDATA?.family, for: UIControlState.normal)
        
        if(GlobalFields.PROFILEDATA?.gender == "male"){
            
            self.genderButton.setTitle("مرد", for: UIControlState.normal)
            
        }else if(GlobalFields.PROFILEDATA?.gender == "female"){
            
            self.genderButton.setTitle("زن", for: UIControlState.normal)
            
        }
        
        
        mobileButton.setTitle(GlobalFields.PROFILEDATA?.mobile, for: UIControlState.normal)
        
        emailButton.setTitle(GlobalFields.PROFILEDATA?.email, for: UIControlState.normal)
        
        
        
        BirthDayButton.setTitle(GlobalFields.PROFILEDATA?.birthdate, for: UIControlState.normal)
        
        if(GlobalFields.PROFILEDATA?.birthdate != nil && GlobalFields.PROFILEDATA?.birthdate != ""){
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "dd/MM/yyyy"
            
            formatter.calendar = Calendar(identifier: .gregorian)
            
            let d = formatter.date(from: (GlobalFields.PROFILEDATA?.birthdate)!)
            
            formatter.dateFormat = "yyyy/MM/dd"
            
            formatter.calendar = Calendar(identifier: .persian)
            
            self.BirthDayButton.setTitle(formatter.string(from: d!), for: UIControlState.normal)
            
        }
        
        coinValue.text = GlobalFields.PROFILEDATA?.all_coin
        
        let s : String? = GlobalFields.PROFILEDATA?.social_name
        
        name.text = s
        
        print(name.frame.width)
        
        let fixedH = self.name.frame.size.height
        
        self.name.frame.size = self.name.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: fixedH))
        
        name.textAlignment = NSTextAlignment.center
        
        self.name.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: fixedH))

        name.frame.origin.x = self.view.frame.width / 2 - name.frame.width / 2
        
        nameStartXY.x = name.frame.origin.x
        
        nameStartWH.x = name.frame.width

        nameStartWH.y = name.frame.height
        
        let w = coinIcon.frame.width + coinValue.frame.width + 5

        coinIcon.frame.origin.x = self.view.frame.width / 2 - w / 2
        
        coinValue.frame.origin.x = coinIcon.frame.origin.x + coinIcon.frame.width + 5
        
        coinIconStartXY.x = self.view.frame.width / 2 - w / 2
        
        coinValueStartXY.x = self.view.frame.width / 2 - w / 2  + coinIcon.frame.width + 5

        scrollViewDidScroll(self.scrollViewProfile)
        
//        for i in (self.tabBarController?.tabBar.items!)! {
//            
//            i.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.init(hex: "bdbdbd") , NSFontAttributeName: UIFont(name: "IRANYekanMobileFaNum", size: CGFloat(8))!], for: .normal)
//            //bdbdbd unselected color
//            i.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.init(hex: "455a64") , NSFontAttributeName: UIFont(name: "IRANYekanMobileFaNum", size: CGFloat(8))!], for: .selected)
//            i.image =  i.image?.imageWithColor(tintColor: UIColor.init(hex: "bdbdbd")).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
//            i.selectedImage = i.image?.imageWithColor(tintColor: UIColor.init(hex: "455a64")).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
//            i.imageInsets = UIEdgeInsets.init(top: 6, left: 6, bottom: 6, right: 6)
//            
//            
//        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func myAnimateWithScroll(view: UIView , goalXY: CGPoint , startXY: CGPoint , goalWH: CGPoint , startWH: CGPoint , fontSG: CGPoint) -> Void{
        
        var YpercentageScroll = scrollViewProfile.contentOffset.y / profilePicOffsetY
        
        print(YpercentageScroll)
        
        var isNegative : Bool = false
        
        var howMuch: CGFloat = 0.000
        
        if(YpercentageScroll < 0.000){
            
            isNegative = true
            
            howMuch = -scrollViewProfile.contentOffset.y
            
            view.frame.origin.y = startXY.y - scrollViewProfile.contentOffset.y
            
            YpercentageScroll = 0
        }

            
            if(YpercentageScroll > 1.000){
                
                YpercentageScroll = 1
                
            }
            
            view.frame.origin.x = startXY.x + (goalXY.x - startXY.x) * YpercentageScroll
            
            view.frame.origin.y = startXY.y + (goalXY.y - startXY.y) * YpercentageScroll
        
        if(isNegative){
            
            view.frame.origin.y += howMuch
            
        }
            
            view.frame.size.width = startWH.x + (goalWH.x - startWH.x) * YpercentageScroll
            
            view.frame.size.height = startWH.y + (goalWH.y - startWH.y) * YpercentageScroll
            
            if(view is UILabel){
                
                let l: UILabel = view as! UILabel
                
                l.font = l.font.withSize(fontSG.x - ((fontSG.x - fontSG.y) * YpercentageScroll))
                
                l.sizeToFit()
                
            }

//        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // define goal of animation of views
        // profile pic
        var pgXY: CGPoint = CGPoint()
        
        var psXY: CGPoint = CGPoint()
        
        var pgWH: CGPoint = CGPoint()
        
        var psWH: CGPoint = CGPoint()
        
        pgXY.x = 0.85 * navigationBar.frame.width
        
        pgXY.y = 0.075 * navigationBar.frame.height + navigationBar.frame.origin.y
        
        psXY.x = profilePicOffsetX
        
        psXY.y = profilePicOffsetY
        
        pgWH.x = navigationBar.frame.height * 0.8
        
        pgWH.y = navigationBar.frame.height * 0.8
        
        psWH.x = profilePicEdge
        
        psWH.y = profilePicEdge
        
        myAnimateWithScroll(view: profilePicButton, goalXY: pgXY, startXY: psXY, goalWH: pgWH, startWH: psWH , fontSG: pgXY)
        
        self.profilePicButton.contentMode = UIViewContentMode.scaleAspectFill
        
        // Name and Coin
        
        var ngXY: CGPoint = CGPoint()
        
        var ngWH: CGPoint = CGPoint()
        
        var cvgXY: CGPoint = CGPoint()
        
        var cvgWH: CGPoint = CGPoint()
        
        var cigXY: CGPoint = CGPoint()
        
        var cigWH: CGPoint = CGPoint()
        
        var fontNameSG: CGPoint = CGPoint()
        
        var fontCoinSG: CGPoint = CGPoint()
        
        ngWH.x = nameStartWH.x * 0.75
        
        ngWH.y = nameStartWH.y * 0.75
        
        cvgWH.x = coinValueStartWH.x * 0.5 + 5
        
        cvgWH.y = coinValueStartWH.y * 0.5
        
//        cigWH.x = coinIconStartWH.x * 0.5
        
        cigWH.x = cvgWH.y
        
//        cigWH.y = coinIconStartWH.y * 0.5

        cigWH.y = cvgWH.y
        
        ngXY.x = pgXY.x - ngWH.x - 4
        
        ngXY.y = pgXY.y + 2
        
        cvgXY.x = pgXY.x - cvgWH.x
        
        cvgXY.y = pgXY.y + ngWH.y + 4
        
        cigXY.x = cvgXY.x - cigWH.x - 3
        
        cigXY.y = cvgXY.y + 3
        
        if(pgXY.x - ngWH.x - 4 > cigXY.x){
            
            ngXY.x = cigXY.x + 1
            
        }else{
            
            cigXY.x = ngXY.x - 1
            
            cvgXY.x = cigXY.x + cigWH.x + 3
            
        }
        
        fontNameSG.x = startNameFontSize
        
        fontNameSG.y = startNameFontSize / 1.3
        
        fontCoinSG.x = startCoinFontSize
        
        fontCoinSG.y = startCoinFontSize / 1.4
        
        
        myAnimateWithScroll(view: name, goalXY: ngXY, startXY: nameStartXY, goalWH: ngWH, startWH: nameStartWH, fontSG: fontNameSG)
        
        name.sizeToFit()
        
        myAnimateWithScroll(view: coinValue, goalXY: cvgXY, startXY: coinValueStartXY, goalWH: cvgWH, startWH: coinValueStartWH, fontSG: fontCoinSG)
        
        myAnimateWithScroll(view: coinIcon, goalXY: cigXY, startXY: coinIconStartXY, goalWH: cigWH, startWH: coinIconStartWH, fontSG: pgXY)
        
        //============//
        
        let k: CGFloat = (offsetOfsemiCircular + heightOfSemiCircular) / (offsetOfsemiCircular + heightOfSemiCircular - navigationBar.frame.height)
        
        var myPercentage = 1 - k * ( scrollViewProfile.contentOffset.y / (semicircularView.frame.origin.y + semicircularView.frame.height) )
        
        
        if(myPercentage < 0){
            
            myPercentage = 0
            
        }
        if(myPercentage > 1){
            
            myPercentage = 1
            
        }
        
        let buttonImage = UIImage(named: "setting 18")
        
        let buttonImage2 = UIImage(named: "messageIcon")
        
        settingButton.setImage(buttonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        messageButton.setImage(buttonImage2?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        var originalColor = DynamicColor(cgColor : UIColor.init(averageColorFrom: self.backgroundProfilePic.image).inverted().cgColor)
        
        
        if(((originalColor.redComponent * 299) + (originalColor.greenComponent * 587) + (originalColor.blueComponent * 114)) / 1000 > 0.5){
            
            originalColor = UIColor.white
            
        }else{
            
            originalColor = UIColor.black
            
        }
        
        
        let blackColor = DynamicColor.init(hexString: "#000000")
        
        settingButton.tintColor = originalColor.mixedRGB(withColor: blackColor, weight: 1-myPercentage)
        
        messageButton.tintColor = originalColor.mixedRGB(withColor: blackColor, weight: 1-myPercentage)
        
        
        navigationBar.alpha = 1 - myPercentage
        
        semicircularView.frame.origin.y = offsetOfsemiCircular + (heightOfSemiCircular - (heightOfSemiCircular * (myPercentage)))
        
        semicircularView.frame.size.height = heightOfSemiCircular * (myPercentage)

        profilePicButton.layer.cornerRadius = profilePicButton.frame.height * 0.5
        
        animationView.frame.origin.y = self.profilePicButton.frame.height / 2 - 15
        
        animationView.frame.origin.x = self.profilePicButton.frame.width / 2 - 15

    
    }
    


    @IBAction func changeView(_ sender: DCBorderedButton) {

        
    }
    
    func requestForMyCoupon(nextVc : MyCouponViewController){
        
        print(MyCouponRequestModel.init().getParams())
        
        request(URLs.getMyCoupon , method: .post , parameters: MyCouponRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {

                print("JSON ----------MY COUPON----------->>>> " ,JSON)
                //create my coupon response model
               
                if( MyCouponListResponseModel.init(json: JSON as! JSON)?.code == "200"){
                    
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        
                        if(MyCouponListResponseModel.init(json: JSON as! JSON)?.data != nil){
                            
                            nextVc.coupons = MyCouponListResponseModel.init(json: JSON as! JSON)?.data
                            
                            nextVc.couponsPrePics = [UIImage].init(reserveCapacity: (MyCouponListResponseModel.init(json: JSON as! JSON)?.data?.count)!)
                            
                        }
                        
                        nextVc.table.reloadData()
                        
                    }, completion: nil)

                    
                }
               
                
                print(JSON)
                
            }
            
        }
        
        
    }
    
    
    func requestForGetCoupon(nextVc : TakeCouponViewController){
        
        
        request(URLs.getCoupons , method: .post , parameters: GetCouponRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print(GetCouponRequestModel.init().getParams())
                
                print("JSON ----------GET COUPON----------->>>> " ,JSON)
                //create my coupon response model
                
                if(CouponListResponseModel.init(json: JSON as! JSON)?.code == "200"){
                    
                    nextVc.coupons = CouponListResponseModel.init(json: JSON as! JSON)?.data
                    
                    nextVc.loading.stopAnimating()
                    
                    nextVc.table.reloadData()
                    
                    
                }
                
                print(JSON)
                
            }
            
        }
        
        
    }
    

    func requestForPayHistory(nextVc : PayHistoryViewController){
        
        request(URLs.paylistHistory , method: .post , parameters: PayListRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------MY HISTORY----------->>>> ")
                //create my coupon response model
                if(PayListResponseModel.init(json: JSON as! JSON)?.code == "200"){
                    
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        
                        if(PayListResponseModel.init(json: JSON as! JSON)?.data == nil){
                            
                            // data nadarim
                            
                        }else{
                            nextVc.payHistory = (PayListResponseModel.init(json: JSON as! JSON)?.data)!
                            
                            nextVc.table.reloadData()
                            
                        }
                        
                    }, completion: nil)
                    
                }
                
                
                print(JSON)
                
            }
            
        }
        
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    func deletSubView(){
        
        if let viewWithTag = self.view.viewWithTag(125) {
        
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                viewWithTag.frame.origin.x = self.view.frame.width
                
                self.navigationBar.alpha = 1
                
                self.profilePicButton.alpha = 1
                
                self.scrollViewDidScroll(self.scrollViewProfile)
                
            }){ completion in
                
                viewWithTag.removeFromSuperview()
                
            }
            
        }
    }

    
    
    
    @IBAction func editName(_ sender: Any) {
        
        appearInputView(field: "نام")
        
    }
    
    
    @IBAction func editFamilyName(_ sender: Any) {
        
        appearInputView(field: "نام خانوادگی")
        
    }
    
    
    @IBAction func editGender(_ sender: Any) {
        
        appearInputView(field: "جنسیت")
        
        inputGenderViewContainer.alpha = 1
        
    }
   
    
    @IBAction func editMobile(_ sender: Any) {
        
        appearInputView(field: "موبایل")
        
    }
    
    
    @IBAction func editEmail(_ sender: Any) {
        
        appearInputView(field: "ایمیل")
        
    }
    
    
    @IBAction func editBirthDay(_ sender: Any) {
        
        appearDatePickerView()
        
    }
    
    
    
    @IBAction func confirmInput(_ sender: Any) {
        
        //set
        
        var rm : UserUpdateRequestModel?
        
        if(self.inputTitle.text == "نام"){
            
            if(self.inputTextField.text == ""){
                
                return
                
            }
            
            rm = UserUpdateRequestModel.init(NAME: self.inputTextField.text, FAMILY: nil, ATTRNAME: nil, ATTRDATA: nil)
            
        }else if(self.inputTitle.text == "نام خانوادگی"){
            
            if(self.inputTextField.text == ""){
                
                return
                
            }
            
            rm = UserUpdateRequestModel.init(NAME: nil, FAMILY: self.inputTextField.text, ATTRNAME: nil, ATTRDATA: nil)
            
        }else if(self.inputTitle.text == "موبایل"){
            
            if(self.inputTextField.text == ""){
                
                return
                
            }
            
            rm = UserUpdateRequestModel.init(NAME: nil, FAMILY: nil, ATTRNAME: "mobile", ATTRDATA: self.inputTextField.text)
            
        }else if(self.inputTitle.text == "ایمیل"){
            
            if(self.inputTextField.text == ""){
                
                return
                
            }
            
            rm = UserUpdateRequestModel.init(NAME: nil, FAMILY: nil, ATTRNAME: "email", ATTRDATA: self.inputTextField.text)
            
        }else if(self.inputTitle.text == "جنسیت"){
            
            if(maleRadio.isSelected){
                
                rm = UserUpdateRequestModel.init(NAME: nil, FAMILY: nil, ATTRNAME: "gender", ATTRDATA: "male")
                
            }else if(femaleRadio.isSelected){
                
                rm = UserUpdateRequestModel.init(NAME: nil, FAMILY: nil, ATTRNAME: "gender", ATTRDATA: "female")
                
            }
            
        }
        
        var before : Bool = self.checkProfileGift()
        
        request(URLs.userUpdate , method: .post , parameters: rm?.getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------User Update----------->>>> " , JSON)
                
                let obj = ProfileResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                    
                    
                    if(self.inputTitle.text == "نام"){
                        
                        self.nameButton.setTitle(self.inputTextField.text, for: UIControlState.normal)
                        
                        GlobalFields.PROFILEDATA?.name = self.inputTextField.text
                        
                    }else if(self.inputTitle.text == "نام خانوادگی"){
                        
                       self.familyNameButton.setTitle(self.inputTextField.text, for: UIControlState.normal)
                        
                        GlobalFields.PROFILEDATA?.family = self.inputTextField.text
                        
                    }else if(self.inputTitle.text == "موبایل"){
                        
                        self.mobileButton.setTitle(self.inputTextField.text, for: UIControlState.normal)
                        
                        GlobalFields.PROFILEDATA?.mobile = self.inputTextField.text
                        
                    }else if(self.inputTitle.text == "ایمیل"){
                        
                        self.emailButton.setTitle(self.inputTextField.text, for: UIControlState.normal)
                        
                        GlobalFields.PROFILEDATA?.email = self.inputTextField.text
                        
                    }else if(self.inputTitle.text == "جنسیت"){
                        
                        if(self.maleRadio.isSelected){
                            
                            self.genderButton.setTitle("مرد", for: UIControlState.normal)
                            
                            GlobalFields.PROFILEDATA?.gender = "male"
                            
                        }else if(self.femaleRadio.isSelected){
                            
                            self.genderButton.setTitle("زن", for: UIControlState.normal)
                            
                            GlobalFields.PROFILEDATA?.gender = "female"
                            
                        }
                        
                    }
                    
                    if(before == false && self.checkProfileGift() == true){
                        
                        GlobalFields.PROFILEDATA?.all_coin = String(Int((GlobalFields.PROFILEDATA?.all_coin)!)! + 5000)
                        
                        self.myCoinsValueLabel.text = GlobalFields.PROFILEDATA?.all_coin
                        
                        self.viewDidAppear(true)
                        
                        self.closeReport("")
                        
                        Notifys().notif(message: "تبریک! برنده ی ۵۰۰۰ دینگ تکمیل اطلاعات اختیاری شدی."){ alarm in
                            
                            self.present(alarm, animated: true, completion: nil)
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        
        
        //
        disAppearInputView()
        
    }
    
    func checkProfileGift() -> Bool{
        
        if(GlobalFields.PROFILEDATA?.gender == "" ||
           GlobalFields.PROFILEDATA?.email == "" ||
            GlobalFields.PROFILEDATA?.mobile == "" ||
            GlobalFields.PROFILEDATA?.family == "" ||
            GlobalFields.PROFILEDATA?.name == "" ||
            GlobalFields.PROFILEDATA?.birthdate == ""){
            
            return false
        }else{
            
            return true
            
        }
        
        
    }
    
    
    @IBAction func canselInput(_ sender: Any) {
       
        disAppearInputView()
        
    }

    @IBAction func confirmDatePicker(_ sender: Any) {
        
        //set
        
        self.datePicker.calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian) as Calendar!

        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd/MM/yyyy"
        
        formatter.calendar = Calendar(identifier: .gregorian)
        
        print(formatter.string(from: self.datePicker.date))
        
        GlobalFields.PROFILEDATA?.birthdate = formatter.string(from: self.datePicker.date)
        
        request(URLs.userUpdate , method: .post , parameters: UserUpdateRequestModel.init(NAME: nil, FAMILY: nil, ATTRNAME: "birthdate", ATTRDATA: formatter.string(from: self.datePicker.date)).getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------User Update----------->>>> " , JSON)
                
                let obj = ProfileResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                    
                    formatter.dateFormat = "yyyy/MM/dd"
                    
                    formatter.calendar = Calendar(identifier: .persian)
                    
                    self.BirthDayButton.setTitle(formatter.string(from: self.datePicker.date), for: UIControlState.normal)
                    
                    
                    
                }
                
            }
            
        }

        disAppearDatePickerView()
        
    }
    
    @IBAction func canselDataPicker(_ sender: Any) {
        
        disAppearDatePickerView()
        
    }
    
    
    func appearDatePickerView(){
        
        self.datePicker.calendar = NSCalendar(identifier: NSCalendar.Identifier.persian) as Calendar!
        
        self.datePicker.locale = NSLocale(localeIdentifier: "fa_IR") as Locale
        
        self.pickerContainerView.alpha = 1
        
        self.pickerContainerView.layer.zPosition = 1
        
        self.blurView.alpha = 0.3
        
        self.blurView.layer.zPosition = 1
        
    }
    
    func disAppearDatePickerView(){
        
        self.pickerContainerView.alpha = 0
        
        self.blurView.alpha = 0
        
    }
    
    func appearInputView(field : String!){
        
        self.inputContainerView.alpha = 1
        
        self.inputContainerView.layer.zPosition = 1
        
        self.inputTextField.text = ""
        
        self.blurView.alpha = 0.3
        
        self.blurView.layer.zPosition = 1
        
        self.inputTitle.text = field
        
    }
    
    func disAppearInputView(){
        
        self.inputContainerView.alpha = 0
        
        self.blurView.alpha = 0
        
        self.inputGenderViewContainer.alpha = 0
        
        self.view.endEditing(true)
        
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
            
            animationView = LOTAnimationView(name: "finall")
            
            animationView.frame.size.height = 30
            
            animationView.frame.size.width = 30
            
            animationView.frame.origin.y = self.profilePicButton.frame.height / 2 - 15
            
            animationView.frame.origin.x = self.profilePicButton.frame.width / 2 - 15
            
            animationView.contentMode = UIViewContentMode.scaleAspectFit
            
            animationView.alpha = 1
            
            self.profilePicButton.addSubview(animationView)
            
            animationView.loopAnimation = true
            
            animationView.play()
            
            request(URLs.userUpdate , method: .post , parameters: UserUpdateRequestModel.init(NAME: nil, FAMILY: nil, ATTRNAME: "pic", ATTRDATA: UIImagePNGRepresentation(pickedImage)!.base64EncodedString()).getParams(), encoding: JSONEncoding.default).responseJSON { response in
                print()
                
                if let JSON = response.result.value {
                    
                    print("JSON ----------User Update----------->>>> " , JSON)
                    
                    let obj = ProfileResponseModel.init(json: JSON as! JSON)
                    
                    if ( obj?.code == "200" ){
                        
                        self.animationView.pause()
                        
                        self.animationView.alpha = 0
                        
                        self.profilePicButton.contentMode = UIViewContentMode.scaleAspectFill
                        
                        self.profilePicButton.setBackgroundImage(pickedImage.af_imageAspectScaled(toFill: self.profilePicButton.frame.size), for: .normal)
                        
                        self.backgroundProfilePic.image = pickedImage.af_imageAspectScaled(toFill: self.backgroundProfilePic.frame.size)
                        
                        self.backgroundProfilePic.contentMode = UIViewContentMode.scaleAspectFill
                        
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

    @IBAction func goAboutUs(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController"))! as! AboutUsViewController
            
            self.addChildViewController(vc)
            
            vc.view.frame = CGRect(x:0,y: 0,width: self.view.frame.size.width, height: self.view.frame.size.height);
            
            vc.view.tag = 125
            
            self.view.addSubview(vc.view)
            
            vc.didMove(toParentViewController: self)
            
            
            
        }, completion: nil)
        
    }
    

    @IBAction func goFAQ(_ sender: Any) {
    
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "toTakeCouponViewController"){
            
            let nextVc = segue.destination as! TakeCouponViewController
            
            self.requestForGetCoupon(nextVc: nextVc)

            
        }else if(segue.identifier == "toMyCouponViewController"){
            
            let nextVc = segue.destination as! MyCouponViewController
            
            self.requestForMyCoupon(nextVc: nextVc)
            
            
        }else if(segue.identifier == "toPayHistoryViewController"){
            
            let nextVc = segue.destination as! PayHistoryViewController
            
            self.requestForPayHistory(nextVc: nextVc)
            
            
        }

        
        
    }
    
    
    
    @IBAction func doPayWithTolls(_ sender: Any) {
        
        
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        
        if(GlobalFields.PAY_UUIDS == nil){
            
            return
            
        }
        
        for payUuids in GlobalFields.PAY_UUIDS!{
            
            let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: payUuids)! as UUID, identifier: "Bding")
            
            locationManager.startRangingBeacons(in: region)
            
        }
        
        locationManager.distanceFilter = 1
        
        
        
        
    }
    
    func showPayPopup(payTitle : String){
        
        appearPayView()
        
        self.payTitleLabel.text = payTitle
        
        self.myCoinsValueLabel.text = GlobalFields.PROFILEDATA?.all_coin
        
    }
    
    var payBeacon : CLBeacon? = nil
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if(beacons.count == 0){
            
            Notifys().notif(message: "دستگاه پرداختی یافت نشد!"){ alarm in
                
                self.present(alarm, animated: true, completion: nil)
                
            }
            
            locationManager.stopRangingBeacons(in: region)
            
            return
            
        }
        
        for b in beacons {
            
            let beaconString = String(describing: b.proximityUUID)
            
            for u in GlobalFields.PAY_UUIDS! {
                
                print(u)
                
            }
            
            if(GlobalFields.PAY_UUIDS?.contains(beaconString.lowercased()))!{
                
                var payUrlString : String = ""
                
                payUrlString.append(URLs.payTitle)
                
                payUrlString.append(String(describing: b.proximityUUID).lowercased())
                
                payUrlString.append("-")
                
                payUrlString.append(String(describing: b.major).lowercased())
                
                payUrlString.append("-")
                
                payUrlString.append(String(describing: b.minor).lowercased())
                
                locationManager.stopRangingBeacons(in: region)
                
                request( payUrlString , method: .get , encoding: JSONEncoding.default).responseJSON { response in
                    print()
                    
                    if let JSON = response.result.value {
                        
                        print("JSON ----------GET PAY TITLE----------->>>> " ,JSON)
                        //create my coupon response model
                        
                        if( PayTitleResponseModel.init(json: JSON as! JSON)?.code == "200"){
                            
                            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                                
                                self.showPayPopup(payTitle: (PayTitleResponseModel.init(json: JSON as! JSON)?.result?.title)!)
                                
                                self.payBeacon = b
                                
                            }, completion: nil)
                            
                            
                        }
                        
                        
                        print(JSON)
                        
                    }
                    
                }
                
            }
            
        }
            
        locationManager.stopRangingBeacons(in: region)

        
    }
    
    
    @IBAction func confirmPay(_ sender: Any) {
        if((self.inputPayTextField.text == nil) || self.inputPayTextField.text == ""){
            
            return
            
        }
        if(Int(self.inputPayTextField.text!)! > Int((GlobalFields.PROFILEDATA?.all_coin)!)!){
            //mablaq bishtar az wallet ast
            return
            
        }
        
        
        request(URLs.payWithCoins , method: .post , parameters: PayWithCoinsRequestModel.init(BEACON: payBeacon, PAY: inputPayTextField.text!).getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------MY COUPON----------->>>> " ,JSON)
                //create my coupon response model
                
                if( MyCouponListResponseModel.init(json: JSON as! JSON)?.code == "200"){
                    
                    self.disAppearPayView()
                    
                    Notifys().notif(message: "پرداخت با موفقیت انجام شد."){ alert in
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    self.scrollViewDidScroll(self.scrollViewProfile)
                    
                    self.view.endEditing(true)
                    
                    GlobalFields.PROFILEDATA?.all_coin = String(Int((GlobalFields.PROFILEDATA?.all_coin)!)! - Int(self.inputPayTextField.text!)!)
                    
                    self.coinValue.text = GlobalFields.PROFILEDATA?.all_coin
                    
                }else{
                    
                    Notifys().notif(message: "عملیات پرداخت ناموفق!"){ alert in
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    self.view.endEditing(true)
                    
                }
                
                
                print(JSON)
                
            }
            
        }
        
        
        
        
    }
    
    
    @IBAction func canselPay(_ sender: Any) {
        
        
        
        disAppearPayView()
        
    }
    
    
    func appearPayView(){
        
        self.payContainer.alpha = 1
        
        self.payContainer.layer.zPosition = 1
        
        self.blurView.alpha = 0.3
        
        self.blurView.layer.zPosition = 1
        
    }
    
    func disAppearPayView(){
        
        self.payContainer.alpha = 0
        
        self.blurView.alpha = 0
        
    }
    
    
    @IBAction func closeReport(_ sender: Any) {

        if(self.reportLabel.alpha == 1){
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.reportLabel.frame.size.height = 0
                
                self.closeReportButton.frame.size.height = 0
                
                self.reportLabel.alpha = 0
                
                self.closeReportButton.alpha = 0
                
                for v in self.botViewInScrollView.subviews{
                    
                    v.frame.origin.y -= 40
                    
                }
                
                
            }, completion: nil)
            
        }
        
    }
    
    
}

















