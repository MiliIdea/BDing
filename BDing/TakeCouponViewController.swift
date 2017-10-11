//
//  TakeCouponViewController.swift
//  BDing
//
//  Created by MILAD on 4/26/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit

class TakeCouponViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var lowInternetView: UIView!
    
    var coupons: [CouponListData]? = [CouponListData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loading.hidesWhenStopped = true;
        loading.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray;
        loading.startAnimating()
        
        self.table.register(UINib(nibName: "CouponTableViewCell", bundle: nil), forCellReuseIdentifier: "couponCell")
        
        table.dataSource = self
        table.delegate = self
        

        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "BuyCoupons")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(coupons == nil){
            
            return 0
            
        }
        return (coupons?.count)!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "couponCell", for: indexPath) as! CouponTableViewCell
        
        cell.dingLabel.text = coupons?[indexPath.row].coin
        
        LoadPicture().proLoad(view: cell.couponImage,picType: "coupon" , picModel: (coupons?[indexPath.row].url_pic)!){ resImage in
            
            cell.couponImage.image = resImage
            
            cell.couponImage.contentMode = UIViewContentMode.scaleAspectFill
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.width * 426 / 1418
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loading.stopAnimating()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "CouponPopupViewController"))! as! CouponPopupViewController
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.addChildViewController(vc)
            
           vc.view.frame = CGRect(x:0,y: 0,width: self.view.frame.size.width, height: self.view.frame.size.height)
            
            vc.view.tag = 123
            
            self.view.addSubview(vc.view)
            
            vc.didMove(toParentViewController: self)
            
            vc.setup(myCoupon: nil, coupon: (self.coupons?[indexPath.row])! , isMyCoupon: false)
            
            vc.view.alpha = 1
            
            self.view.alpha = 1

            
            
        },completion : nil)
        

        self.table.deselectRow(at: indexPath, animated: true)
        
        
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
    
    
    
    @IBAction func backButton(_ sender: Any) {
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func lowInternetAction(_ sender: Any) {
        
        requestForGetCoupon()
        
    }
    
    func requestForGetCoupon(){
        
        let nextVc : TakeCouponViewController = self
        
        nextVc.loading.startAnimating()
        
        nextVc.table.alpha = 1
        
        nextVc.lowInternetView.alpha = 0
        
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

    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if(segue.identifier == "toCouponPopupViewController"){
//            
//            let nextVc = segue.destination as! CouponPopupViewController
//            
////            nextVc.setup(myCoupon: nil, coupon: (self.coupons?[indexPath.row])! , isMyCoupon: false)
//
//            print("yeaaaaa")
//            
//        }
//        
//    }
    
    
    

}
