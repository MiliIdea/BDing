//
//  PayViewController.swift
//  BDing
//
//  Created by MILAD on 10/8/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import Lottie


class PayViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate,  CLLocationManagerDelegate , ShowcaseDelegate , UITextFieldDelegate ,CBPeripheralManagerDelegate{
    
    @IBOutlet weak var myDings: UILabel!
    
    @IBOutlet weak var myDingsIcon: UIImageView!
    
    @IBOutlet weak var payHistoryButton: DCBorderedButton!
    
    @IBOutlet weak var shopListButton: DCBorderedButton!
    
    @IBOutlet weak var lastCoupons: UICollectionView!
    
    @IBOutlet weak var popupPayButton: DCBorderedButton!
    
    @IBOutlet weak var payIcon: UIImageView!
    
    var myBTManager : CBPeripheralManager? = nil
    
    var animationView : LOTAnimationView?
    
    var coupons: [CouponListData]? = [CouponListData]()
    
    var couponImages : [UIImage?]? = [UIImage?]()
    
    // MARK: - PopupFields
    
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var popupView: DCBorderedView!
    
    @IBOutlet weak var popupTitle: UILabel!
    
    @IBOutlet weak var popupMyDings: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var canselPopup: DCBorderedButton!
    
    @IBOutlet weak var payButton: DCBorderedButton!
    
    @IBOutlet weak var inputPriceTextField: UITextField!
    
    @IBOutlet weak var attentionIcon: UIImageView!
    
    // MARK: - Cashier popup
    
    @IBOutlet weak var cashierPopupView: DCBorderedView!
    
    @IBOutlet weak var cashMyDing: UILabel!
    
    @IBOutlet weak var cashTitle: UILabel!
    
    @IBOutlet weak var cashPrice: UILabel!
    
    // MARK: - Charge account popup
    @IBOutlet weak var chargeAccountView: DCBorderedView!
    
    @IBOutlet weak var chargeMyDing: UILabel!
    
    @IBOutlet weak var chargePrice: UITextField!
    
    
    
    // MARK: - Local vars
    
    let locationManager = CLLocationManager()
    
    var payBeacon : CLBeacon? = nil
    
    let showcase = MaterialShowcase()
    
    var indexPay : Int = 0
    
    var checkPS : Bool = false
    
