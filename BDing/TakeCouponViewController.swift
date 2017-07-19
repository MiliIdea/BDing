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
        
        cell.titleLabel.text = coupons?[indexPath.row].title
        
        cell.detailLabel.text = coupons?[indexPath.row].coin
        
        if(cell.detailLabel.text == "" || cell.detailLabel.text == nil){
            
            cell.detailLabel.text = "0"
            
        }
        
        cell.discountLabel.text = coupons?[indexPath.row].discount
        
        LoadPicture().proLoad(view: cell.couponImage,picType: "coupon" , picModel: (coupons?[indexPath.row].url_pic)!){ resImage in
            
            cell.couponImage.image = resImage
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.width * 7 / 32
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
