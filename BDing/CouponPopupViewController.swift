//
//  CouponPopupViewController.swift
//  BDing
//
//  Created by MILAD on 5/23/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit
import DynamicColor

class CouponPopupViewController: UIViewController {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var couponImage: UIImageView!
    
    @IBOutlet weak var couponTitle: UILabel!
    
    @IBOutlet weak var couponTitleBorderedView: DCBorderedView!
//
//    @IBOutlet weak var couponDiscount: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var couponCoin: UILabel!
    
    @IBOutlet weak var couponDate: UILabel!
    
    @IBOutlet weak var couponDescription: UITextView!
    
    @IBOutlet weak var triangelImage: UIImageView!
//    @IBOutlet weak var couponAddress: UIButton!
//
//    @IBOutlet weak var couponTell: UIButton!
//    
//    @IBOutlet weak var couponWebsite: UIButton!
    
    /////////////
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var dingLabel: UILabel!
    
//    @IBOutlet weak var addressLabel: UILabel!
//
//    @IBOutlet weak var tellLabel: UILabel!
//    
//    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var motherView: DCBorderedView!
    
    @IBOutlet weak var backEffect: UIVisualEffectView!
    @IBOutlet weak var buyCouponButton: UIButton!
    
    @IBOutlet weak var firstButtonView: UIButton!
    /////////////

    var code : String? = nil
    
    var isMyCoupon : Bool = false
    
    var coin : String = ""
    
