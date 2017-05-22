//
//  ProfilePageViewController.swift
//  BDingTest
//
//  Created by Milad on 2/20/17.
//  Copyright © 2017 Milad. All rights reserved.
//

import UIKit

import DLRadioButton


class ProfilePageViewController: UIViewController ,UIImagePickerControllerDelegate, UIScrollViewDelegate , UINavigationControllerDelegate{
    
    @IBOutlet weak var backgroundProfilePic: UIImageView!
    
    @IBOutlet weak var scrollViewProfile: UIScrollView!
    
    @IBOutlet weak var viewInScrollView: UIView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var semicircularView: UIImageView!
    
    @IBOutlet weak var profilePicButton: DCBorderedButton!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var coinIcon: UIImageView!
    
    @IBOutlet weak var patternView: UIView!
    
    @IBOutlet weak var appSettingsIcon: UIImageView!
    
    
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
        
        MyFont().setFontForAllView(view: self.view)
        
        for subView in inputBoarderView.subviews {
            if (subView is UILabel){
                MyFont().setLightFont(view: subView, mySize: 13)
            }else {
                MyFont().setMediumFont(view: subView, mySize: 13)
            }
        }
        
        MyFont().setMediumFont(view: name, mySize: 14)
        MyFont().setMediumFont(view: coinValue, mySize: 13)
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
        
        scrollViewProfile.contentSize.height += 10
        
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
        
        var s : String? = GlobalFields.PROFILEDATA?.name
        
        
        if(GlobalFields.PROFILEDATA?.family != nil){
            
            s?.append(" ")
            
            s?.append((GlobalFields.PROFILEDATA?.family)!)
            
        }
        
        
        name.text = s
        
        nameStartXY.y = name.frame.origin.y
        
        print(name.frame.width)
        
        let fixedH = self.name.frame.size.height
        
