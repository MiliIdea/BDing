//
//  IndexHomeViewController.swift
//  BDingTest
//
//  Created by Milad on 2/15/17.
//  Copyright © 2017 Milad. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth


class IndexHomeViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource {
    
    @IBOutlet weak var IndexHomeTable: UITableView!
    
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var popupView: DCBorderedView!
    var customerHomeTableCells = [CustomerHomeTableCell]()
    
//    let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "8F69043E-9623-4F35-B553-FDAA27995EF3")! as UUID, identifier: "Bding")
//    
//    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        IndexHomeTable.dataSource = self
        IndexHomeTable.delegate = self
        
        popupView.alpha = 0
        
//        locationManager = CLLocationManager()
//        
//        locationManager.delegate = self
//        
//        locationManager.requestAlwaysAuthorization()
//        
//        locationManager.startRangingBeacons(in: region)
        
        loadHomeTable()
        // Do any additional setup after loading the view.
    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedAlways {
//            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
//                if CLLocationManager.isRangingAvailable() {
//                    startScanning()
//                }
//            }
//        }
//    }
//    
//    func startScanning() {
//        let uuid = UUID(uuidString: "8F69043E-9623-4F35-B553-FDAA27995EF3")!
//        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "Bding")
//        
//        locationManager.startMonitoring(for: beaconRegion)
//        locationManager.startRangingBeacons(in: beaconRegion)
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
//        if beacons.count > 0 {
//            print("yeaaaaaaaaaaaaa greaaaate!!!!!")
//        } else {
//            print("fuck Maaaaan!!!")
//        }
//    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.IndexHomeTable.dequeueReusableCell(withIdentifier: "indexHomeTableCellIdentifier" , for: indexPath) as? IndexHomeTableViewCell
        let tableCell = customerHomeTableCells[indexPath.row]
        
        cell?.customerName.text = tableCell.customerName
        cell?.customerCampaignTitle.text = tableCell.customerCampaignTitle
        cell?.customerDistanceToMe.text = tableCell.customerDistanceToMe
        cell?.customerThumbnail.image = UIImage(named:"profile_pic")!
        cell?.customerCampaignCoin.text = tableCell.customerCoinValue
        cell?.customerCampaignDiscount.text = tableCell.customerDiscountValue
        cell?.customerCategoryThumbnail.image = tableCell.customerCategoryIcon
        cell?.coinThumbnail.image = tableCell.customerCoinIcon
        cell?.discountThumbnail.image = tableCell.customerDiscountIcon
        cell?.customerThumbnail.frame.size.height = (cell?.boarderView.frame.height)!
        cell?.customerThumbnail.frame.origin.y = (cell?.boarderView.frame.origin.y)!
        let maskPath = UIBezierPath(roundedRect: (cell?.customerThumbnail.bounds)!, byRoundingCorners: [.bottomRight, .topRight], cornerRadii: CGSize(width: 8.0, height: 8.0))
        
        let shape = CAShapeLayer()
        
        shape.path = maskPath.cgPath
        
        cell?.customerThumbnail.layer.mask = shape
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerHomeTableCells.count
    }
  
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController"))! as! DetailViewController
            
            self.addChildViewController(vc)
            
//            vc.view.frame = CGRect(x:0,y: 0,width: self.container.frame.size.width, height: self.container.frame.size.height);

            vc.view.frame = CGRect(x:0,y: 0,width: self.popupView.frame.size.width, height: self.popupView.frame.size.height);
            
            self.popupView.addSubview(vc.view)
            
            vc.didMove(toParentViewController: self)
            
            vc.setup(data: self.customerHomeTableCells[indexPath.row] ,isPopup:  true)
            
            self.navigationBar.alpha = 0
            
//            self.IndexHomeTable.alpha = 0
            