    var timer : Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lastCoupons.register(UINib(nibName: "LastCouponCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionViewCell2")
        
        lastCoupons.dataSource = self
        lastCoupons.delegate = self
        
        shopListButton.cornerRadius = shopListButton.frame.height / 2
        
        payHistoryButton.cornerRadius = payHistoryButton.frame.height / 2
        
        requestForGetCoupon()
        
        self.myDings.text = GlobalFields.PROFILEDATA?.all_coin
        
        self.popupMyDings.text = GlobalFields.PROFILEDATA?.all_coin
        
        self.cashMyDing.text = GlobalFields.PROFILEDATA?.all_coin
        
        self.chargeMyDing.text = GlobalFields.PROFILEDATA?.all_coin
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        closePopup("")
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkDing), name: .UIApplicationWillEnterForeground, object: nil)
        // Do any additional setup after loading the view.
        
        showcase.delegate = self
        
        inputPriceTextField.delegate = self
        
        myBTManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        
    }
    
    func dismissed() {
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.myDings.text = GlobalFields.PROFILEDATA?.all_coin
        
        self.popupMyDings.text = GlobalFields.PROFILEDATA?.all_coin
        
        self.cashMyDing.text = GlobalFields.PROFILEDATA?.all_coin
        
        self.chargeMyDing.text = GlobalFields.PROFILEDATA?.all_coin
        
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            
            self.showcase.setTargetView(view: self.popupPayButton) // always required to set targetView
            self.showcase.primaryText = "پرداخت با دینگ"
            self.showcase.secondaryText = "بعد از جمع کردن امتیاز (دینگ)، به فروشگاه‌های مجهز به دستگاه پرداخت بی‌دینگ رفته و تمام یا بخشی از پرداخت خود را انجام دهید."
            
            MyFont().setFontForAllView(view: self.showcase)
            
            self.showcase.show(id : "4",completion: {
                _ in
                // You can save showcase state here
                // Later you can check and do not show it again
                
                
            })
            
            
        }
        
        if(GlobalFields.goOnlinePay == true){
        
            self.updateProfile()
            
        }
        
        if(myBTManager?.state == CBManagerState.poweredOff){
            
            Notifys().notif(message: "لطفا جهت استفاده از دستگاه پرداخت بلوتوث خود را روشن کنید."){ alarm in
                
                self.present(alarm, animated: true, completion: nil)
                
            }
            
            return
        }
        
        
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        
        if(GlobalFields.PAY_UUIDS == nil){
            
            return
            
        }
        
        self.indexPay = 0
        
        let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: GlobalFields.PAY_UUIDS![indexPay].lowercased())! as UUID, identifier: "Bding")
        
        self.locationManager.startRangingBeacons(in: region)
        
        locationManager.distanceFilter = 1
        
        firstAnimate()
        
        
    }
    
    func checkDing(){
        if(GlobalFields.goOnlinePay == true){
            updateProfile()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Actions
    
    @IBAction func callPayPopUp(_ sender: Any) {
        
        if(myBTManager?.state == CBManagerState.poweredOff){
          
            Notifys().notif(message: "لطفا جهت استفاده از دستگاه پرداخت بلوتوث خود را روشن کنید."){ alarm in
                
                self.present(alarm, animated: true, completion: nil)
                
            }
            
            return
        }
        
        firstAnimate()
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIEvent, value: "PayButton")
        
        guard let builder = GAIDictionaryBuilder.createEvent(withCategory: "Payment", action: "Click", label: "PayButton", value: 0) else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        
        if(GlobalFields.PAY_UUIDS == nil){
            
            return
            
        }
        
        self.indexPay = 0
        
        let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: GlobalFields.PAY_UUIDS![indexPay].lowercased())! as UUID, identifier: "Bding")
        
        self.locationManager.startRangingBeacons(in: region)
        
        locationManager.distanceFilter = 1
        
    }
    
    @IBAction func payHistory(_ sender: Any) {
        
    }
    
    @IBAction func shopList(_ sender: Any) {
        
        UIApplication.shared.openURL(NSURL(string: "http://bding.ir/fa/shoplist") as! URL)
        
    }
    
    // MARK: - PopupActions
    
    @IBAction func switchOnlinePay(_ sender: Any) {
        
        
        
    }
    
    func showPayPopup(payTitle: String!){
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Payment")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
//        self.popupView.backgroundColor = self.popupPayButton.normalBackgroundColor
        
        self.payButton.setTitle("پرداخت مبلغ", for: .normal)
        
        self.popupView.cornerRadius = self.popupPayButton.cornerRadius
        
        self.popupView.frame = self.popupPayButton.frame
        
        self.popupTitle.text = payTitle
        
        self.inputPriceTextField.text = ""
        
        UIView.animate(withDuration: 0.01, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            for v in self.popupView.subviews{
                
                v.alpha = 0
                
            }
            
        }){completion in
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.blurView.alpha = 0.5
                
                self.popupView.alpha = 1
                
                self.popupView.frame.size.width = 300 / 375 * self.view.frame.width
                
                self.popupView.frame.size.height = 370 / 667 * self.view.frame.height
                
                self.popupView.frame.origin.x = self.view.frame.width / 2 - self.popupView.frame.width / 2
                
                self.popupView.frame.origin.y = 148 / 667 * self.view.frame.height
                
                //            self.popupView.backgroundColor = UIColor.init(hex: "ffffff")
                
                self.popupView.cornerRadius = 8
                
            },completion: nil)
            
        }
        
        
        
        UIView.animate(withDuration: 0.2, delay: 0.4, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            for v in self.popupView.subviews{
                
                v.alpha = 1
                
            }
            
        })
        
    }
    
    @IBAction func closePopup(_ sender: Any) {
        
        self.inputPriceTextField.text = ""
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            for v in self.popupView.subviews{
                
                v.alpha = 0
                
            }
            
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
        
            self.blurView.alpha = 0
            
            self.popupView.alpha = 0
            
            self.popupView.frame = self.popupPayButton.frame
            
            self.popupView.cornerRadius = self.popupPayButton.cornerRadius
            
        },completion : nil)
    }
    
    @IBAction func doPay(_ sender: Any) {
        
        if(self.inputPriceTextField.text == ""){
            return
        }
        
        if(Int(self.inputPriceTextField.text!)! == 0){
           return
        }
        
        if(payButton.title(for: .normal) != "تایید" && payButton.title(for: .normal) != "پرداخت آنلاین"){
            
            let myCALayer = payButton.layer
            var transform = CATransform3DIdentity
            transform.m34 = -1.0/100.0
            myCALayer.transform = CATransform3DRotate(transform, 0, 1, 0, 0)
            if(Int((GlobalFields.PROFILEDATA?.all_coin)!)! < Int(self.inputPriceTextField.text!)!){
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    
                    self.payButton.setTitle("پرداخت آنلاین", for: .normal)
                },completion : nil)
            }else{
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    
                    self.payButton.setTitle("تایید", for: .normal)
                },completion : nil)
            }
            
            SpAnimation.animate(myCALayer,
                                keypath: "transform.rotation.x",
                                duration: 3.0,
                                usingSpringWithDamping: 1.0,
                                initialSpringVelocity: 1.7,
                                fromValue: Double.pi,
                                toValue: 0,
                                onFinished: nil)
            
        }else{
        
            self.animationView = LOTAnimationView(name: "finall")
            
            self.animationView?.frame.size.height = self.payButton.frame.height - 20

            self.animationView?.frame.size.width = self.payButton.frame.height

            self.animationView?.frame.origin.y =  self.payButton.frame.origin.y + 10

            self.animationView?.frame.origin.x =  self.payButton.frame.origin.x + 10
            
            if(payButton.title(for: .normal) == "پرداخت آنلاین"){
                self.animationView?.frame.size.height = self.payButton.frame.height - 20
                
                self.animationView?.frame.size.width = self.payButton.frame.height
                
                self.animationView?.frame.origin.y =  self.payButton.frame.origin.y + 10
                
                self.animationView?.frame.origin.x =  self.payButton.frame.origin.x - 5
            }
            
            //+ (self.payButton.frame.width / 2) - ((self.animationView?.frame.width)! / 2)
            
            self.animationView?.contentMode = UIViewContentMode.scaleAspectFit
            
            self.animationView?.alpha = 1
            
            self.animationView?.layer.zPosition = 2
            
            self.popupView.addSubview(self.animationView!)
            
            self.animationView?.loopAnimation = true
            
            self.animationView?.play()
            
            self.view.isUserInteractionEnabled = false
            
            self.popupView.isUserInteractionEnabled = false
            
            let manager = SessionManager.default2
            
            manager.request(URLs.payment , method: .post , parameters: PaymentRequestModel.init(BEACON: payBeacon, MONEY: self.inputPriceTextField.text!).getParams(), encoding: JSONEncoding.default).responseJSON { response in
                print()

                switch (response.result) {
                case .failure(let _):
                    
                    self.animationView?.stop()
                    
                    self.animationView?.alpha = 0
                    
                    self.payButton.setTitle("پرداخت مبلغ", for: .normal)
                    
                    self.view.isUserInteractionEnabled = true
                    
                    self.popupView.isUserInteractionEnabled = true
                    
                    return
                    
                    
                default: break
                    
                }
                
                if let JSON = response.result.value {

                    print("JSON ----------Payment----------->>>> " ,JSON)
                    //create my coupon response model

                    self.view.isUserInteractionEnabled = true
                    
                    self.popupView.isUserInteractionEnabled = true
                    
                    if(PaymentResponseModel.init(json: JSON as! JSON)?.code == "5005"){
                        GlobalFields().goErrorPage(viewController: self)
                    }
                    
                    if( PaymentResponseModel.init(json: JSON as! JSON)?.code == "200"){

                        request(URLs.verifyPayment , method: .post , parameters: PaymentVerifyRequestModel.init(CODE: PaymentResponseModel.init(json: JSON as! JSON)?.data?.code).getParams(), encoding: JSONEncoding.default).responseJSON { response in
                            print()

                            if let JSON2 = response.result.value {

                                print("JSON ----------Payment Verify----------->>>> " ,JSON2)
                                //create my coupon response model

                                if( PaymentVerifyResponseModel.init(json: JSON2 as! JSON)?.code == "200"){
                                    
                                    self.payButton.setTitle("پرداخت مبلغ", for: .normal)
                                    
                                    if(PaymentVerifyResponseModel.init(json: JSON2 as! JSON)?.data?.url?.isEmpty)!{
                                        self.closePopup("")
                                        self.updateProfile()
                                        Notifys().notif(message: "پرداخت با موفقیت انجام شد"){ alarm in
                                            
                                            self.present(alarm, animated: true, completion: nil)
                                            
                                        }
                                    }else{
                                        GlobalFields.goOnlinePay = true
                                        self.viewDidDisappear(true)
                                        UIApplication.shared.openURL(URL(string: (PaymentVerifyResponseModel.init(json: JSON2 as! JSON)?.data?.url)!)!)
                                    }

                                }else{
                                    
                                    Notifys().notif(message: PaymentVerifyResponseModel.init(json: JSON2 as! JSON)?.msg){ alarm in
                                        
                                        self.present(alarm, animated: true, completion: nil)
                                        
                                    }
                                    
                                }
                                self.closePopup("")
                                
                                self.animationView?.alpha = 0
                                
                                self.animationView?.stop()
                                
                                self.animationView?.removeFromSuperview()
                            }

                        }

                    }else{
                        
                        self.closePopup("")
                        
                        self.animationView?.alpha = 0
                        
                        self.animationView?.stop()
                        
                        self.animationView?.removeFromSuperview()
                        
                    }

                }

            }

            
        }
        
        
    }
    
    func updateProfile(){
    
        request(URLs.getDing , method: .post , parameters: GetDingsRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------Get Ding----------->>>> " ,JSON)
                //create my coupon response model
                
                if(PaymentVerifyResponseModel.init(json: JSON as! JSON)?.code == "5005"){
                    GlobalFields().goErrorPage(viewController: self)
                }
                
                if( PaymentVerifyResponseModel.init(json: JSON as! JSON)?.code == "200"){
                    
                    if(GlobalFields.goOnlinePay == true){
                        
                        if(GlobalFields.PROFILEDATA?.all_coin != PaymentVerifyResponseModel.init(json: JSON as! JSON)?.data?.all_ding){
                            
                            Notifys().notif(message: "پرداخت با موفقیت انجام شد"){ alarm in
                                
                                self.present(alarm, animated: true, completion: nil)
                                
                            }
                            
                        }
                    }
                    
                    GlobalFields.PROFILEDATA?.all_coin = PaymentVerifyResponseModel.init(json: JSON as! JSON)?.data?.all_ding
                    
                    self.myDings.text = GlobalFields.PROFILEDATA?.all_coin
                    
                    self.popupMyDings.text = GlobalFields.PROFILEDATA?.all_coin
                    
                    self.cashMyDing.text = GlobalFields.PROFILEDATA?.all_coin
                    
                    self.chargeMyDing.text = GlobalFields.PROFILEDATA?.all_coin
                    
                    GlobalFields.goOnlinePay = false
                    
                }
                
            }
            
        }
        
        
        
    }
    
    
    
    func firstAnimate(){
        
        self.view.isUserInteractionEnabled = false
        
        payIcon.alpha = 0
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.popupPayButton.cornerRadius = self.popupPayButton.frame.height / 2
            
            self.popupPayButton.frame.size.width = self.popupPayButton.frame.height
            
            self.popupPayButton.normalTextColor = self.popupPayButton.normalBackgroundColor
            
            self.popupPayButton.frame.origin.x = self.view.frame.width / 2 - self.popupPayButton.frame.height / 2
            
        }){completion in
            
            self.animationView = LOTAnimationView(name: "finall")
            
            self.animationView?.frame.size.height = self.popupPayButton.frame.height
            
            self.animationView?.frame.size.width = self.popupPayButton.frame.height
            
            self.animationView?.frame.origin.y =  self.popupPayButton.frame.origin.y
            
            self.animationView?.frame.origin.x = self.view.frame.width / 2 - self.popupPayButton.frame.height / 2
            
            self.animationView?.contentMode = UIViewContentMode.scaleAspectFit
            
            self.animationView?.alpha = 1
            
            self.view.addSubview(self.animationView!)
            
            self.animationView?.loopAnimation = true
            
            self.animationView?.play()
            
        }
        
    }
    
    func secondAnimate(){
        
        self.view.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.2, delay: 0.6 , options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.popupPayButton.cornerRadius = 3
            
            self.popupPayButton.frame.size.width = self.view.frame.width * 145 / 375
            
            self.popupPayButton.frame.origin.x = self.view.frame.width / 2 - (self.view.frame.width * 145 / 375) / 2
            self.animationView?.alpha = 0
            
        }){completion in
            
            let when = DispatchTime.now() // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    
                    self.animationView?.stop()
                    
                    self.animationView?.alpha = 0
                    
                    self.payIcon.alpha = 1
                    
                    self.popupPayButton.normalTextColor = UIColor.init(hex: "ffffff")
                    
                },completion : nil)
                
            }
            
        }
        
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.payButton.setTitle("پرداخت مبلغ", for: .normal)
        
    }
    
    // MARK: - CashPopup Actions
    
    @IBAction func cashPay(_ sender: Any) {
        
        var payButt : UIButton = sender as! UIButton
        
        if(payButt.title(for: .normal) != "تایید" && payButt.title(for: .normal) != "پرداخت آنلاین"){
            
            let myCALayer = payButt.layer
            var transform = CATransform3DIdentity
            transform.m34 = -1.0/100.0
            myCALayer.transform = CATransform3DRotate(transform, 0, 1, 0, 0)
            if(Int((GlobalFields.PROFILEDATA?.all_coin)!)! < Int(self.cashPrice.text!)!){
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    
                    payButt.setTitle("پرداخت آنلاین", for: .normal)
                },completion : nil)
            }else{
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    
                    payButt.setTitle("تایید", for: .normal)
                },completion : nil)
            }
            
            SpAnimation.animate(myCALayer,
                                keypath: "transform.rotation.x",
                                duration: 3.0,
                                usingSpringWithDamping: 1.0,
                                initialSpringVelocity: 1.7,
                                fromValue: Double.pi,
                                toValue: 0,
                                onFinished: nil)
            
        }else{
            
            self.animationView = LOTAnimationView(name: "finall")
            
            self.animationView?.frame.size.height = payButt.frame.height - 20
            
            self.animationView?.frame.size.width = payButt.frame.height
            
            self.animationView?.frame.origin.y =  payButt.frame.origin.y + 10
            
            self.animationView?.frame.origin.x =  payButt.frame.origin.x + 10
            
            if(payButt.title(for: .normal) == "پرداخت آنلاین"){
                self.animationView?.frame.size.height = payButt.frame.height - 20
                
                self.animationView?.frame.size.width = payButt.frame.height
                
                self.animationView?.frame.origin.y =  payButt.frame.origin.y + 10
                
                self.animationView?.frame.origin.x =  payButt.frame.origin.x - 5
            }
            
            //+ (self.payButton.frame.width / 2) - ((self.animationView?.frame.width)! / 2)
            
            self.animationView?.contentMode = UIViewContentMode.scaleAspectFit
            
            self.animationView?.alpha = 1
            
            self.animationView?.layer.zPosition = 2
            
            self.cashierPopupView.addSubview(self.animationView!)
            
            self.animationView?.loopAnimation = true
            
            self.animationView?.play()
            
            self.view.isUserInteractionEnabled = false
            
            self.cashierPopupView.isUserInteractionEnabled = false
            
            let manager = SessionManager.default2
            print(PaymentRequestModel.init(BEACON: payBeacon, MONEY: self.cashPrice.text!).getParams())
            manager.request(URLs.payment , method: .post , parameters: PaymentRequestModel.init(BEACON: payBeacon, MONEY: self.cashPrice.text!).getParams(), encoding: JSONEncoding.default).responseJSON { response in
                print()
                
                switch (response.result) {
                case .failure(let _):
                    
                    self.animationView?.stop()
                    
                    self.animationView?.alpha = 0
                    
                    payButt.setTitle("پرداخت مبلغ", for: .normal)
                    
                    self.view.isUserInteractionEnabled = true
                    
                    self.cashierPopupView.isUserInteractionEnabled = true
                    
                    return
                    
                    
                default: break
                    
                }
                
                if let JSON = response.result.value {
                    
                    print("JSON ----------Payment----------->>>> " ,JSON)
                    //create my coupon response model
                    
                    self.view.isUserInteractionEnabled = true
                    
                    self.cashierPopupView.isUserInteractionEnabled = true
                    
                    if(PaymentResponseModel.init(json: JSON as! JSON)?.code == "5005"){
                        GlobalFields().goErrorPage(viewController: self)
                    }
                    
                    if( PaymentResponseModel.init(json: JSON as! JSON)?.code == "200"){
                        print(PaymentVerifyRequestModel.init(CODE: PaymentResponseModel.init(json: JSON as! JSON)?.data?.code).getParams())
                        request(URLs.verifyPayment , method: .post , parameters: PaymentVerifyRequestModel.init(CODE: PaymentResponseModel.init(json: JSON as! JSON)?.data?.code).getParams(), encoding: JSONEncoding.default).responseJSON { response in
                            print()
                            
                            if let JSON2 = response.result.value {
                                
                                print("JSON ----------Payment Verify----------->>>> " ,JSON2)
                                //create my coupon response model
                                
                                if( PaymentVerifyResponseModel.init(json: JSON2 as! JSON)?.code == "200"){
                                    
                                    payButt.setTitle("پرداخت مبلغ", for: .normal)
                                    
                                    if(PaymentVerifyResponseModel.init(json: JSON2 as! JSON)?.data?.url?.isEmpty)!{
                                        self.closeCashPopup()
                                        self.updateProfile()
                                        Notifys().notif(message: "پرداخت با موفقیت انجام شد"){ alarm in
                                            
                                            self.present(alarm, animated: true, completion: nil)
                                            
                                        }
                                    }else{
                                        GlobalFields.goOnlinePay = true
                                        self.viewDidDisappear(true)
                                        UIApplication.shared.openURL(URL(string: (PaymentVerifyResponseModel.init(json: JSON2 as! JSON)?.data?.url)!)!)
                                    }
                                    
                                }else{
                                    
                                    Notifys().notif(message: PaymentVerifyResponseModel.init(json: JSON2 as! JSON)?.msg){ alarm in
                                        
                                        self.present(alarm, animated: true, completion: nil)
                                        
                                    }
                                    
                                }
                                self.closeCashPopup()
                                
                                self.animationView?.alpha = 0
                                
                                self.animationView?.stop()
                                
                                self.animationView?.removeFromSuperview()
                            }
                            
                        }
                        
                    }else{
                        
                        self.closeCashPopup()
                        
                        self.animationView?.alpha = 0
                        
                        self.animationView?.stop()
                        
                        self.animationView?.removeFromSuperview()
                        
                    }
                    
                }
                
            }
            
            
        }
        
        
    }
    
    @IBAction func cashCancel(_ sender: Any) {
        
        let manager = SessionManager.default2
        print(PaymentRequestModel.init(BEACON: payBeacon, MONEY: "-1").getParams())
        manager.request(URLs.payment , method: .post , parameters: PaymentRequestModel.init(BEACON: payBeacon, MONEY: "-1").getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            if let JSON = response.result.value {
                
                print("JSON ----------Payment----------->>>> \n" ,JSON)
                
            }
            
        }
        
        closeCashPopup()
        
    }
    
    func showCashPopup(title : String , price: String){
        self.cashTitle.text = title
        self.cashPrice.text = price
        self.blurView.alpha = 0.5
        self.cashierPopupView.alpha = 1
        
    }
    
    func closeCashPopup(){
        self.blurView.alpha = 0
        self.cashierPopupView.alpha = 0
    }
    
    // MARK: - ChargeAccountActions
    
    @IBAction func charging(_ sender: Any) {
        
        if(self.chargePrice.text == ""){
            return
        }
        if(Int(self.chargePrice.text!)! == 0){
            return
        }
        
        self.view.isUserInteractionEnabled = false
        
        self.chargeAccountView.isUserInteractionEnabled = false
        
        let manager = SessionManager.default2
        
        manager.request(URLs.charge , method: .post , parameters: ChargeRequestModel.init(MONEY: self.chargePrice.text!).getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            switch (response.result) {
            case .failure(let _):
                
//                self.animationView?.stop()
//
//                self.animationView?.alpha = 0
                
                self.view.isUserInteractionEnabled = true
                
                self.chargeAccountView.isUserInteractionEnabled = true
                
                return
                
                
            default: break
                
            }
            
            if let JSON = response.result.value {
                
                print("JSON ----------cahrge----------->>>> " ,JSON)
                //create my coupon response model
                
                self.view.isUserInteractionEnabled = true
                
                self.chargeAccountView.isUserInteractionEnabled = true
                
                if(PaymentResponseModel.init(json: JSON as! JSON)?.code == "5005"){
                    GlobalFields().goErrorPage(viewController: self)
                }
                
                if( PaymentResponseModel.init(json: JSON as! JSON)?.code == "200"){
                    
                    request(URLs.verifyCharge , method: .post , parameters: VerifyChargeRequestModel.init(CODE: PaymentResponseModel.init(json: JSON as! JSON)?.data?.code).getParams(), encoding: JSONEncoding.default).responseJSON { response in
                        print()
                        
                        if let JSON2 = response.result.value {
                            
                            print("JSON ----------charge Verify----------->>>> " ,JSON2)
                            //create my coupon response model
                            
                            if( PaymentVerifyResponseModel.init(json: JSON2 as! JSON)?.code == "200"){
                                
                                if(PaymentVerifyResponseModel.init(json: JSON2 as! JSON)?.data?.url?.isEmpty)!{
                                    self.cancelCharging("")
                                    self.updateProfile()
                                    Notifys().notif(message: "شارژ با موفقیت انجام شد"){ alarm in
                                        
                                        self.present(alarm, animated: true, completion: nil)
                                        
                                    }
                                }else{
                                    
                                    GlobalFields.goOnlinePay = true
                                    self.viewDidDisappear(true)
                                    UIApplication.shared.openURL(URL(string: (PaymentVerifyResponseModel.init(json: JSON2 as! JSON)?.data?.url)!)!)
                                }
                                
                            }else{
                                
                                Notifys().notif(message: PaymentVerifyResponseModel.init(json: JSON2 as! JSON)?.msg){ alarm in
                                    
                                    self.present(alarm, animated: true, completion: nil)
                                    
                                }
                                
                            }
                            self.cancelCharging("")
                            
//                            self.animationView?.alpha = 0
//
//                            self.animationView?.stop()
//
//                            self.animationView?.removeFromSuperview()
                        }
                        
                    }
                    
                }else{
                    
                    self.cancelCharging("")
//                    self.animationView?.alpha = 0
//
//                    self.animationView?.stop()
//
//                    self.animationView?.removeFromSuperview()
                    
                }
                
            }
            
        }
        
        
    }
    
    @IBAction func cancelCharging(_ sender: Any) {
        self.blurView.alpha = 0
        self.chargeAccountView.alpha = 0
    }
    
    @IBAction func showChargingPopup(_ sender: Any) {
        self.blurView.alpha = 0.5
        self.chargeAccountView.alpha = 1
    }
    
    // MARK: - LocationManager
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if(beacons.count == 0){
            
            if(indexPay + 1 <= (GlobalFields.PAY_UUIDS?.count)! - 1){
                indexPay += 1
                let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: GlobalFields.PAY_UUIDS![indexPay].lowercased())! as UUID, identifier: "Bding")
                
                self.locationManager.startRangingBeacons(in: region)
                
                return
            }else{
            
                Notifys().notif(message: "دستگاه پرداختی یافت نشد!"){ alarm in
                    
                    self.present(alarm, animated: true, completion: nil)
                    
                }
                
                self.secondAnimate()
                
                locationManager.stopRangingBeacons(in: region)
                
                return
            
            }
        }

        var payBeacons : [CLBeacon] = [CLBeacon]()
        
        for b in beacons {
            
            let beaconString = String(describing: b.proximityUUID)

            if(GlobalFields.PAY_UUIDS?.contains(beaconString))!{
                
                payBeacons.append(b)
                
            }
            
        }
        
        payBeacons.sort(by: {(b1 , b2) -> Bool in
            var d1 : Double = 0.0
            var d2 : Double = 0.0
            d1 = b1.accuracy
            d2 = b2.accuracy
            if(d1 == -1){
                d1 = 100
            }
            if(d2 == -1){
                d2 = 100
            }
            return d1 > d2
        })
        
        for c in payBeacons{
            
            print(c.accuracy)
            
        }
        
        if(payBeacons.count == 0){
            if(indexPay + 1 <= (GlobalFields.PAY_UUIDS?.count)! - 1){
                indexPay += 1
                let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: GlobalFields.PAY_UUIDS![indexPay].lowercased())! as UUID, identifier: "Bding")
                
                self.locationManager.startRangingBeacons(in: region)
                
                return
            }else{
                Notifys().notif(message: "دستگاه پرداختی یافت نشد!"){ alarm in
                
                    self.present(alarm, animated: true, completion: nil)
                
                    self.secondAnimate()
                
                }
            }
        }else{
            
            popupRequestFor(beacons: payBeacons)
            
        }
        
        locationManager.stopRangingBeacons(in: region)
        
        
    }
    
    
    func popupRequestFor(beacons : [CLBeacon]){
        
        var payBeacons : [CLBeacon] = beacons
        
        let b = payBeacons.popLast()
        
        self.payBeacon = b
        
        callRegister(b: b!, payBeacons: payBeacons)
        
    }
    
    func callRegister(b : CLBeacon , payBeacons : [CLBeacon]){
        
        var beaconCode : String = ""
        
        beaconCode.append(String(describing: (b.proximityUUID)).lowercased())
        
        beaconCode.append("-")
        
        beaconCode.append(String(describing: (b.major)).lowercased())
        
        beaconCode.append("-")
        
        beaconCode.append(String(describing: (b.minor)).lowercased())
        
        request(URLs.nPayRegister , method: .post , parameters: NPayRegisterRequestModel.init(BEACON: beaconCode).getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                var obj = NPayRegisterResponseModel.init(json: JSON as! JSON)
                
                print("JSON ----------Payment Register----------->>>> " ,JSON)
                if(obj?.code == "200"){
                    
                    self.checkPS = true
                    self.usedTimer()
                    
                }else if(obj?.code == "5000"){
                    
                    var payUrlString : String = ""
                    
                    payUrlString.append(URLs.payTitle)
                    
                    payUrlString.append(String(describing: (b.proximityUUID)).lowercased())
                    
                    payUrlString.append("-")
                    
                    payUrlString.append(String(describing: (b.major)).lowercased())
                    
                    payUrlString.append("-")
                    
                    payUrlString.append(String(describing: (b.minor)).lowercased())
                    
                    let manager = SessionManager.default2
                    print(payUrlString)
                    manager.request( payUrlString , method: .get , encoding: JSONEncoding.default).responseJSON { response in
                        print()
                        
                        switch (response.result) {
                        case .failure(let _):
                            
                            self.secondAnimate()
                            
                            return
                            
                        default: break
                            
                        }
                        
                        if let JSON = response.result.value {
                            
                            print("JSON ----------Register----------->>>> " ,JSON)
                            
                            
                            if(PayTitleResponseModel.init(json: JSON as! JSON)?.code == "5005"){
                                GlobalFields().goErrorPage(viewController: self)
                            }
                            
                            if( PayTitleResponseModel.init(json: JSON as! JSON)?.code == "200"){
                                
                                self.secondAnimate()
                                
                                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                                    
                                    self.showPayPopup(payTitle: (PayTitleResponseModel.init(json: JSON as! JSON)?.result?.title)!)
                                    
                                    self.payBeacon = b
                                    
                                },completion : nil)
                                
                                
                            }else{
                                
                                if(payBeacons.count == 0){
                                    
                                    if(self.indexPay + 1 <= (GlobalFields.PAY_UUIDS?.count)! - 1){
                                        self.indexPay += 1
                                        let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: GlobalFields.PAY_UUIDS![self.indexPay].lowercased())! as UUID, identifier: "Bding")
                                        
                                        self.locationManager.startRangingBeacons(in: region)
                                        
                                        return
                                    }else{
                                        Notifys().notif(message: "دستگاه پرداختی یافت نشد!"){ alarm in
                                            
                                            self.present(alarm, animated: true, completion: nil)
                                            
                                            self.secondAnimate()
                                            
                                        }
                                    }
                                }else{
                                    
                                    self.popupRequestFor(beacons: payBeacons)
                                    
                                }
                                
                            }
                            
                            
                        }
                        
                    }
                }else if(obj?.code == "5001"){
                    
                    self.checkPS = true
                    self.usedTimer()
                    
                }
                
            }
            
        }
        
    }
    
    
    
    func usedTimer()  {
        timer = Timer.scheduledTimer(timeInterval: 5,
                             target: self,
                             selector: #selector(self.run(_:)),
                             userInfo: nil,
                             repeats: true)
    }
    
    func run(_ timer: AnyObject) {
        
        if(checkPS){
            
            checkPayStatus()
            
        }
        
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        checkPS = false
    }
    
    func checkPayStatus(){
        print(CPayStatusRequestModel.init(TYPE: "user").getParams())
        request(URLs.cPayStatus , method: .post , parameters: CPayStatusRequestModel.init(TYPE: "user").getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------Pay Status----------->>>> " , JSON)
                
                let obj : CPayStatusResponseModel = CPayStatusResponseModel.init(json: JSON as! JSON)!
                
                if ( obj.code == "200"){
                    
                    if(obj.data != nil){
                        
                        if((obj.data![0].status_pay) == "success"){
                            self.stopTimer()
                            self.secondAnimate()
                            //show popup
                            print(obj.data![0].price)
                            self.showCashPopup(title: obj.data![0].pay_cash_title!, price: obj.data![0].price!)
                            
                        }else if((obj.data![0].status_pay) == "wait"){
                            
                        }else if((obj.data![0].status_pay) == "failed"){
                            self.stopTimer()
                            self.secondAnimate()
                            //show notify
                            Notifys().notif(message: "خطای پرداخت"){ alarm in
                                
                                self.present(alarm, animated: true, completion: nil)
                                
                            }
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    
    // MARK: - CollectionDelegateMethodes
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.coupons?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "CouponPopupViewController"))! as! CouponPopupViewController
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.addChildViewController(vc)
            
            vc.view.frame = CGRect(x:0,y: 0,width: self.view.frame.size.width, height: self.view.frame.size.height)
            
            vc.view.tag = 123
            
            self.view.addSubview(vc.view)
            
            vc.didMove(toParentViewController: self)
            
            vc.setup(myCoupon: nil, coupon: (self.coupons?[indexPath.item])! , isMyCoupon: false)
            
            vc.view.alpha = 1
            
            self.view.alpha = 1
            
            
            
        },completion : nil)
        
        
        self.lastCoupons.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell2", for: indexPath as IndexPath) as! LastCouponCollectionViewCell
        
        if(couponImages!.count > indexPath.item && couponImages![indexPath.item] != nil){
            
            cell.image.image = couponImages?[indexPath.item]
            
            cell.image.contentMode = UIViewContentMode.scaleAspectFill
            
        }else{
            LoadPicture().proLoad(view: cell.image,picType: "coupon" , picModel: (coupons?[indexPath.item].url_pic)!){ resImage in
                
                cell.image.image = resImage
                
                cell.image.contentMode = UIViewContentMode.scaleAspectFill
                
                self.couponImages![indexPath.item] = resImage
                
            }
        }
        
        
        return cell
        
    }
    
    
    
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "toPayHistoryViewController"){
            
            let nextVc = segue.destination as! PayHistoryViewController
            
            self.requestForPayHistory(nextVc: nextVc)
            
            
        }else if(segue.identifier == "toTakeCouponViewController"){
            
            let nextVc = segue.destination as! TakeCouponViewController
            
            self.requestForGetCoupon(nextVc: nextVc)
            
        }
        
    }
   
    
    // MARK: GlobalFunctions
    
    func requestForPayHistory(nextVc : PayHistoryViewController){
        
        let manager = SessionManager.default2
        
        manager.request(URLs.paylistHistory , method: .post , parameters: PayListRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            ///////////////////////////
            ///////////////////////////
            ///////////////////////////
            
            switch (response.result) {
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    //HANDLE TIMEOUT HERE
                    
                    nextVc.loading.stopAnimating()
                    
                    nextVc.loading.alpha = 0
                    
                    nextVc.table.alpha = 0
                    
                    nextVc.lowInternetView.alpha = 1
                    
                    return
                    
                }
                break
                
            default: break
                
            }
            
            ///////////////////////////
            ///////////////////////////
            ///////////////////////////
            
            if let JSON = response.result.value {
                
                print("JSON ----------MY HISTORY----------->>>> ")
                //create my coupon response model
                
                if(PayListResponseModel.init(json: JSON as! JSON)?.code == "5005"){
                    GlobalFields().goErrorPage(viewController: self)
                }
                
                if(PayListResponseModel.init(json: JSON as! JSON)?.code == "200"){
                    
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        
                        if(PayListResponseModel.init(json: JSON as! JSON)?.data == nil){
                            
                            // data nadarim
                            
                        }else{
                            nextVc.payHistory = (PayListResponseModel.init(json: JSON as! JSON)?.data)!
                            
                            nextVc.table.reloadData()
                            
                        }
                        
                        if(nextVc.payHistory.count == 0){
                            
                            nextVc.table.alpha = 0
                            
                        }else{
                            
                            nextVc.table.alpha = 1
                            
                        }
                        
                    }, completion: nil)
                    
                    nextVc.loading.stopAnimating()
                    
                    nextVc.loading.alpha = 0
                    
                }
                
                
                print(JSON)
                
            }
            
        }
        
        
    }
    
    
    func requestForGetCoupon(nextVc : TakeCouponViewController){
        
        let manager = SessionManager.default2
        
        manager.request(URLs.getCoupons , method: .post , parameters: GetCouponRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            ///////////////////////////
            ///////////////////////////
            ///////////////////////////
            
            switch (response.result) {
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    //HANDLE TIMEOUT HERE
                    
                    nextVc.loading.stopAnimating()
                    
                    nextVc.table.alpha = 0
                    
                    nextVc.lowInternetView.alpha = 1
                    
                    return
                    
                }
                break
                
            default: break
                
            }
            
            ///////////////////////////
            ///////////////////////////
            ///////////////////////////
            
            if let JSON = response.result.value {
                
                print(GetCouponRequestModel.init().getParams())
                
                print("JSON ----------GET COUPON----------->>>> " ,JSON)
                //create my coupon response model
                
                if(CouponListResponseModel.init(json: JSON as! JSON)?.code == "5005"){
                    GlobalFields().goErrorPage(viewController: self)
                }
                
                if(CouponListResponseModel.init(json: JSON as! JSON)?.code == "200"){
                    
                    nextVc.coupons = CouponListResponseModel.init(json: JSON as! JSON)?.data
                    
                    nextVc.loading.stopAnimating()
                    
                    nextVc.table.reloadData()
                    
                    if(nextVc.coupons == nil || nextVc.coupons?.count == 0){
                        
                        nextVc.table.alpha = 0
                        
                    }else{
                        
                        nextVc.table.alpha = 1
                        
                    }
                    
                    
                }
                
                print(JSON)
                
            }
            
        }
        
        
    }
    
    
    func deletSubView(){
        
        if let viewWithTag = self.view.viewWithTag(123) {
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                viewWithTag.alpha = 0
                
                viewWithTag.frame.size.width = 0
                
                viewWithTag.frame.size.height = 0
                
                viewWithTag.frame.origin.x = self.view.frame.width / 2
                
                viewWithTag.frame.origin.y = self.view.frame.height / 2
                
            }){ completion in
                
                viewWithTag.removeFromSuperview()
                
            }
            
            
            
        }
        
    }
    
    func requestForGetCoupon(){
        
        let nextVc : PayViewController = self
        
//        nextVc.loading.startAnimating()
//
//        nextVc.table.alpha = 1
//
//        nextVc.lowInternetView.alpha = 0
        
        let manager = SessionManager.default2
        
        manager.request(URLs.lastCoupons , method: .post , parameters: LastCouponRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            ///////////////////////////
            ///////////////////////////
            ///////////////////////////
            
            switch (response.result) {
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    //HANDLE TIMEOUT HERE
                    
                    self.requestForGetCoupon()
                    
                    return
                    
                }
                break
                
            default: break
                
            }
            
            ///////////////////////////
            ///////////////////////////
            ///////////////////////////
            
            if let JSON = response.result.value {
                
                print(GetCouponRequestModel.init().getParams())
                
                print("JSON ----------GET COUPON----------->>>> " ,JSON)
                //create my coupon response model
                
                if(CouponListResponseModel.init(json: JSON as! JSON)?.code == "5005"){
                    GlobalFields().goErrorPage(viewController: self)
                }
                
                if(CouponListResponseModel.init(json: JSON as! JSON)?.code == "200"){
                    
                    nextVc.coupons = CouponListResponseModel.init(json: JSON as! JSON)?.data
                    
//                    nextVc.loading.stopAnimating()
                    
                    nextVc.lastCoupons.reloadData()
                    
                    if(nextVc.coupons == nil || nextVc.coupons?.count == 0){
                        
                        nextVc.lastCoupons.alpha = 0
                        
                    }else{
                    
                        let i : IndexPath = IndexPath.init(item: (nextVc.coupons?.count)! - 1, section: 0)
                        
                        nextVc.lastCoupons.scrollToItem(at: i , at: .right, animated: false)
                        
                        for _ in nextVc.coupons! {
                            
                            self.couponImages?.append(nil)
                            
                        }
                        
                        UIView.animate(withDuration: 0.2, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
                            
                            nextVc.lastCoupons.alpha = 1
                            
                        },completion: nil)
                        
                    
                    }
                    
                    
                }
                
                print(JSON)
                
            }
            
        }
        
        
    }
    
    
    @IBAction func tapView(_ sender: Any) {
        
        self.view.endEditing(true)
        
    }
    
    
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        myBTManager = peripheral
    }
    
    
    
    

}
