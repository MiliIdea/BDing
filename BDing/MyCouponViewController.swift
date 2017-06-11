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
    
    var coupons : [MyCouponListData]? = [MyCouponListData]()
    
    var couponsPrePics : [UIImage?] = [UIImage]()
    
    var cache: NSCache<AnyObject, AnyObject> = NSCache()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.table.register(UINib(nibName: "CouponTableViewCell", bundle: nil), forCellReuseIdentifier: "couponCell")
        
        table.dataSource = self
        table.delegate = self
        
        self.cache = NSCache()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "couponCell", for: indexPath) as! CouponTableViewCell

        let data : MyCouponListData = (coupons?[indexPath.row])!
        
        cell.titleLabel.text = data.title
        
        cell.discountLabel.text = data.discount
        
        cell.detailLabel.text = data.coupon_code
        
        if(couponsPrePics.count < indexPath.row + 1 || couponsPrePics[indexPath.row] == nil){
            
            LoadPicture().proLoad(view : cell.couponImage,picType: "coupon", picModel: data.url_pic!){ resImage in
             
                if(self.couponsPrePics.count < indexPath.row){
                    
                    self.couponsPrePics.append(nil)
                    
                }
                
                self.couponsPrePics.insert(resImage, at: indexPath.row)
                
                cell.couponImage.image = resImage
                
                cell.couponImage.contentMode = UIViewContentMode.scaleAspectFit
                
            }
            
                    
        } else {
            
            cell.couponImage.image = couponsPrePics[indexPath.row]
            
            cell.couponImage.contentMode = UIViewContentMode.scaleAspectFit
            
        }
        

        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "CouponPopupViewController"))! as! CouponPopupViewController
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.addChildViewController(vc)
            
            vc.view.frame = CGRect(x:0,y: 0,width: self.view.frame.size.width, height: self.view.frame.size.height)
            
            vc.view.tag = 1234
            
            self.view.addSubview(vc.view)
            
            vc.didMove(toParentViewController: self)
            
            vc.setup(myCoupon: (self.coupons?[indexPath.row])!, coupon: nil , isMyCoupon: true)
            
            vc.view.alpha = 1
            
            self.view.alpha = 1
            
        }, completion: nil)
        
        
        self.table.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.width * 7 / 32
    }

    @IBAction func backButton(_ sender: Any) {
        
         _ = navigationController?.popViewController(animated: true)
        
    }
   
//    func loadImage(picModel: PicModel) -> UIImage?{
//        
//        var tempCode = picModel.url
//        
//        tempCode?.append((picModel.code)!)
//        
//        let result: String? = isThereThisPicInDB(code: (tempCode?.md5())!)
//        
//        if(result != nil){
//            
//            if self.cache.object(forKey: tempCode?.md5() as AnyObject) != nil {
//                
//                return UIImage(data: self.cache.object(forKey: tempCode?.md5() as AnyObject) as! Data)!
//                
//            }else{
//                
//                let imageData = NSData(base64Encoded: result!, options: .ignoreUnknownCharacters)
//                
//                self.cache.setObject(imageData!, forKey: tempCode?.md5() as AnyObject)
//                
//                return UIImage(data: imageData as! Data)!
//                
//            }
//            
//        }else{
//            
//            return nil
//            
//        }
//        
//    }
//    
//    
//    func isThereThisPicInDB (code: String) -> String?{
//        
//        for i in SaveAndLoadModel().load(entity: "IMAGE")!{
//            
//            if(i.value(forKey: "imageCode") as! String == code){
//                
//                return i.value(forKey: "imageData") as! String
//                
//            }
//            
//        }
//        
//        return nil
//        
//    }

    
    
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
