//
//  CouponPopupViewController.swift
//  BDing
//
//  Created by MILAD on 5/23/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit

class CouponPopupViewController: UIViewController {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var couponImage: UIImageView!
    
    @IBOutlet weak var couponTitle: UILabel!
    
    @IBOutlet weak var couponDiscount: UILabel!
    
    @IBOutlet weak var couponCoin: UILabel!
    
    @IBOutlet weak var couponDate: UILabel!
    
    @IBOutlet weak var couponDescription: UITextView!
    
    @IBOutlet weak var couponAddress: UIButton!

    @IBOutlet weak var couponTell: UIButton!
    
    @IBOutlet weak var couponWebsite: UIButton!
    
    /////////////
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var dingLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!

    @IBOutlet weak var tellLabel: UILabel!
    
    @IBOutlet weak var websiteLabel: UILabel!
    
    @IBOutlet weak var buyCouponButton: UIButton!
    
    /////////////

    var code : String? = nil
    
    func setup(myCoupon : MyCouponListData? ,coupon : CouponListData? , isMyCoupon : Bool){
        
        if(isMyCoupon == true){
            
            buyCouponButton.alpha = 0
            
            couponTitle.text = myCoupon?.title
            
            couponDiscount.text = myCoupon?.discount
            
            couponCoin.text = myCoupon?.coin
            
            print(myCoupon?.end_date)
            
            print(myCoupon?.expire_date_service)
            
            couponDate.text = myCoupon?.end_date
            
            couponDescription.text = myCoupon?.description
            
            couponTell.setTitle(myCoupon?.tel, for: .normal)
            
            couponWebsite.setTitle(myCoupon?.site, for: .normal)
            
            couponAddress.setTitle(myCoupon?.address, for: .normal)
            
            LoadPicture().proLoad(view: self.couponImage,picType: "coupon", picModel: (myCoupon?.url_pic!)!){ resImage in
                
                self.couponImage.image = resImage
                
            }
            
            code = coupon?.url_pic?.code
            
        }else{
            
            couponTitle.text = coupon?.title
            
            couponDiscount.text = coupon?.discount
            
            couponCoin.text = coupon?.coin
            
            print(coupon?.end_date)
            
            print(coupon?.expire_date_service)
            
            couponDate.text = coupon?.start_date
            
            couponDescription.text = coupon?.description
            
            couponTell.setTitle(coupon?.tel, for: .normal)
            
            couponWebsite.setTitle(coupon?.site, for: .normal)
            
            couponAddress.setTitle(coupon?.address, for: .normal)
            
            LoadPicture().proLoad(view: self.couponImage,picType: "coupon", picModel: (coupon?.url_pic!)!){ resImage in
                
                self.couponImage.image = resImage
                
            }
            
            code = coupon?.url_pic?.code
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        MyFont().setFontForAllView(view: self.view)
        
        loading.hidesWhenStopped = true

        // Do any additional setup after loading the view.
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
            
        }
        
    }
    
    @IBAction func share(_ sender: Any) {
        
        let myShare = "الان این تخفیف فوق العاده رو روی اپلیکیشن BDING پیدا کردم، اگر تو هم همچین تخفیف هایی میخوای اپلیکیشن رو دانلود کن! \n" + self.couponDescription.text
        
        let image: UIImage = self.couponImage.image!
        
        let shareVC: UIActivityViewController = UIActivityViewController(activityItems: [(image), myShare], applicationActivities: nil)
        
        self.present(shareVC, animated: true, completion: nil)
        
    }
    
    @IBAction func buyCoupon(_ sender: Any) {
        
        loading.startAnimating()
        
        (sender as! UIButton).setTitle("", for: .normal)
        
        print(BuyCouponRequestModel.init(CODE: code).getParams())
        request(URLs.buyCoupon , method: .post , parameters: BuyCouponRequestModel.init(CODE: code).getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------MY BUY COUPON----------->>>> ",JSON)
                //create my coupon response model
                
                print()
                if(CouponListResponseModel.init(json: JSON as! JSON)?.code == "200"){

                    self.loading.stopAnimating()
                    
                    self.close("")
                    
                    Notifys().notif(message: "خرید با موفقیت انجام شد."){ alert in
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                
                }else{
                    
                    self.loading.stopAnimating()
                    
                    (sender as! UIButton).setTitle("خرید کوپن", for: .normal)
                    
                    Notifys().notif(message: "خرید ناموفق!"){ alert in
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
            }
            
        }
        
    }
    
    @IBAction func call(_ sender: Any) {
        
        guard let number = URL(string: "telprompt://" + (couponTell.titleLabel?.text)!) else { return }
        
        if #available(iOS 10.0, *) {
            
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
            
        } else {
            
            if let url = URL(string: "tel://\(number)") {
                
                UIApplication.shared.openURL(url)
                
            }
            
        }

        
    }
    
    
    @IBAction func goWeb(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: "http://" + (couponWebsite.titleLabel?.text)!)! as URL)
    }
   
    
    
    

    @IBAction func address(_ sender: Any) {
    }
    
    

}
