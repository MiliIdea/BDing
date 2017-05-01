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
        
        if(couponsPrePics.count < indexPath.row + 1){
                
                if(data.url_pic?.url != nil){
                    
                    var im: UIImage? = loadImage(picModel: data.url_pic!)
                    
                    if(im != nil){
                        
                        im = im?.imageWithColor(tintColor: UIColor.white)
                        
                        couponsPrePics[indexPath.row] = im
                        
                        cell.couponImage.image = im
                        
                    }else{
                        
                        request("http://"+(data.url_pic?.url)! ,method: .post ,parameters: BeaconPicRequestModel(CODE: data.url_pic?.code, FILE_TYPE: data.url_pic?.file_type).getParams(), encoding : JSONEncoding.default).responseJSON { response in
                            
                            if let image = response.result.value {
                                
                                let obj = PicDataModel.init(json: image as! JSON)
                                
                                let imageData = NSData(base64Encoded: (obj?.data!)!, options: .ignoreUnknownCharacters)
                                
                                var coding: String = (data.url_pic?.url)!
                                
                                coding.append((data.url_pic?.code)!)
                                
                                SaveAndLoadModel().save(entityName: "IMAGE", datas: ["imageCode": coding.md5() , "imageData": obj?.data!])
                                
                                self.cache.setObject(imageData!, forKey: coding.md5() as AnyObject)
                                
                                var pic = UIImage(data: imageData as! Data)
                                
                                pic = pic?.imageWithColor(tintColor: UIColor.white)
                                
                                self.couponsPrePics.insert(pic, at: indexPath.row)
                                
                                cell.couponImage.image = pic
                                
                                cell.couponImage.contentMode = UIViewContentMode.scaleAspectFit
                                
                            }
                        }
                        
                    }
                    
                }
            
        }else{
            
            cell.couponImage.image = couponsPrePics[indexPath.row]
            
            cell.couponImage.contentMode = UIViewContentMode.scaleAspectFit
            
        }
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    @IBAction func backButton(_ sender: Any) {
        
        let vc = self.parent as! ProfilePageViewController
        
        vc.deletSubView()
        
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
