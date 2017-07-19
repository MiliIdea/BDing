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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loading.hidesWhenStopped = true;
        loading.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray;
        loading.startAnimating()

        self.automaticallyAdjustsScrollViewInsets = false
        table.contentInset = UIEdgeInsets.zero
        
        self.table.register(UINib(nibName: "CouponTableViewCell", bundle: nil), forCellReuseIdentifier: "couponCell")
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "couponCell", for: indexPath) as! CouponTableViewCell

        let data : MyCouponListData = (coupons?[indexPath.row])!
        
        cell.titleLabel.text = data.title
        
        cell.discountLabel.text = data.discount
        
        cell.detailLabel.text = data.coupon_code
        
        cell.dingView.alpha = 0
        
        cell.detailLabel.frame.origin.x = cell.dingView.frame.origin.x + cell.dingView.frame.width - cell.detailLabel.frame.width
        
        if((couponsPrePics?.count)! < indexPath.row + 1 || couponsPrePics?[indexPath.row] == nil){
            
            LoadPicture().proLoad(view : cell.couponImage,picType: "coupon", picModel: data.url_pic!){ resImage in
             
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
        return self.view.frame.width * 7 / 32
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
    
    

}
