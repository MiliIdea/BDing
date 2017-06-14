//
//  DetailViewController.swift
//  BDing
//
//  Created by MILAD on 4/8/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit
import DynamicColor
import CoreImage
import ChameleonFramework

class DetailViewController: UIViewController , UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var viewInScrollView: UIView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var patternView: UIView!
    
    @IBOutlet weak var backgroundPicView: UIImageView!
    
    
    @IBOutlet weak var semicircularView: UIImageView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var backButton: UIButton!

    @IBOutlet weak var brandIcon: UIImageView!
    
    @IBOutlet weak var topDataView: UIView!
    
    @IBOutlet weak var bottomDataView: UIView!
    
    @IBOutlet weak var heightChangerButton: UIButton!
    
    ///
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var categoryName: UITextView!
    
    @IBOutlet weak var brandName: UITextField!
    
    @IBOutlet weak var coin: UILabel!
    
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var discount: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var nowIsOpen: UILabel!
    
    @IBOutlet weak var timeOfWork: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var phone: UIButton!
    
    @IBOutlet weak var webSiteAddress: UIButton!
    
    @IBOutlet weak var progressBarView: UIProgressView!
    
    var heightOfSemiCircular: CGFloat = 0.0
    
    var offsetOfsemiCircular: CGFloat = 0.0
    
    var offsetOfBottomView: CGFloat = 0.0
    
    var customerHomeTableCellsOfCategoryPage = [CustomerHomeTableCell]()
    
    var cache: NSCache<AnyObject, AnyObject> = NSCache()
    
    var backgroundPic : PicModel? = nil
    
    var DELTA : CGFloat = 0.0
    
    var firstTextHeight : CGFloat = 0.0
    
    var firstBottomViewHeight : CGFloat = 0.0
    
    // for class categoryPageViewController
    
    var color1 : CGColor? = nil
    
    var color2 : CGColor? = nil
    
    var subCategoryName : String? = nil
    
    var subCategoryIcon : UIImage? = nil
    
    var cell:CustomerHomeTableCell? = nil
    
    var isPopup: Bool = false
    
    var timer = Timer()
    
    var rect : CGRect? = nil
    //==================================================================//
    
    override func viewDidLayoutSubviews() {
        
        if(rect != nil){
            
            self.view.frame = rect!
            
        }
        
        print(self.view.frame.width)
        
        print(self.view.frame.height)
        
        print()
        
    }
    
    func setup(data : CustomerHomeTableCell! , isPopup : Bool , rect : CGRect?){
        
        if(rect != nil){
            
            self.rect = rect
            
        }
        
        cell = data
        
        self.isPopup = isPopup
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        self.progressBarView.setProgress(0.0, animated: true)

        firstTextHeight = self.textView.frame.height
        
        heightOfSemiCircular = semicircularView.frame.height
        
        offsetOfsemiCircular = semicircularView.frame.origin.y
        
        offsetOfBottomView = bottomView.frame.origin.y
        
        self.cache = NSCache()
        
        firstBottomViewHeight = self.bottomView.frame.size.height
        
        self.textView.isScrollEnabled = false

        
        //set FONTs 
        
        MyFont().setFontForAllView(view: self.view)
        
        MyFont().setBoldFont(view: categoryName, mySize: 14)
        
        MyFont().setWebFont(view: brandName, mySize: 13)
        
        MyFont().setWebFont(view: coin, mySize: 13)
        
        MyFont().setWebFont(view: distance, mySize: 13)
        
        MyFont().setWebFont(view: discount, mySize: 13)
        
        MyFont().setLightFont(view: textView, mySize: 13)
        
        MyFont().setWebFont(view: nowIsOpen, mySize: 13)
        
        MyFont().setWebFont(view: timeOfWork, mySize: 13)
        
        MyFont().setWebFont(view: address, mySize: 13)
        
        MyFont().setWebFont(view: phone, mySize: 13)
        
        MyFont().setWebFont(view: webSiteAddress, mySize: 13)
        
        self.topDataView.layer.shadowColor = UIColor.black.cgColor
        self.topDataView.layer.shadowOpacity = 0.25
        self.topDataView.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.topDataView.layer.shadowRadius = 3

        
        self.bottomDataView.layer.shadowColor = UIColor.black.cgColor
        self.bottomDataView.layer.shadowOpacity = 0.25
        self.bottomDataView.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.bottomDataView.layer.shadowRadius = 3
        
        if(isPopup == true){
            
            self.progressBarView.alpha = 1
            
        }else{
            
            self.progressBarView.alpha = 0
            
        }

        setFirstPosition()
        
        self.scrollView.addSubview(self.viewInScrollView)
        
        self.scrollViewDidScroll(self.scrollView)
        
        
        ///////////////////////////////////////////
        
        if(rect != nil){
            
            self.view.frame = rect!
            
        }
        
        let data = cell!
        
        self.categoryName.text = data.customerCampaignTitle
        
        brandName.text = data.customerName
        
        coin.text = data.customerCoinValue
        
        distance.text = data.customerDistanceToMe
        
        discount.text = data.customerDiscountValue
        
        textView.text = data.text
        
        nowIsOpen.text = "baz ast"
        
        timeOfWork.text = data.workTime
        
        address.text = data.address
        
        phone.setTitle(data.tell, for: UIControlState.normal)
        
        webSiteAddress.setTitle(data.website, for: UIControlState.normal)
        
        brandIcon.image = data.customerCategoryIcon
        
        backgroundPic = data.customerBigImages?[0]
        
        LoadPicture().proLoad(view: backgroundPicView, picModel: backgroundPic!){ resImage in
         
            self.backgroundPicView.image = resImage
            
            self.backgroundPicView.contentMode = UIViewContentMode.scaleAspectFill
            
            self.scrollViewDidScroll(self.scrollView)
            
        }
        
        
        // set now is open
        
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        //        print("hours = \(hour):\(minutes):\(seconds)")
        //
        //        print(cell?.workTime)
        
        var isOpen : Bool = false
        
        for s in (cell?.workTime?.characters.split(separator: "|"))!{
            
            let times: [String.CharacterView] = s.split(separator: "-")
            
            print(String(s))
            
            let h1 = String(times[0].split(separator: ":")[0])
            
            var m1 = "0"
            
            if(times[0].split(separator: ":").count > 1){
                
                m1 = String(times[0].split(separator: ":")[1])
                
            }
            
            let h2 = String(times[1].split(separator: ":")[0])
            
            var m2 = "0"
            
            if(times[1].split(separator: ":").count > 1){
                
                m2 = String(times[1].split(separator: ":")[1])
                
            }
            
            let time1 : Int = (Int(h1)! * 60) + Int(m1)!
            
            let time2 : Int = (Int(h2)! * 60) + Int(m2)!
            
            let mainTime : Int = (Int(hour) * 60) + Int(minutes)
            
            print(time1)
            print(time2)
            print(mainTime)
            
            if((mainTime < time1 || mainTime > time2) && isOpen == false){
                
                self.nowIsOpen.textColor = UIColor.red
                
                self.nowIsOpen.text = "بسته است"
                
            }else if(time2 - mainTime < 60){
                
                self.nowIsOpen.textColor = UIColor.yellow
                
                self.nowIsOpen.text = String(time2 - mainTime).appending(" دقیقه دیگر بسته می شود")
                
                isOpen = true
                
            }else{
                
                self.nowIsOpen.textColor = UIColor.green
                
                self.nowIsOpen.text = "باز است"
                
                isOpen = true
                
            }
            
            
        }
        
        self.scrollViewDidScroll(self.scrollView)
        
        
        ///////////////////////////////////////////
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if(isPopup == true){
            
            self.progressBarView.alpha = 1
            
            DispatchQueue.main.async {
             
                self.timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(DetailViewController.setProgressBar), userInfo: nil, repeats: true)
            
            }
            
        }else{
            
            self.progressBarView.alpha = 0
            
        }

        
    } 
    
    var counter : Float = 0.0
    
    func setProgressBar() {
        
        if(SaveAndLoadModel().getSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: (self.cell?.uuidMajorMinorMD5)!)?.value(forKey: "isSeen") as! Bool == true){
            
            timer.invalidate()
            
            return
            
        }
        
        if counter >= 1 {
            
            timer.invalidate()

            //inja bayad set coin she agar read shode bud countero bayad az qabl 1esh konam
            
            print(SetCoinRequestModel(CODE: self.cell?.customerImage?.code).getParams())
            
            request(URLs.setCoin , method: .post , parameters: SetCoinRequestModel(CODE: self.cell?.customerImage?.code).getParams(), encoding: JSONEncoding.default).responseJSON { response in
                print()
                
                if let JSON = response.result.value {
                    
                    print("JSON ----------setCoin----------->>>> " , JSON)
                    
                    let obj = SetCoinResponseModel.init(json: JSON as! JSON)
                    
                    if ( obj?.code == "200" ){
                        
                        self.progressBarView.tintColor = UIColor.green
                        
                        self.progressBarView.backgroundColor = UIColor.green
                        
                        GlobalFields.PROFILEDATA?.all_coin = obj?.data?.user_coin
                        
                        // popup that won 20 coin
                        
                        // set this beacon as a readed
                        
                        let d = SaveAndLoadModel().getSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: (self.cell?.uuidMajorMinorMD5)!)
                        
                        SaveAndLoadModel().updateSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: (self.cell?.uuidMajorMinorMD5!)! , newItem: ["uuid" : d?.value(forKey: "uuid") , "major" : d?.value(forKey: "major") , "minor" : d?.value(forKey: "minor") , "id" : d?.value(forKey: "id") , "isSeen" : true , "seenTime" : d?.value(forKey: "seenTime") , "beaconDataJSON" : d?.value(forKey: "beaconDataJSON") ,"isRemoved" : d?.value(forKey: "isRemoved")])
                        
                        self.updateBadgeVlue()
                        
                        Notifys().notif(message: "تبریک! دینگ این پیام را دریافت کردید."){ alert in
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                        
                    }else if ( obj?.code == "700" ){
                        
                        self.progressBarView.tintColor = UIColor.red
                        
                        self.progressBarView.backgroundColor = UIColor.red
                        
                        Notifys().notif(message: "در ۱۲ ساعت گذشته دینگ این پیام را دریافت کرده اید"){ alert in
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                        let d = SaveAndLoadModel().getSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: (self.cell?.uuidMajorMinorMD5)!)
                        
                        SaveAndLoadModel().updateSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: (self.cell?.uuidMajorMinorMD5!)! , newItem: ["uuid" : d?.value(forKey: "uuid") , "major" : d?.value(forKey: "major") , "minor" : d?.value(forKey: "minor") , "id" : d?.value(forKey: "id") , "isSeen" : true , "seenTime" : d?.value(forKey: "seenTime") , "beaconDataJSON" : d?.value(forKey: "beaconDataJSON") ,"isRemoved" : d?.value(forKey: "isRemoved")])
                        
                        self.updateBadgeVlue()
                        
                    }
                    
                }
                
            }
            
            
            return
        }
        // increment the counter
        counter += 0.01
        
        progressBarView.progress = counter
        
    }
    
    func updateBadgeVlue(){
        
        var count = 0
        
        for obj in SaveAndLoadModel().load(entity: "BEACON")! {
            
            if(obj.value(forKey: "isRemoved") as! Bool == false && obj.value(forKey: "isSeen") as! Bool == false){
                
                count += 1
                
            }
            
        }
        
        self.tabBarController?.tabBar.items?[1].badgeValue = String(count)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func setGradientLayer(myView: UIView , color1: CGColor , color2: CGColor){
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = myView.bounds
        
        gradientLayer.colors = [color1, color2]
        
        gradientLayer.startPoint = CGPoint(x: 0,y: 0.5)
        
        gradientLayer.endPoint = CGPoint(x: 1,y: 0.5)
        
        myView.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        scrollView.contentOffset.x = 0
       
        let k: CGFloat = (offsetOfsemiCircular + heightOfSemiCircular) / (offsetOfsemiCircular + heightOfSemiCircular - (navigationBar.frame.height+navigationBar.frame.origin.y))
        
        var myPercentage = 1 - k * ( self.scrollView.contentOffset.y / (semicircularView.frame.origin.y + semicircularView.frame.height) )
        
        
        if(myPercentage < 0){
            
            myPercentage = 0
            
        }
        
        if(myPercentage > 1){
            
            myPercentage = 1
            
        }
        
        
        if(self.scrollView.contentOffset.y < 0){
            
            self.backgroundPicView.frame.size.height = offsetOfBottomView - self.scrollView.contentOffset.y + 5
            
        }else{
            
            self.backgroundPicView.frame.size.height = offsetOfBottomView + 5
        }
        
        navigationBar.alpha = 1 - myPercentage
        
        ///////////////////////
        
        let buttonImage = UIImage(named: "arrow-right 18")
        
        let buttonImage2 = UIImage(named: "share 18")
        
        backButton.setImage(buttonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        shareButton.setImage(buttonImage2?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        var originalColor = DynamicColor(cgColor : UIColor.init(averageColorFrom: self.backgroundPicView.image).inverted().cgColor)

        
        print(((originalColor.redComponent * 299) + (originalColor.greenComponent * 587) + (originalColor.blueComponent * 114)) / 1000)
        
        if(((originalColor.redComponent * 299) + (originalColor.greenComponent * 587) + (originalColor.blueComponent * 114)) / 1000 > 0.5){
            
            originalColor = UIColor.white
            
        }else{
            
            originalColor = UIColor.black
            
        }
        
        
        let blackColor = DynamicColor.init(hexString: "#000000")
        
        shareButton.tintColor = originalColor.mixedRGB(withColor: blackColor, weight: 1-myPercentage)
        
        backButton.tintColor = originalColor.mixedRGB(withColor: blackColor, weight: 1-myPercentage)
        
        ////////////////////////////////////
        
        semicircularView.frame.origin.y = offsetOfsemiCircular + (heightOfSemiCircular - (heightOfSemiCircular * (myPercentage)))
        
        semicircularView.frame.size.height = heightOfSemiCircular * (myPercentage)
        
        self.semicircularView.frame.size.width = self.view.frame.width
        
        self.semicircularView.frame.origin.y = self.topView.frame.height - self.semicircularView.frame.height

        
        }
   
    @IBAction func backButton(_ sender: Any) {
        
        if(self.parent is IndexHomeViewController){
           
            self.progressBarView.alpha = 0
           
            (self.parent as! IndexHomeViewController).navigationBar.alpha = 1
            
            UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                (self.parent as! IndexHomeViewController).popupView.alpha = 0
                
                self.view.alpha = 0
                
            }){ completion in
                
                self.removeFromParentViewController()
                
            }
            
            return
            
        }
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    var num = 0
    
    @IBAction func changeHeightOfText(_ sender: Any) {
        
        //calculate height of text
        
        let fixedWidth = self.textView.frame.size.width
        
        let tempH = self.textView.frame.height
        
        self.textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        let newSize = self.textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        if(newSize.height < tempH && num == 0){
            
            return
            
        }
        
        //baz shodan
        
        if(num == 0){
//            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.heightChangerButton.imageView?.image = UIImage.init(named: "ic_keyboard_arrow_up_48pt")

                let fixedWidth = self.textView.frame.size.width
                
                let tempH = self.textView.frame.height
                
                self.textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
                
                let newSize = self.textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
                
                var newFrame = self.textView.frame
                
                let bottomHeight = self.bottomDataView.frame.height
                
                newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
                
                self.textView.frame = newFrame
                
                self.DELTA = self.textView.frame.height - tempH
                
                self.topView.frame.size.height = 193
                
                self.topView.frame.origin.y = 0
                
                self.bottomView.frame.size.height += self.DELTA
                
                self.viewInScrollView.frame.size.height = self.bottomView.frame.size.height + self.topView.frame.height

                self.topView.frame.size.height = 193
                
                self.topView.frame.origin.y = 0
                
                self.bottomView.frame.origin.y = self.topView.frame.height + self.topView.frame.origin.y
                
                self.topDataView.frame.size.height = self.textView.frame.height + 77
                
                self.categoryName.frame.size.height = 30
                
                self.categoryName.frame.origin.y = 0
                
                self.brandName.frame.size.height = 30
                
                self.brandIcon.frame.origin.y = self.categoryName.frame.size.height + 4
                
                self.brandName.frame.origin.y = self.categoryName.frame.size.height + 4
                
                self.topDataView.frame.origin.y = self.brandName.frame.origin.y + self.brandName.frame.height + 6
                
                self.bottomDataView.frame.origin.y += self.topDataView.frame.origin.y + self.topDataView.frame.height + 10
                
                self.textView.frame.origin.y = 40
                
                self.heightChangerButton.frame.size.height = 40
                
                self.heightChangerButton.frame.origin.y = self.topDataView.frame.height - 40
                
                self.semicircularView.frame.size.width = self.view.frame.width
                
                self.semicircularView.frame.origin.y = self.topView.frame.height - self.semicircularView.frame.height
                
                print("HEIGHT DUDE!!!! : ")
                print(self.topDataView.frame.height)
                
                self.bottomDataView.frame.size.height = bottomHeight
                
                self.bottomDataView.frame.origin.y = self.topDataView.frame.origin.y + self.topDataView.frame.height + 10

                
                self.viewInScrollView.frame.size.height = self.bottomView.frame.size.height + self.topView.frame.height + 50
        
                self.scrollView.contentSize = self.viewInScrollView.frame.size
                
                
                
            },completion : nil)
            
            self.num = 1
            
        }else{
            
            //baste shodan
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.heightChangerButton.imageView?.image = UIImage.init(named: "ic_keyboard_arrow_down_18pt")
                
                self.setFirstPosition()
             
    
            }, completion : nil )

            self.num = 0
        }
        
        
    }
    
    
    
