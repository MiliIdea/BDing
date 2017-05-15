//
//  DetailViewController.swift
//  BDing
//
//  Created by MILAD on 4/8/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit

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
    
    @IBOutlet weak var categoryName: UITextView!
    
    @IBOutlet weak var brandName: UITextField!
    
    @IBOutlet weak var coin: UILabel!
    
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var discount: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var nowIsOpen: UILabel!
    
    @IBOutlet weak var timeOfWork: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var webSiteAddress: UILabel!
    
    
    var heightOfSemiCircular: CGFloat = 0.0
    
    var offsetOfsemiCircular: CGFloat = 0.0
    
    var offsetOfBottomView: CGFloat = 0.0
    
    var customerHomeTableCellsOfCategoryPage = [CustomerHomeTableCell]()
    
    var cache: NSCache<AnyObject, AnyObject> = NSCache()
    
    var backgroundPic : PicModel? = nil
    
    var DELTA : CGFloat = 0.0
    
    var firstTextHeight : CGFloat = 0.0
    
    var firstScrollHeight : CGFloat = 0.0
    
    var firstBottomViewHeight : CGFloat = 0.0
    
    // for class categoryPageViewController
    
    var color1 : CGColor? = nil
    
    var color2 : CGColor? = nil
    
    var subCategoryName : String? = nil
    
    var subCategoryIcon : UIImage? = nil
    
    var cell:CustomerHomeTableCell? = nil
    
    //==================================================================//
    
    func setup(data : CustomerHomeTableCell!){
        
        cell = data
        
        self.categoryName.text = data.customerCampaignTitle
        
        brandName.text = data.customerName
        
        coin.text = data.customerCoinValue
        
        distance.text = data.customerDistanceToMe
        
        discount.text = data.customerDiscountValue
        
        textView.text = data.text
        
        nowIsOpen.text = "baz ast"
        
        timeOfWork.text = data.workTime
        
        address.text = data.address
        
        phone.text = data.tell
        
        webSiteAddress.text = data.website
        
        backgroundPic = data.customerBigImages?[0]
        
        var im: UIImage? = loadImage(picModel: backgroundPic!)
        
        if(im != nil){
            
            backgroundPicView.image = im
            
            
        }else{
            
            request("http://"+(backgroundPic?.url)! ,method: .post ,parameters: BeaconPicRequestModel(CODE: backgroundPic?.code, FILE_TYPE: backgroundPic?.file_type).getParams(), encoding : JSONEncoding.default).responseJSON { response in
                
                if let image = response.result.value {
                    
                    let obj = PicDataModel.init(json: image as! JSON)
                    
                    let imageData = NSData(base64Encoded: (obj?.data!)!, options: .ignoreUnknownCharacters)
                    
                    var coding: String = (self.backgroundPic?.url)!
                    
                    coding.append((self.backgroundPic?.code)!)
                    
                    SaveAndLoadModel().save(entityName: "IMAGE", datas: ["imageCode": coding.md5() , "imageData": obj?.data!])
                    
                    self.cache.setObject(imageData!, forKey: coding.md5() as AnyObject)
                    
                    var pic = UIImage(data: imageData as! Data)
                    
                    self.backgroundPicView.image = pic
                    
                    self.backgroundPicView.contentMode = UIViewContentMode.scaleAspectFill
                    
                }
            }
            
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
        
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        viewInScrollView.frame.size.height += 25
        
        categoryName.frame.origin.y = 0
        
        scrollView.addSubview(viewInScrollView)
        
        scrollView.contentSize = viewInScrollView.frame.size
        
        scrollView.contentSize.height += 35
        
        heightOfSemiCircular = semicircularView.frame.height
        
        offsetOfsemiCircular = semicircularView.frame.origin.y
        
        offsetOfBottomView = bottomView.frame.origin.y
        
        self.cache = NSCache()

        self.scrollViewDidScroll(self.scrollView)
        
        firstScrollHeight = self.viewInScrollView.frame.size.height
        
        firstTextHeight = self.textView.frame.height
        
        firstBottomViewHeight = self.bottomView.frame.size.height
        
        self.textView.isScrollEnabled = false
        
        self.textView.frame.size.height = self.firstTextHeight
        
        
        /////++++++++&&&&&&&&&%%%%%%%%%%%
        
        
        let bottomHeight = self.bottomDataView.frame.height
        
        self.textView.frame.size.height = self.firstTextHeight
        
        self.viewInScrollView.frame.size.height = self.firstScrollHeight
        
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
        
        self.bottomDataView.frame.size.height = bottomHeight
        
        self.textView.frame.size.height = self.firstTextHeight
        
        
        
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
        
        
        let k: CGFloat = (offsetOfsemiCircular + heightOfSemiCircular) / (offsetOfsemiCircular + heightOfSemiCircular - (navigationBar.frame.height+navigationBar.frame.origin.y))
        
        var myPercentage = 1 - k * ( self.scrollView.contentOffset.y / (semicircularView.frame.origin.y + semicircularView.frame.height) )
        
        
        if(myPercentage < 0){
            
            myPercentage = 0
            
        }
        
        if(myPercentage > 1){
            
            myPercentage = 1
            
        }
        
        
        if(self.scrollView.contentOffset.y < 0){
            
            self.backgroundPicView.frame.size.height = offsetOfBottomView - self.scrollView.contentOffset.y
            
        }else{
            
            self.backgroundPicView.frame.size.height = offsetOfBottomView
        }
        
        navigationBar.alpha = 1 - myPercentage
        
        semicircularView.frame.origin.y = offsetOfsemiCircular + (heightOfSemiCircular - (heightOfSemiCircular * (myPercentage)))
        
        semicircularView.frame.size.height = heightOfSemiCircular * (myPercentage)
        
        self.semicircularView.frame.size.width = self.view.frame.width
        
        self.semicircularView.frame.origin.y = self.topView.frame.height - self.semicircularView.frame.height

        
        }
   
    @IBAction func backButton(_ sender: Any) {
        
        if(self.parent is IndexHomeViewController){
            
            let vc = self.parent as! IndexHomeViewController
            
            vc.deletSubView()
            
        }else if(self.parent is CategoryPageViewController){
            
            let vc = self.parent as! CategoryPageViewController
            
            vc.deletSubView(cells: customerHomeTableCellsOfCategoryPage , color1 : color1! , color2 : color2! , subCName: subCategoryName! , subCIcon : subCategoryIcon!)
            
        }else if(self.parent is AlarmViewController){
            
            let vc = self.parent as! AlarmViewController
            
            vc.deletSubView()
            
        }else if(self.parent is MapViewController){
            
            let vc = self.parent as! MapViewController
            
            vc.deletSubView()
            
        }
        
        
        
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
        
        if(num == 0){
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
                let fixedWidth = self.textView.frame.size.width
                
                let tempH = self.textView.frame.height
                
                self.textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
                
                let newSize = self.textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
                
                var newFrame = self.textView.frame
                
                let bottomHeight = self.bottomDataView.frame.height
                
                newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
                
                self.textView.frame = newFrame
                
                self.DELTA = self.textView.frame.height - tempH

                self.viewInScrollView.frame.size.height += self.DELTA
                
                self.scrollView.contentSize = self.viewInScrollView.frame.size
                
                self.topView.frame.size.height = 193
                
                self.topView.frame.origin.y = 0
                
                self.bottomView.frame.size.height += self.DELTA
                
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
                
                self.bottomDataView.frame.size.height = bottomHeight
                
                self.textView.isScrollEnabled = false
                
                self.num = 1
            
            },completion : nil)
            
        }else{
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                let bottomHeight = self.bottomDataView.frame.height
                
                self.textView.frame.size.height = self.firstTextHeight
                
                self.viewInScrollView.frame.size.height = self.firstScrollHeight
                
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
                
                self.bottomDataView.frame.size.height = bottomHeight
                
                self.textView.frame.size.height = self.firstTextHeight
                
            }, completion : nil )
            
            self.num = 0
        }
        
        
    }
    
    func loadImage(picModel: PicModel) -> UIImage?{
        
        var tempCode = picModel.url
        
        tempCode?.append((picModel.code)!)
        
        let result: String? = isThereThisPicInDB(code: (tempCode?.md5())!)
        
        if(result != nil){
            
            if self.cache.object(forKey: tempCode?.md5() as AnyObject) != nil {
                
                return UIImage(data: self.cache.object(forKey: tempCode?.md5() as AnyObject) as! Data)!
                
            }else{
                
                let imageData = NSData(base64Encoded: result!, options: .ignoreUnknownCharacters)
                
                self.cache.setObject(imageData!, forKey: tempCode?.md5() as AnyObject)
                
                return UIImage(data: imageData as! Data)!
                
            }
            
        }else{
            
            return nil
            
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
    
}
