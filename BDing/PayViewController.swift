//
//  PayViewController.swift
//  BDing
//
//  Created by MILAD on 10/8/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit

class PayViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var myDings: UILabel!
    
    @IBOutlet weak var myDingsIcon: UIImageView!
    
    @IBOutlet weak var payHistoryButton: DCBorderedButton!
    
    @IBOutlet weak var shopListButton: DCBorderedButton!
    
    @IBOutlet weak var lastCoupons: UICollectionView!
    
    var coupons: [CouponListData]? = [CouponListData]()
    
    // MARK: - PopupFields
    
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var popupView: DCBorderedView!
    
    @IBOutlet weak var popupTitle: UILabel!
    
    @IBOutlet weak var popupMyDings: UILabel!
    
    @IBOutlet weak var onlineSwitch: UISwitch!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var canselPopup: DCBorderedButton!
    
    @IBOutlet weak var payButton: DCBorderedButton!
    
    @IBOutlet weak var inputPriceTextField: UITextField!
    
    @IBOutlet weak var attentionIcon: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lastCoupons.register(UINib(nibName: "LastCouponCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionViewCell2")
        
        lastCoupons.dataSource = self
        lastCoupons.delegate = self
        
        requestForGetCoupon()
        
        self.myDings.text = GlobalFields.PROFILEDATA?.all_coin
        
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Actions
    
    @IBAction func callPayPopUp(_ sender: Any) {
    }
    
    @IBAction func payHistory(_ sender: Any) {
        
    }
    
    @IBAction func shopList(_ sender: Any) {
        
        UIApplication.shared.openURL(NSURL(string: "http://bding.ir/fa/shoplist") as! URL)
        
    }
    
    // MARK: - PopupActions
    
    @IBAction func switchOnlinePay(_ sender: Any) {
    }
    
    @IBAction func closePopup(_ sender: Any) {
    }
    
    @IBAction func doPay(_ sender: Any) {
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
        
        LoadPicture().proLoad(view: cell.image,picType: "coupon" , picModel: (coupons?[indexPath.item].url_pic)!){ resImage in
            
            cell.image.image = resImage
            
            cell.image.contentMode = UIViewContentMode.scaleAspectFill
            
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
        
        manager.request(URLs.getCoupons , method: .post , parameters: GetCouponRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            ///////////////////////////
            ///////////////////////////
            ///////////////////////////
            
            switch (response.result) {
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    //HANDLE TIMEOUT HERE
                    
//                    nextVc.loading.stopAnimating()
//
//                    nextVc.table.alpha = 0
//
//                    nextVc.lowInternetView.alpha = 1
                    
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
                
                if(CouponListResponseModel.init(json: JSON as! JSON)?.code == "200"){
                    
                    nextVc.coupons = CouponListResponseModel.init(json: JSON as! JSON)?.data
                    
//                    nextVc.loading.stopAnimating()
                    
                    nextVc.lastCoupons.reloadData()
                    
                    if(nextVc.coupons == nil || nextVc.coupons?.count == 0){
                        
                        nextVc.lastCoupons.alpha = 0
                        
                    }else{
                        
                        nextVc.lastCoupons.alpha = 1
                        
                    }
                    
                    
                }
                
                print(JSON)
                
            }
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    

}