//    
//    
//    
//    func loadImage(picModel: PicModel) -> UIImage?{
//        
//        var tempCode = picModel.url
//        
//        tempCode?.append((picModel.code)!)
//        
//        let result: String? = isThereThisPicInDB(code: (tempCode?.md5())!)
//        
//        if(result != nil){
//            
//            if self.cache.object(forKey: tempCode?.md5() as AnyObject) != nil {
//                
//                return UIImage(data: self.cache.object(forKey: tempCode?.md5() as AnyObject) as! Data)!
//                
//            }else{
//                
//                let imageData = NSData(base64Encoded: result!, options: .ignoreUnknownCharacters)
//                
//                self.cache.setObject(imageData!, forKey: tempCode?.md5() as AnyObject)
//                
//                return UIImage(data: imageData as! Data)!
//                
//            }
//            
//        }else{
//            
//            return nil
//            
//        }
//        
//    }
//    
//    
//    func isThereThisPicInDB (code: String) -> String?{
//        
//        for i in SaveAndLoadModel().load(entity: "IMAGE")!{
//            
//            if(i.value(forKey: "imageCode") as! String == code){
//                
//                return i.value(forKey: "imageData") as! String
//                
//            }
//            
//        }
//        
//        return nil
//        
//    }
    
    @IBAction func call(_ sender: Any) {
        
        guard let number = URL(string: "telprompt://" + (phone.titleLabel?.text)!) else { return }
        
        if #available(iOS 10.0, *) {
            
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
            
        } else {
            
            if let url = URL(string: "tel://\(number)") {
                
                UIApplication.shared.openURL(url)
                
            }
            
        }
        
    }
    
    @IBAction func goWeb(_ sender: Any) {
        
        UIApplication.shared.openURL(NSURL(string: "http://" + (webSiteAddress.titleLabel?.text)!)! as URL)
        
    }
    
    @IBAction func share(_ sender: Any) {
        
        let myShare = self.textView.text
        
        let image: UIImage = backgroundPicView.image!
        
        let shareVC: UIActivityViewController = UIActivityViewController(activityItems: [(image), myShare], applicationActivities: nil)
        
        self.present(shareVC, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    func setFirstPosition(){
        
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
        
        self.categoryName.frame.origin.y = 0
        
        
        self.textView.frame.size.height = self.firstTextHeight
        
        let bottomHeight = self.bottomDataView.frame.height
        
        self.textView.frame.size.height = self.firstTextHeight
        
        self.topView.frame.size.height = 193
        
        self.topView.frame.origin.y = 0
        
        self.viewInScrollView.frame.size.height = self.topView.frame.height + self.bottomView.frame.height
        
        self.scrollView.contentSize = self.viewInScrollView.frame.size

        self.topView.frame.size.height = 193
        
        self.topView.frame.origin.y = 0

        self.bottomView.frame.size.height = self.firstBottomViewHeight
        
        self.bottomView.frame.origin.y = self.topView.frame.height + self.topView.frame.origin.y
        
        self.topDataView.frame.size.height = self.textView.frame.height + 77
        
        self.categoryName.frame.size.height = 30
        
        self.categoryName.frame.origin.y = 0
        
        self.brandName.frame.size.height = 30
        
        self.brandIcon.frame.origin.y = self.categoryName.frame.size.height + 4
        
        self.brandName.frame.origin.y = self.categoryName.frame.size.height + 4
        
        self.topDataView.frame.origin.y = self.brandName.frame.origin.y + self.brandName.frame.height + 6
        
        self.bottomDataView.frame.origin.y += self.topDataView.frame.origin.y + self.topDataView.frame.height + 10
        
        self.textView.frame.origin.y = 40
        
        self.heightChangerButton.frame.size.height = 40
        
        self.heightChangerButton.frame.origin.y = self.topDataView.frame.height - 40
        
        self.semicircularView.frame.size.width = self.view.frame.width
        
        self.semicircularView.frame.origin.y = self.topView.frame.height - self.semicircularView.frame.height
            
        
        self.bottomDataView.frame.origin.y = self.topDataView.frame.origin.y + self.topDataView.frame.height + 10
        //+10
            
        self.bottomDataView.frame.size.height = bottomHeight
        
        self.textView.frame.size.height = self.firstTextHeight

        
        self.bottomView.frame.size.height = bottomHeight + self.topDataView.frame.height + 100
        
        self.semicircularView.frame.origin.y = self.topView.frame.height - self.semicircularView.frame.height
        
        self.scrollView.contentSize.height = self.bottomView.frame.size.height + self.topView.frame.height + 50
        

        },completion : nil)
        
        
    }
    
    
    
}








