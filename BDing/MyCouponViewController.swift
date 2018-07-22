//
//  MyCouponViewController.swift
//  BDing
//
//  Created by MILAD on 4/24/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit

class MyCouponViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var navigation: UINavigationBar!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var coupons : [MyCouponListData]? = [MyCouponListData]()
    
    var couponsPrePics : [UIImage?]? = nil
    
    var cache: NSCache<AnyObject, AnyObject> = NSCache()
    
    @IBOutlet weak var lowInternetView: UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loading.hidesWhenStopped = true;
        loading.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray;
        loading.startAnimating()

        self.automaticallyAdjustsScrollViewInsets = false
        table.contentInset = UIEdgeInsets.zero
        
        self.table.register(UINib(nibName: "MyCouponTableViewCell", bundle: nil), forCellReuseIdentifier: "myCouponCell")
        
        table.dataSource = self
        table.delegate = self
        
        self.cache = NSCache()
        
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
        return coupons!.count
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loading.stopAnimating()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCouponCell", for: indexPath) as! MyCouponTableViewCell

        let data : MyCouponListData = (coupons?[indexPath.row])!
        
        cell.titleLabel.text = data.title
        
        cell.detailLabel.text = data.coupon_code
        
        cell.couponImage.superview?.frame.size.width = (cell.couponImage.superview?.frame.height)!

        cell.tikView.frame.size.width = (cell.tikView.frame.height)
        
        if(data.count_used == "0"){
            
            cell.tikView.alpha = 0
            
        }else{
            
            cell.titleLabel.textColor = UIColor(hexString: "2196f3")
            
        }
        
        if((couponsPrePics?.count)! < indexPath.row + 1 || couponsPrePics?[indexPath.row] == nil){
            
            LoadPicture().proLoad(view : cell.couponImage,picType: "coupon", picModel: data.url_pic2!){ resImage in
             
                if((self.couponsPrePics?.count)! < (self.coupons?.count)!){
                    
                    for _ in self.coupons!{
                        
                        self.couponsPrePics?.append(nil)
                        
                    }
                    
                }
                
                self.couponsPrePics?[indexPath.row] = resImage
                
                cell.couponImage.image = resImage
                
                cell.couponImage.contentMode = UIViewContentMode.scaleAspectFit
                
            }
            
                    
        } else {
            
            cell.couponImage.image = couponsPrePics?[indexPath.row]
            
            cell.couponImage.contentMode = UIViewContentMode.scaleAspectFit
            
        }
        

        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(self.coupons?[indexPath.row].count_used != "0"){
            return
        }
        
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "CouponPopupViewController"))! as! CouponPopupViewController
        
        self.addChildViewController(vc)
        
            
            vc.view.frame = CGRect(x:0,y: 0,width: self.view.frame.size.width, height: self.view.frame.size.height)
            
            vc.view.tag = 1234
            
//            self.view.addSubview(vc.view)
            
        UIView.transition(with: self.view, duration: 0.4 , options: UIViewAnimationOptions.curveEaseIn ,animations: {self.view.addSubview(vc.view)}, completion: nil)
            
            vc.didMove(toParentViewController: self)
            
            vc.setup(myCoupon: (self.coupons?[indexPath.row])!, coupon: nil , isMyCoupon: true)
            
            vc.view.alpha = 1
            
            self.view.alpha = 1
            
//        }, completion: nil)
        
        
        self.table.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.width * 70 / 320
    }

    @IBAction func backButton(_ sender: Any) {
        
         _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    func deletSubView(){
        
        if let viewWithTag = self.view.viewWithTag(1234) {
            
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
    
    
    
    @IBAction func lowInternetAction(_ sender: Any) {
        requestForMyCoupon()
    }
    
    func requestForMyCoupon(){
        
        let nextVc : MyCouponViewController = self
        
        nextVc.loading.startAnimating()
        
        nextVc.table.alpha = 1
        
        nextVc.lowInternetView.alpha = 0
        
        print(MyCouponRequestModel.init().getParams())
        
        let manager = SessionManager.default2
        
        manager.request(URLs.getMyCoupon , method: .post , parameters: MyCouponRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
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
                
                print("JSON ----------MY COUPON----------->>>> " ,JSON)
                //create my coupon response model
                if(MyCouponListResponseModel.init(json: JSON as! JSON)?.code == "5005"){
                    GlobalFields().goErrorPage(viewController: self)
                }
                
                if( MyCouponListResponseModel.init(json: JSON as! JSON)?.code == "200"){
                    
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        
                        if(MyCouponListResponseModel.init(json: JSON as! JSON)?.data != nil){
                            
                            nextVc.coupons = MyCouponListResponseModel.init(json: JSON as! JSON)?.data
                            
//                            nextVc.couponsPrePics = [UIImage].init(reserveCapacity: (MyCouponListResponseModel.init(json: JSON as! JSON)?.data?.count)!)

                            nextVc.couponsPrePics = [UIImage].init()
                            
                            
                            nextVc.loading.stopAnimating()
                            
                            if(nextVc.coupons == nil || nextVc.coupons?.count == 0){
                                
                                nextVc.table.alpha = 0
                                
                            }else{
                                
                                nextVc.table.alpha = 1
                                
                            }
                            
                        }
                        
                        nextVc.table.reloadData()
                        
                    }, completion: nil)
                    
                    
                }
                
                
                print(JSON)
                
            }
            
        }
        
        
    }

}
