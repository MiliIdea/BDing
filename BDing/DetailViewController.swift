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
    
    var customerHomeTableCellsOfCategoryPage = [CustomerHomeTableCell]()
    
    var cache: NSCache<AnyObject, AnyObject> = NSCache()
    
    var backgroundPic : PicModel? = nil
    
    // for class categoryPageViewController
    
    var color1 : CGColor? = nil
    
    var color2 : CGColor? = nil
    
    var subCategoryName : String? = nil
    
    var subCategoryIcon : UIImage? = nil
    
    //==================================================================//
    
    func setup(data : CustomerHomeTableCell!){
        
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

        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        scrollView.addSubview(viewInScrollView)
        
        scrollView.contentSize = viewInScrollView.frame.size
        
        heightOfSemiCircular = semicircularView.frame.height
        
        offsetOfsemiCircular = semicircularView.frame.origin.y
        
        self.cache = NSCache()

        self.scrollViewDidScroll(self.scrollView)
        
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
        
        
        
        navigationBar.alpha = 1 - myPercentage
        
        semicircularView.frame.origin.y = offsetOfsemiCircular + (heightOfSemiCircular - (heightOfSemiCircular * (myPercentage)))
        
        semicircularView.frame.size.height = heightOfSemiCircular * (myPercentage)
        
        
        
        //        bottomView.frame.origin.y = offsetOfsemiCircular + heightOfSemiCircular
        
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
            
        }
        
        
        
    }
    
    @IBAction func changeHeightOfText(_ sender: Any) {
        
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