        self.name.frame.size = self.name.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: fixedH))
        
        name.textAlignment = NSTextAlignment.center
        
        name.frame.origin.x = self.view.frame.width / 2 - self.name.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: fixedH)).width / 2
        
        nameStartXY.x = name.frame.origin.x
        
        nameStartWH.x = name.frame.width
        
        nameStartWH.y = name.frame.height


        scrollViewDidScroll(self.scrollViewProfile)
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
        
        cigWH.x = coinIconStartWH.x * 0.5
        
        cigWH.y = coinIconStartWH.y * 0.5
        
        ngXY.x = pgXY.x - ngWH.x - 4
        
        ngXY.y = pgXY.y
        
        cvgXY.x = pgXY.x - cvgWH.x
        
        cvgXY.y = pgXY.y + ngWH.y + 4
        
        cigXY.x = cvgXY.x - cigWH.x - 3
        
        cigXY.y = cvgXY.y 
        
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
        
        navigationBar.alpha = 1 - myPercentage
        
        semicircularView.frame.origin.y = offsetOfsemiCircular + (heightOfSemiCircular - (heightOfSemiCircular * (myPercentage)))
        
        semicircularView.frame.size.height = heightOfSemiCircular * (myPercentage)

        profilePicButton.layer.cornerRadius = profilePicButton.frame.height * 0.5

    
    }
    


    @IBAction func changeView(_ sender: DCBorderedButton) {
        
        if(sender.tag == 0){
            
            self.requestForGetCoupon()
            
        }else if(sender.tag == 1){
            
            self.requestForMyCoupon()
            
        }else if(sender.tag == 2){
            
            self.requestForPayHistory()
            
        }
        
    }
    
    func requestForMyCoupon(){
        
        request(URLs.getMyCoupon , method: .post , parameters: MyCouponRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {

                print("JSON ----------MY COUPON----------->>>> ")
                //create my coupon response model
               
                if( MyCouponListResponseModel.init(json: JSON as! JSON)?.code == "200"){
                    
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "MyCouponViewController"))! as! MyCouponViewController
                        
                        self.addChildViewController(vc)
                        
                        vc.view.frame = CGRect(x:0,y: 0,width: self.container.frame.size.width, height: self.container.frame.size.height);
                        
                        self.container.addSubview(vc.view)
                        
                        vc.didMove(toParentViewController: self)
                        
                        self.navigationBar.alpha = 0
                        
                        self.profilePicButton.alpha = 0
                        
                        vc.coupons = MyCouponListResponseModel.init(json: JSON as! JSON)?.data
                        
                    }, completion: nil)

                    
                }
               
                
                print(JSON)
                
            }
            
        }
        
        
    }
    
    
    func requestForGetCoupon(){
        
        request(URLs.getCoupons , method: .post , parameters: GetCouponRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print(GetCouponRequestModel.init().getParams())
                
                print("JSON ----------GET COUPON----------->>>> ")
                //create my coupon response model
                
                if(CouponListResponseModel.init(json: JSON as! JSON)?.code == "200"){
                    
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "TakeCouponViewController"))! as! TakeCouponViewController
                        
                        self.addChildViewController(vc)
                        
                        vc.view.frame = CGRect(x:0,y: 0,width: self.container.frame.size.width, height: self.container.frame.size.height);
                        
                        self.container.addSubview(vc.view)
                        
                        vc.didMove(toParentViewController: self)
                        
                        self.navigationBar.alpha = 0
                        
                        self.profilePicButton.alpha = 0
                        
                        vc.coupons = CouponListResponseModel.init(json: JSON as! JSON)?.data
                        
                    }, completion: nil)
                    
                }
                
                print(JSON)
                
            }
            
        }
        
        
    }
    

    func requestForPayHistory(){
        
        request(URLs.paylistHistory , method: .post , parameters: PayListRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------MY HISTORY----------->>>> ")
                //create my coupon response model
                if(PayListResponseModel.init(json: JSON as! JSON)?.code == "200"){
                    
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "PayHistoryViewController"))! as! PayHistoryViewController
                        
                        self.addChildViewController(vc)
                        
                        vc.view.frame = CGRect(x:0,y: 0,width: self.container.frame.size.width, height: self.container.frame.size.height);
                        
                        self.container.addSubview(vc.view)
                        
                        vc.didMove(toParentViewController: self)
                        
                        self.navigationBar.alpha = 0
                        
                        self.profilePicButton.alpha = 0
                        
                        if(PayListResponseModel.init(json: JSON as! JSON)?.data == nil){
                            
                            // data nadarim
                            
                        }else{
                            vc.payHistory = (PayListResponseModel.init(json: JSON as! JSON)?.data)!
                        }
                        
                    }, completion: nil)
                    
                }
                
                
                print(JSON)
                
            }
            
        }
        
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    func deletSubView(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "ProfilePageViewController"))! as! ProfilePageViewController
            
            self.addChildViewController(vc)
            
            vc.view.frame = CGRect(x:0,y: 0,width: self.container.frame.size.width, height: self.container.frame.size.height);
            
            self.container.addSubview(vc.view)
            
            
            
            vc.didMove(toParentViewController: self)
        }, completion: nil)
        
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
            
            rm = UserUpdateRequestModel.init(NAME: self.inputTextField.text, FAMILY: nil, ATTRNAME: nil, ATTRDATA: nil)
            
        }else if(self.inputTitle.text == "نام خانوادگی"){
            
            rm = UserUpdateRequestModel.init(NAME: nil, FAMILY: self.inputTextField.text, ATTRNAME: nil, ATTRDATA: nil)
            
        }else if(self.inputTitle.text == "موبایل"){
            
            rm = UserUpdateRequestModel.init(NAME: nil, FAMILY: nil, ATTRNAME: "mobile", ATTRDATA: self.inputTextField.text)
            
        }else if(self.inputTitle.text == "ایمیل"){
            
            rm = UserUpdateRequestModel.init(NAME: nil, FAMILY: nil, ATTRNAME: "email", ATTRDATA: self.inputTextField.text)
            
        }else if(self.inputTitle.text == "جنسیت"){
            
            if(maleRadio.isSelected){
                
                rm = UserUpdateRequestModel.init(NAME: nil, FAMILY: nil, ATTRNAME: "gender", ATTRDATA: "male")
                
            }else if(femaleRadio.isSelected){
                
                rm = UserUpdateRequestModel.init(NAME: nil, FAMILY: nil, ATTRNAME: "gender", ATTRDATA: "female")
                
            }
            
        }
        
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
                    
                }
                
            }
            
        }
        
        //
        disAppearInputView()
        
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
        
        self.blurView.alpha = 0.3
        
        self.blurView.layer.zPosition = 1
        
        self.inputTitle.text = field
        
    }
    
    func disAppearInputView(){
        
        self.inputContainerView.alpha = 0
        
        self.blurView.alpha = 0
        
        self.inputGenderViewContainer.alpha = 0
        
    }
    
    
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
            
            
            profilePicButton.contentMode = UIViewContentMode.scaleAspectFill
            
            
            
            profilePicButton.setBackgroundImage(pickedImage, for: .normal)
            
            
            
            
            
            backgroundProfilePic.image = pickedImage
            
            backgroundProfilePic.contentMode = UIViewContentMode.scaleAspectFill
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    

    
    
    
}