            self.popupView.alpha = 1
            
        }, completion: nil)
    }
    
    
    
    func loadHomeTable(){
        //create customer Home Table Cell from web service :)
        let image : UIImage = UIImage(named:"profile_pic")!
//        let a1 = CustomerHomeTableCell.init(preCustomerImage: nil,customerImage: nil, customerCampaignTitle: "فروش فوق العاده", customerName: "آدیداس", customerCategoryIcon: image, customerDistanceToMe: "۱۲۵", customerCoinValue: "۱۲", customerCoinIcon: image, customerDiscountValue: "۱۰", customerDiscountIcon: image, tell: "asd" ,address: "asd" , text: "asd" ,workTime: "asd" , website: "www.asd.com" , customerBigImages: nil)
//
//        customerHomeTableCells.append(a1)
        
        
        let db = SaveAndLoadModel()
        
        let beaconsData = db.load(entity: "BEACON")
        
        for bData in beaconsData!{
            
            let jsonData: String? = bData.value(forKey: "beaconDataJSON") as? String
            
            let uuid: String = bData.value(forKey: "uuid") as! String
            
            let major: String = bData.value(forKey: "major") as! String
            
            let minor: String = bData.value(forKey: "minor") as! String
            
            var s : String = uuid
            
            s.append(major)
            
            s.append(minor)
            
            s = s.md5()
            
            if(jsonData == nil){
                //getBeacon and update db
                
                let s2 = GetBeaconRequestModel(UUID: uuid , MAJOR: major, MINOR: minor)
                
                print("PARAMETER")
                print(s2.getParams())
                
                request(URLs.getBeacon , method: .post , parameters: s2.getParams(), encoding: JSONEncoding.default).responseJSON { response in
                    print()
                    
                    if let JSON = response.result.value {
                        
                        print("JSON -----------GET BEACON---------->>>> " , JSON)
                        
                        let obj = BeaconListResponseModel.init(json: JSON as! JSON)
                        
                        if ( obj?.code == "200" ){
                            
                            db.updateSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: s, newItem: ["uuid" : uuid , "major" : major , "minor" : minor , "id" : s , "isSeen" : false , "seenTime" : Date() , "beaconDataJSON" : self.jsonToString(json: JSON as AnyObject)])
                            
                            
                            self.customerHomeTableCells.append(self.getCustomerHomeTableCellAsJson(jsonData: JSON as! JSON)!)
                            
                            self.IndexHomeTable.reloadData()
                        }
                        
                    }
                    
                }

                
                
            }else{
                
                print(jsonData)

                self.customerHomeTableCells.append(self.getCustomerHomeTableCellAsJson(jsonData: convertToDictionary(text: jsonData!)!)!)
                
            }
            
        }
        
        
    }
    
    func jsonToString(json: AnyObject) -> String? {
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
           return convertedString! // <-- here is ur string
            
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getCustomerHomeTableCellAsJson(jsonData : JSON) -> CustomerHomeTableCell?{
        
        let o = BeaconListResponseModel.init(json: jsonData)
        
        let image : UIImage = UIImage(named:"mal")!
        
        if ( o?.code == "200" ){
            
            let obj = (o?.data)![0]
            
            var tempCode = obj.url_icon?.url
            
            tempCode?.append((obj.url_icon?.code!)!)
            
            let result: String? = isThereThisPicInDB(code: (tempCode?.md5())!)
            
            if(result == nil){
                let a = CustomerHomeTableCell.init(preCustomerImage: nil ,customerImage: obj.url_icon, customerCampaignTitle: obj.title!, customerName: obj.customer_title!, customerCategoryIcon: image, customerDistanceToMe: "0", customerCoinValue: "0", customerCoinIcon: image, customerDiscountValue: obj.discount!, customerDiscountIcon: image, tell: obj.customer_tell! ,address: obj.customer_address! , text: obj.text! ,workTime: obj.customer_work_time! ,website: obj.cusomer_web! ,customerBigImages: obj.url_pic)
                return a
            }else{
                let a = CustomerHomeTableCell.init(preCustomerImage: UIImage(data: NSData(base64Encoded: result!, options: .ignoreUnknownCharacters) as! Data) ,customerImage: obj.url_icon, customerCampaignTitle: obj.title!, customerName: obj.customer_title!, customerCategoryIcon: image, customerDistanceToMe: "0", customerCoinValue: "0", customerCoinIcon: image, customerDiscountValue: obj.discount!, customerDiscountIcon: image, tell: obj.customer_tell! ,address: obj.customer_address! , text: obj.text! ,workTime: obj.customer_work_time! , website: obj.cusomer_web!,customerBigImages: obj.url_pic)
                return a
            }
            
        }
        
        return nil
        
    }
    
    func isThereThisPicInDB (code: String) -> String?{
        
        for i in SaveAndLoadModel().load(entity: "IMAGE")!{
            
            if(i.value(forKey: "imageCode") as! String == code){
                
                return i.value(forKey: "imageData") as! String
                
            }
            
        }
        
        return nil
        
    }
    
    @IBAction func changeView(_ sender: Any) {
        
//        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
//        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "CategoryPageViewController"))! as! CategoryPageViewController
//        
//        vc.parentView = "IndexHomeViewController"
//            
//        self.addChildViewController(vc)
//        
//        vc.view.frame = CGRect(x:0,y: 0,width: self.container.frame.size.width, height: self.container.frame.size.height);
//        
////        self.container.addSubview(vc.view)
//            
//        self.IndexHomeTable.addSubview(vc.view)
//        
//        vc.didMove(toParentViewController: self)
//        
//        self.navigationBar.alpha = 0
//        
//        self.IndexHomeTable.alpha = 0
//        }, completion: nil)
    }
    

    func deletSubView(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "IndexHomeViewController"))! as UIViewController
        
        self.addChildViewController(vc)
        
        vc.view.frame = CGRect(x:0,y: 0,width: self.container.frame.size.width, height: self.container.frame.size.height);
        
        self.container.addSubview(vc.view)
            
        self.popupView.alpha = 0
        
        vc.didMove(toParentViewController: self)
        }, completion: nil)
        
    }
    
    

}










