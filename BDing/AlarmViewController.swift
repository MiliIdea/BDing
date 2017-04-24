//
//  AlarmViewController.swift
//  BDing
//
//  Created by MILAD on 3/4/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{
    
    @IBOutlet weak var rightTable: UITableView!
    
    @IBOutlet weak var leftTable: UITableView!
    
    @IBOutlet weak var rightWidth: NSLayoutConstraint!
    
    @IBOutlet weak var leftWidth: NSLayoutConstraint!
  
    @IBOutlet var container: UIView!
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    ///////////////////////////////
    
    var cache: NSCache<AnyObject, AnyObject> = NSCache()
    
    
    
    ///////////////////////////////
    static var mode = true
    
    var customerHomeTableCells = [CustomerHomeTableCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rightTable.dataSource = self
        rightTable.delegate = self
//        rightTable.register(UITableViewCell.self, forCellReuseIdentifier: "rightCell")
        
        leftTable.dataSource = self
        leftTable.delegate = self
//        leftTable.register(UITableViewCell.self, forCellReuseIdentifier: "leftCell")
        
        loadHomeTable()
        
        if(AlarmViewController.mode){
            
            self.leftWidth.constant = -(self.rightTable.superview?.frame.width)!/2+4
            self.rightTable.frame.size.width = (self.rightTable.superview?.frame.width)!
            self.rightWidth.constant = (self.rightTable.superview?.frame.width)!-4
            
        }else{
            
            self.leftWidth.constant = -16
            self.rightTable.frame.size.width = (self.rightTable.superview?.frame.width)! / 2
            self.rightWidth.constant = (self.rightTable.superview?.frame.width)! / 2
            
        }
        
        self.cache = NSCache()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func playResizeTables(_ sender: Any) {
        
        AlarmViewController.mode = !AlarmViewController.mode
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            if !AlarmViewController.mode {
                for c in 1...self.rightTable.numberOfRows(inSection: 0) {
                    
                    if ((c-1) % 2 != 0) {
                        
                        (self.rightTable.cellForRow(at: IndexPath(row: c-1, section: 0)) as? IndexHomeTableViewCell)?.alpha = 0
                        
                    }
                    
                    (self.leftTable.cellForRow(at: IndexPath(row: c-1, section: 0)) as? IndexHomeTableViewCell)?.setLast()
                    
                }
                
                self.view.layoutIfNeeded()
                
            }else {
                for c in 1...self.rightTable.numberOfRows(inSection: 0) {
                    if ((c-1) % 2 != 0) {
                        
                        (self.rightTable.cellForRow(at: IndexPath(row: c-1, section: 0)) as? IndexHomeTableViewCell)?.alpha = 1
                        
                    }
                }
            }
            
            
        }, completion: nil)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            if AlarmViewController.mode {
                
                //resizing table single
                self.leftWidth.constant = -(self.rightTable.superview?.frame.width)!/2+4
                self.rightTable.frame.size.width = (self.rightTable.superview?.frame.width)!
                self.rightWidth.constant = (self.rightTable.superview?.frame.width)!-4
                ////////=========///////

                
                for c in 1...self.rightTable.numberOfRows(inSection: 0) {
                    
                    (self.rightTable.cellForRow(at: IndexPath(row: c-1, section: 0)) as? IndexHomeTableViewCell)?.setFirst()
                    
                }

                self.view.layoutIfNeeded()
                
            }else {
                
                //resizing table double
                self.leftWidth.constant = -16
                self.rightTable.frame.size.width = (self.rightTable.superview?.frame.width)! / 2
                self.rightWidth.constant = (self.rightTable.superview?.frame.width)! / 2

                for c in 1...self.rightTable.numberOfRows(inSection: 0) {
                    
                    (self.rightTable.cellForRow(at: IndexPath(row: c-1, section: 0)) as? IndexHomeTableViewCell)?.setLast()
                    (self.leftTable.cellForRow(at: IndexPath(row: c-1, section: 0)) as? IndexHomeTableViewCell)?.setLast()
                    
                }
                
                self.view.layoutIfNeeded()
     
            }
            
        }, completion: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == rightTable {
            return customerHomeTableCells.count
        }else {
            return customerHomeTableCells.count / 2
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == rightTable {
            
            let cell = self.rightTable.dequeueReusableCell(withIdentifier: "rightCell" , for: indexPath) as! IndexHomeTableViewCell
            
            let tableCell = customerHomeTableCells[indexPath.row]
            
//            cell.backgroundColor = UIColor.red
            //////////
            cell.customerName.text = tableCell.customerName
            cell.customerCampaignTitle.text = tableCell.customerCampaignTitle
            cell.customerDistanceToMe.text = tableCell.customerDistanceToMe
//            cell.customerThumbnail.image = UIImage(named:"profile_pic")!
            
            if(tableCell.preCustomerImage != nil){
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    cell.customerThumbnail.image = tableCell.preCustomerImage
                    
                })
                
            }else{
                if(tableCell.customerImage?.url != nil){
                    
                    var tempCode = tableCell.customerImage?.url
                    
                    tempCode?.append((tableCell.customerImage?.code)!)
                    
                    let result: String? = isThereThisPicInDB(code: (tempCode?.md5())!)
                    
                    if(result == nil){
                        //if its not in db load this
                        
                        //                    if cell.customerThumbnail.image == UIImage(named:"profile_pic")! {
                        request("http://"+(tableCell.customerImage?.url)! ,method: .post ,parameters: BeaconPicRequestModel(CODE: tableCell.customerImage?.code, FILE_TYPE: tableCell.customerImage?.file_type).getParams(), encoding : JSONEncoding.default).responseJSON { response in
                            
                            if let image = response.result.value {
                                
                                let obj = PicDataModel.init(json: image as! JSON)
                                
                                var coding: String = (tableCell.customerImage?.url)!
                                
                                coding.append((tableCell.customerImage?.code)!)
                                
                                SaveAndLoadModel().save(entityName: "IMAGE", datas: ["imageCode": coding.md5() , "imageData": obj?.data!])
                                
                                let imageData = NSData(base64Encoded: (obj?.data!)!, options: .ignoreUnknownCharacters)
                                
                                self.cache.setObject(imageData!, forKey: coding.md5() as AnyObject)
                                
                                cell.customerThumbnail.image = UIImage(data: imageData as! Data)
                                
                                self.customerHomeTableCells[indexPath.row].preCustomerImage = UIImage(data: imageData as! Data)
                                
                            }
                            
                        }
                        //                    }
                        
                    }else{
                        //else load from db
                        if self.cache.object(forKey: tempCode?.md5() as AnyObject) != nil{
                            
                            cell.customerThumbnail.image = UIImage(data: self.cache.object(forKey: tempCode?.md5() as AnyObject) as! Data)
                            
                        }else{
                            DispatchQueue.main.async(execute: { () -> Void in
                                
                                let imageData = NSData(base64Encoded: result!, options: .ignoreUnknownCharacters)
                                
                                self.cache.setObject(imageData!, forKey: tempCode?.md5() as AnyObject)
                                
                                cell.customerThumbnail.image = UIImage(data: imageData as! Data)
                                
                            })
                        }
                        
                    }
                    
                }
            }
            
            
            
            
            cell.customerCampaignCoin.text = tableCell.customerCoinValue
            cell.customerCampaignDiscount.text = tableCell.customerDiscountValue
            cell.customerCategoryThumbnail.image = tableCell.customerCategoryIcon
            cell.coinThumbnail.image = tableCell.customerCoinIcon
            cell.discountThumbnail.image = tableCell.customerDiscountIcon
            //////////
            if(AlarmViewController.mode){
                cell.setFirst()
            }else{
                cell.setLast()
            }
            return cell
            
        }else if tableView == leftTable{
            
            let cell2 = self.leftTable.dequeueReusableCell(withIdentifier: "leftCell" , for: indexPath) as! IndexHomeTableViewCell
            
            let tableCell = customerHomeTableCells[indexPath.row * 2 + 1]
            
//            cell2.backgroundColor = UIColor.blue
            
            ////////////
            cell2.customerName.text = tableCell.customerName
            cell2.customerCampaignTitle.text = tableCell.customerCampaignTitle
            cell2.customerDistanceToMe.text = tableCell.customerDistanceToMe
//            cell2.customerThumbnail.image = UIImage(named:"profile_pic")!
            
            if(tableCell.preCustomerImage != nil){
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    cell2.customerThumbnail.image = tableCell.preCustomerImage
                    
                })
                
            }else{
                
                var tempCode = tableCell.customerImage?.url
                
                tempCode?.append((tableCell.customerImage?.code)!)
                
                let result: String? = isThereThisPicInDB(code: (tempCode?.md5())!)
                
                if(result == nil){
                    
                    //                if cell2.customerThumbnail.image == UIImage(named:"profile_pic")! {
                    request("http://"+(tableCell.customerImage?.url)! ,method: .post ,parameters: BeaconPicRequestModel(CODE: tableCell.customerImage?.code, FILE_TYPE: tableCell.customerImage?.file_type).getParams() , encoding : JSONEncoding.default).responseJSON { response in
                        
                        if let image = response.result.value {
                            let obj = PicDataModel.init(json: image as! JSON)
                            
                            var coding: String = (tableCell.customerImage?.url)!
                            
                            coding.append((tableCell.customerImage?.code)!)
                            
                            SaveAndLoadModel().save(entityName: "IMAGE", datas: ["imageCode": coding.md5() , "imageData": obj?.data!])
                            
                            let imageData = NSData(base64Encoded: (obj?.data!)!, options: .ignoreUnknownCharacters)
                            
                            self.cache.setObject(imageData!, forKey: coding.md5() as AnyObject)
                            
                            cell2.customerThumbnail.image = UIImage(data: imageData as! Data)
                            
                        }
                        
                    }
                    //                }
                    
                }else{
                    
                    if self.cache.object(forKey: tempCode?.md5() as AnyObject) != nil{
                        
                        cell2.customerThumbnail.image = UIImage(data: self.cache.object(forKey: tempCode?.md5() as AnyObject) as! Data)
                        
                    }else{
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            let imageData = NSData(base64Encoded: result!, options: .ignoreUnknownCharacters)
                            
                            self.cache.setObject(imageData!, forKey: tempCode?.md5() as AnyObject)
                            
                            cell2.customerThumbnail.image = UIImage(data: imageData as! Data)
                            
                        })
                    }
                    
                }
                
            }
            
            cell2.customerCampaignCoin.text = tableCell.customerCoinValue
            cell2.customerCampaignDiscount.text = tableCell.customerDiscountValue
            cell2.customerCategoryThumbnail.image = tableCell.customerCategoryIcon
            cell2.coinThumbnail.image = tableCell.customerCoinIcon
            cell2.discountThumbnail.image = tableCell.customerDiscountIcon
            ////////////
            
            cell2.setLast()
            
            return cell2
            
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == rightTable{
            if(AlarmViewController.mode){
                
                return 70
                
            }else{
                
                if(indexPath.row % 2 != 0){
                    
                    return 0
                    
                }
                return 150
            }
            
        }else{
            
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView == rightTable){
            
//            customerHomeTableCells[indexPath.row]
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                let vc = (self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController"))! as! DetailViewController
                
                self.addChildViewController(vc)
                
                vc.view.frame = CGRect(x:0,y: 0,width: self.container.frame.size.width, height: self.container.frame.size.height);
                
                self.container.addSubview(vc.view)
                
                vc.didMove(toParentViewController: self)
                
                vc.setup(data: self.customerHomeTableCells[indexPath.row])
                
                self.navigationBar.alpha = 0
                
                self.rightTable.alpha = 0
                
                self.leftTable.alpha = 0
                
            }, completion: nil)
            
        }else {
            
//            customerHomeTableCells[(indexPath.row * 2) + 1]
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                let vc = (self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController"))! as! DetailViewController
                
                self.addChildViewController(vc)
                
                vc.view.frame = CGRect(x:0,y: 0,width: self.container.frame.size.width, height: self.container.frame.size.height);
                
                self.container.addSubview(vc.view)
                
                vc.didMove(toParentViewController: self)
                
                vc.setup(data: self.customerHomeTableCells[(indexPath.row * 2) + 1])
                
                self.navigationBar.alpha = 0
                
                self.rightTable.alpha = 0
                
                self.leftTable.alpha = 0
                
            }, completion: nil)
            
            
        }
        
        
    }
    
    
    func deletSubView(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "AlarmViewController"))! as UIViewController
            
            self.addChildViewController(vc)
            
            vc.view.frame = CGRect(x:0,y: 0,width: self.container.frame.size.width, height: self.container.frame.size.height);
            
            self.container.addSubview(vc.view)
            
            vc.didMove(toParentViewController: self)
        }, completion: nil)
        
    }

    func loadHomeTable(){
        //create customer Home Table Cell from web service :)
        let image : UIImage = UIImage(named:"mal")!
//        let a1 = CustomerHomeTableCell.init(preCustomerImage: nil,customerImage: nil, customerCampaignTitle: "فروش فوق العاده", customerName: "آدیداس", customerCategoryIcon: image, customerDistanceToMe: "۱۲۵", customerCoinValue: "۱۲", customerCoinIcon: image, customerDiscountValue: "۱۰", customerDiscountIcon: image, tell: "09121233454" ,address: "unjaa" , text: "asdadsfsdgsdg" ,workTime: "12-2 3-5" , website: "www.asd.com" , customerBigImages: nil)
//        
//        customerHomeTableCells.append(a1)
        
        for obj in GlobalFields.BEACON_LIST_DATAS! {
            
            var tempCode = obj.url_icon?.url
            
            tempCode?.append((obj.url_icon?.code!)!)
            
            let result: String? = isThereThisPicInDB(code: (tempCode?.md5())!)
            
            if(result == nil){
                let a = CustomerHomeTableCell.init(preCustomerImage: nil ,customerImage: obj.url_icon, customerCampaignTitle: obj.title!, customerName: obj.customer_title!, customerCategoryIcon: image, customerDistanceToMe: "0", customerCoinValue: "0", customerCoinIcon: image, customerDiscountValue: obj.discount!, customerDiscountIcon: image, tell: obj.customer_tell! ,address: obj.customer_address! , text: obj.text! ,workTime: obj.customer_work_time! ,website: obj.cusomer_web! ,customerBigImages: obj.url_pic)
                customerHomeTableCells.append(a)
            }else{
                let a = CustomerHomeTableCell.init(preCustomerImage: UIImage(data: NSData(base64Encoded: result!, options: .ignoreUnknownCharacters) as! Data) ,customerImage: obj.url_icon, customerCampaignTitle: obj.title!, customerName: obj.customer_title!, customerCategoryIcon: image, customerDistanceToMe: "0", customerCoinValue: "0", customerCoinIcon: image, customerDiscountValue: obj.discount!, customerDiscountIcon: image, tell: obj.customer_tell! ,address: obj.customer_address! , text: obj.text! ,workTime: obj.customer_work_time! , website: obj.cusomer_web!,customerBigImages: obj.url_pic)
                customerHomeTableCells.append(a)
            }
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == rightTable){
            leftTable.contentOffset = rightTable.contentOffset
        }else if(scrollView == leftTable){
            rightTable.contentOffset = leftTable.contentOffset
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