    func setup(myCoupon : MyCouponListData? ,coupon : CouponListData? , isMyCoupon : Bool){
        
        self.isMyCoupon = isMyCoupon
        
        if(isMyCoupon == true){
            
            buyCouponButton.alpha = 0
            
            couponTitle.text = myCoupon?.title
//
//            couponDiscount.text = myCoupon?.discount
            
            couponCoin.text = (myCoupon?.coin)! + " دینگ "
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd"
            
            formatter.calendar = Calendar(identifier: .gregorian)
            
            let d1 = formatter.date(from: (myCoupon?.start_date)!)
            
            let d2 = formatter.date(from: (myCoupon?.end_date)!)
            
            formatter.dateFormat = "MM/dd"
            
            formatter.calendar = Calendar(identifier: .persian)
            
            couponDate.text = formatter.string(from: d1!) + " الی " + formatter.string(from: d2!)
//            
            couponDescription.text = myCoupon?.description
            
            LoadPicture().proLoad(view: self.couponImage,picType: "coupon", picModel: (myCoupon?.url_pic1!)!){ resImage in
                
                self.couponImage.image = resImage
                
                self.couponImage.contentMode = UIViewContentMode.scaleAspectFill
                
                self.setColorOftop()
            }
            
            code = myCoupon?.coupon_code
            
            firstButtonView.setTitle(code, for: .normal)
            
            firstButtonView.isEnabled = false
            
            couponTitle.textColor = UIColor.init(hex: (myCoupon?.color)!)
            
            couponTitleBorderedView.borderColor = UIColor.init(hex: (myCoupon?.color)!)
            
        }else{
            
            couponTitle.text = coupon?.title
            
            couponCoin.text = (coupon?.coin)! + "دینگ "
            
            coin = (coupon?.coin)!
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd"
            
            formatter.calendar = Calendar(identifier: .gregorian)
            
            let d1 = formatter.date(from: (coupon?.start_date)!)
            
            let d2 = formatter.date(from: (coupon?.end_date)!)
            
            formatter.dateFormat = "MM/dd"
            
            formatter.calendar = Calendar(identifier: .persian)
            
            couponDate.text = formatter.string(from: d1!) + " الی " + formatter.string(from: d2!)
            
            couponDescription.text = coupon?.description
            
            LoadPicture().proLoad(view: self.couponImage,picType: "coupon", picModel: (coupon?.url_pic1!)!){ resImage in
                
                self.couponImage.image = resImage
                
                self.setColorOftop()
                
            }
            
            code = coupon?.url_pic?.code
            
            couponTitle.textColor = UIColor.init(hex: (coupon?.color)!)

            couponTitleBorderedView.borderColor = UIColor.init(hex: (coupon?.color)!)
            
            
            
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        MyFont().setFontForAllView(view: self.view)
        
        let triangle = TriangleView(frame: triangelImage.frame)
        triangelImage.addSubview(triangle)
        triangle.frame.origin.y = 0
        triangle.backgroundColor = UIColor(white: 1, alpha: 0)
        loading.hidesWhenStopped = true
        
//        couponTitleBorderedView.borderColor = UIColor.init(cgColor: DynamicColor.init(averageColorFrom: couponImage.image!).cgColor)
        couponTitleBorderedView.borderWidth = 1
        // Do any additional setup after loading the view.
        
        motherView.alpha = 0
        
        backEffect.alpha = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.motherView.alpha = 1
            
            self.backEffect.alpha = 0.5
            
        },completion : nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func close(_ sender: Any) {
        
        if(self.parent is TakeCouponViewController){
            
            let vc = self.parent as! TakeCouponViewController
            
            vc.deletSubView()
            
        }else if(self.parent is MyCouponViewController){
            
            let vc = self.parent as! MyCouponViewController
            
            vc.deletSubView()
            
        }else if(self.parent is PayViewController){
            
            let vc = self.parent as! PayViewController
            
            vc.deletSubView()
            
        }
        
    }
    
    @IBAction func share(_ sender: Any) {
        
        let myShare = "الان این تخفیف فوق العاده رو روی اپلیکیشن BDING پیدا کردم، اگر تو هم همچین تخفیف هایی میخوای اپلیکیشن رو دانلود کن! \n" + self.couponDescription.text + "\nنسخه اندروید نرم افزار بی دینگ \nhttps://play.google.com/store/apps/details?id=bding.ir.mycity \nنسخه ios \nhttps://new.sibapp.com/applications/bding \n\nwww.bding.ir\n"
        
        let image: UIImage = self.couponImage.image!
        
        let shareVC: UIActivityViewController = UIActivityViewController(activityItems: [(image), myShare], applicationActivities: nil)
        
        self.present(shareVC, animated: true, completion: nil)
        
    }
    
    @IBAction func firstClickToBuy(_ sender: Any) {
        if(isMyCoupon == true){
            return
        }
        buyCouponButton.frame.origin.x = -1 * buyCouponButton.frame.width
        
         UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
        (sender as! UIButton).frame.origin.x += (sender as! UIButton).frame.width
            self.buyCouponButton.frame.origin.x = 0
         }, completion : nil)
    }
    
    
    @IBAction func buyCoupon(_ sender: Any) {
        
        loading.layer.zPosition = 2
        
        (sender as! UIButton).addSubview(loading)
        
        loading.hidesWhenStopped = true
        
        loading.frame.origin.x = (buyCouponButton?.frame.width)! / 2 - loading.frame.width / 2
        
        loading.frame.origin.y = (buyCouponButton?.frame.height)! / 2 - loading.frame.height / 2
        
        loading.alpha = 1
        
        loading.startAnimating()
        
        (sender as! UIButton).setTitle("", for: .normal)
        
        print(BuyCouponRequestModel.init(CODE: code).getParams())
        request(URLs.buyCoupon , method: .post , parameters: BuyCouponRequestModel.init(CODE: code).getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------MY BUY COUPON----------->>>> ",JSON)
                //create my coupon response model
                
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.firstButtonView.frame.origin.x -= self.firstButtonView.frame.width
                    self.buyCouponButton.frame.origin.x = 0
                }, completion : nil)
                self.buyCouponButton.setTitle("تایید خرید", for: .normal)
                print()
                if(BuyCouponResponseModel.init(json: JSON as! JSON)?.code == "200"){

                    self.loading.stopAnimating()
                    
                    self.close("")
                    
                    Notifys().notif(message: BuyCouponResponseModel.init(json: JSON as! JSON)?.data?.msg ?? "خرید با موفقیت انجام شد"){ alert in
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    GlobalFields.PROFILEDATA?.all_coin = String(Int((GlobalFields.PROFILEDATA?.all_coin)!)! - Int(self.coin)!)
                
                }else{
                    
                    self.loading.stopAnimating()
                    
                    Notifys().notif(message: BuyCouponResponseModel.init(json: JSON as! JSON)?.data?.msg ?? "خرید ناموفق!"){ alert in
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
            }
            
        }
        
    }
    
    
    func setColorOftop(){
        
        let buttonImage = UIImage(named: "ic_close")
        
        let buttonImage2 = UIImage(named: "share 18")
        
        closeButton.setImage(buttonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        shareButton.setImage(buttonImage2?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        var originalColor = DynamicColor(cgColor : UIColor.init(patternImage: self.couponImage.image!).inverted().cgColor)
        
        
        print(((originalColor.redComponent * 299) + (originalColor.greenComponent * 587) + (originalColor.blueComponent * 114)) / 1000)
        
        if(((originalColor.redComponent * 299) + (originalColor.greenComponent * 587) + (originalColor.blueComponent * 114)) / 1000 > 0.5){
            
            originalColor = UIColor.white
            
        }else{
            
            originalColor = UIColor.black
            
        }
        
        shareButton.tintColor = originalColor
        
        closeButton.tintColor = originalColor
        
    }
    
    
    
    class TriangleView : UIView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override func draw(_ rect: CGRect) {
            
            guard let context = UIGraphicsGetCurrentContext() else { return }
            
            context.beginPath()
            context.move(to: CGPoint(x: rect.width, y: 0))
            context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            context.addLine(to: CGPoint(x: (rect.maxX), y: rect.maxY))
            context.closePath()

            context.setFillColor(UIColor.init(hex: "fafafa").cgColor)
            context.fillPath()
        }
    }

}
