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
import CellAnimator


class IndexHomeViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource {
    
    @IBOutlet weak var IndexHomeTable: UITableView!
    
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var popupView: DCBorderedView!
    
    @IBOutlet weak var binButtonView: UIBarButtonItem!
    
    @IBOutlet weak var deleteAllButton: UIBarButtonItem!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    static var loadViewMore = 0
    
    var customerHomeTableCells = [CustomerHomeTableCell]()
    
//    let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "8F69043E-9623-4F35-B553-FDAA27995EF3")! as UUID, identifier: "Bding")
//    
//    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        IndexHomeTable.contentInset = UIEdgeInsets.zero
        
        IndexHomeTable.dataSource = self
        IndexHomeTable.delegate = self
        IndexHomeTable.rowHeight = self.view.frame.width * 8.5 / 32.0
        popupView.alpha = 0

        self.IndexHomeTable.register(UINib(nibName: "IndexHomeTableViewCell", bundle: nil), forCellReuseIdentifier: "indexHomeTableCellID")
        
        loadHomeTable()
        
        self.updateBadgeVlue()
        
        binButtonView.image = UIImage.init(named: "trash 18")?.imageWithColor(tintColor: UIColor.init(hex: "455a64"))
        binButtonView.tintColor = UIColor.init(hex: "455a64")
        
        binButtonView.title = nil
        deleteAllButton.title = "پیام ها"
        deleteAllButton.setTitleTextAttributes([NSFontAttributeName:UIFont(name: "IRANYekanMobileFaNum-Bold", size: 13)!], for: .normal)
        
        IndexHomeTable.reloadData()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        (UIApplication.shared.delegate as! AppDelegate).locationManager.startRangingBeacons(in: (UIApplication.shared.delegate as! AppDelegate).beaconRegion)
        
        self.updateBadgeVlue()
        
        loadHomeTable()
        
        if(IndexHomeViewController.loadViewMore == 0){
            
            IndexHomeViewController.loadViewMore += 1
            
            IndexHomeTable.reloadData()
            
        }
                
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.IndexHomeTable.dequeueReusableCell(withIdentifier: "indexHomeTableCellID" , for: indexPath) as? IndexHomeTableViewCell
        let tableCell = customerHomeTableCells[indexPath.row]
        
        cell?.customerName.text = tableCell.customerName
        cell?.customerCampaignTitle.text = tableCell.customerCampaignTitle
        cell?.customerDistanceToMe.text = tableCell.customerDistanceToMe
        cell?.customerThumbnail.image = UIImage(named:"default")!

        LoadPicture().proLoad(view: (cell?.customerThumbnail)!,picModel: tableCell.customerImage!){ resImage in
            autoreleasepool { () -> () in
                cell?.customerThumbnail.image = resImage
                cell?.customerThumbnail.contentMode = UIViewContentMode.scaleAspectFill
                cell?.setFirst(screenWidth: self.view.frame.width)
            }
        }
        
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
        
        cell?.setFirst(screenWidth: self.view.frame.width)
        
        if(SaveAndLoadModel().getSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: tableCell.uuidMajorMinorMD5!)?.value(forKey: "isSeen") as! Bool == true){
            
            cell?.boarderView.backgroundColor = UIColor.init(hex: "eceff1")
            
        }
        
        ///////cat icon
        if(tableCell.customerCategoryIcon != nil){
            
            DispatchQueue.main.async(execute: { () -> Void in
                autoreleasepool { () -> () in
                    
                    cell?.customerCategoryThumbnail.image = tableCell.customerCategoryIcon
                    
                }
            })
            
        }else{
            if((GlobalFields.BEACON_LIST_DATAS?.count)! - 1 >= indexPath.row ){
                let cat = findCategory(catID: tableCell.categoryID)
                
                if(cat != nil){
                    
                    LoadPicture().proLoad(view: cell?.customerCategoryThumbnail, picModel: (cat?.url_icon)!) { resImage in
                        
                        cell?.customerCategoryThumbnail.image = resImage
                        
                        self.customerHomeTableCells[indexPath.row].customerCategoryIcon = resImage
                        
                    }
                    
                    
                }
            }
        }
        
        cell?.customerThumbnail.frame.size.height = (self.view.frame.width * 8.5 / 32.0)
        cell?.imgH.constant = (self.view.frame.width * 8.5 / 32.0)
        self.updateBadgeVlue()
        
//        cell?.selectionStyle = .gray
        
        cell?.multipleSelectionBackgroundView = (cell?.selectionView)! as UIView
        
        return cell!
    }
    
    func findCategory(catID : String!) -> CategoryListData?{
        
        for c in GlobalFields.CATEGORIES_LIST_DATAS! {
            
            if(c.category_code == catID){
                
                return c
                
            }
            
        }
        
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerHomeTableCells.count
    }
  
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        CellAnimator.animateCell(cell: cell, withTransform: CellAnimator.TransformFlip, andDuration: 0.3)
        (cell as! IndexHomeTableViewCell).customerThumbnail.frame.size.height = (self.view.frame.width * 8.5 / 32.0)
        (cell as! IndexHomeTableViewCell).imgH.constant = (self.view.frame.width * 8.5 / 32.0)
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return self.view.frame.width * 8.5 / 32.0
//    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(isDeleteMode == true){
            
            tableView.cellForRow(at: indexPath)?.selectedBackgroundView?.alpha = 1
            
        }else{
            
            
            self.IndexHomeTable.deselectRow(at: indexPath, animated: true)
            
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController"))! as! DetailViewController
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.addChildViewController(vc)
                
                vc.setup(data: self.customerHomeTableCells[indexPath.row] ,isPopup:  true , rect: CGRect(x:0,y: 0,width: self.popupView.frame.size.width, height: self.popupView.frame.size.height))
                
                vc.view.frame = CGRect(x:0,y: 0,width: self.popupView.frame.size.width, height: self.popupView.frame.size.height)
                
                self.popupView.addSubview(vc.view)
                
                vc.didMove(toParentViewController: self)
                
                self.navigationBar.alpha = 0
                
                vc.view.alpha = 1
                
                self.blurView.alpha = 1
                
                self.popupView.alpha = 1
                
            }, completion: nil)

            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            removeFromDB(cells: [indexPath])
            
            tableView.reloadData()
            
        }
        
        
        
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
    }
    
    
    func removeFromDB(cells : [IndexPath]) -> Void{
        
        let db = SaveAndLoadModel()
        
        for cell in cells {
            
            let obj = db.getSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: customerHomeTableCells[cell.row].uuidMajorMinorMD5!)
            
            db.updateSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: customerHomeTableCells[cell.row].uuidMajorMinorMD5! , newItem: ["uuid" : obj?.value(forKey: "uuid") , "major" : obj?.value(forKey: "major") , "minor" : obj?.value(forKey: "minor") , "id" : obj?.value(forKey: "id") , "isSeen" : obj?.value(forKey: "isSeen") , "seenTime" : obj?.value(forKey: "seenTime") , "beaconDataJSON" : obj?.value(forKey: "beaconDataJSON") ,"isRemoved" : true])
            
            customerHomeTableCells.remove(at: cell.row)
            
            
        }
        self.IndexHomeTable.beginUpdates()
        
        self.IndexHomeTable.deleteRows(at: cells, with: UITableViewRowAnimation.right)
        
        self.IndexHomeTable.endUpdates()
        
        self.IndexHomeTable.reloadData()
        
    }
    
    
    
    
    func loadHomeTable(){
        //create customer Home Table Cell from web service :)
        
        let db = SaveAndLoadModel()
        
        let beaconsData = db.load(entity: "BEACON")
        
        if(customerHomeTableCells.count == beaconsData!.count){
            
            return
            
        }
        
        self.customerHomeTableCells.removeAll()
        
        for bData in beaconsData!{
            
            let jsonData: String? = bData.value(forKey: "beaconDataJSON") as? String
            
            let uuid: String = bData.value(forKey: "uuid") as! String
            
            let major: String = bData.value(forKey: "major") as! String
            
            let minor: String = bData.value(forKey: "minor") as! String
            
            var s : String = uuid
            
            s.append(major)
            
            s.append(minor)
            
            s = s.md5()
            
            if(bData.value(forKey: "isRemoved") as? Bool == false){
                
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
                                
                                db.updateSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: s, newItem: ["uuid" : uuid , "major" : major , "minor" : minor , "id" : s , "isSeen" : false , "seenTime" : Date() , "beaconDataJSON" : self.jsonToString(json: JSON as AnyObject) ,"isRemoved" : false])
                                
                                
                                self.customerHomeTableCells.append(self.getCustomerHomeTableCellAsJson(jsonData: JSON as! JSON,uuidMajorMinorMD5: s)!)
                                
                                self.IndexHomeTable.reloadData()
                            }
                            
                        }
                        
                    }
                    
                    
                    
                }else{
                    
                    print(jsonData ?? "")
                    print()
                    print(bData.value(forKey: "seenTime") ?? "")
                    print(Date())
                    self.customerHomeTableCells.append(self.getCustomerHomeTableCellAsJson(jsonData: convertToDictionary(text: jsonData!)!,uuidMajorMinorMD5: s)!)
                    
                    self.IndexHomeTable.reloadData()
                    
                }
                
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
    
    func getCustomerHomeTableCellAsJson(jsonData : JSON , uuidMajorMinorMD5 : String!) -> CustomerHomeTableCell?{
        
        let o = BeaconListResponseModel.init(json: jsonData)
        
//        let image : UIImage = UIImage(named:"mal")!
        
        if ( o?.code == "200" ){
            
            let obj = (o?.data)![0]
            
            var tempCode = obj.url_icon?.url
            
            tempCode?.append((obj.url_icon?.code!)!)
            
            let result: String? = isThereThisPicInDB(code: (tempCode?.md5())!)
            
            let locManager = CLLocationManager()
            
            locManager.requestAlwaysAuthorization()
            
            var currentLocation = CLLocation()
            
            if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways ||
                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
                
                currentLocation = locManager.location!
                
            }
            
            if(result == nil){
                let a = CustomerHomeTableCell.init(uuidMajorMinorMD5: uuidMajorMinorMD5 ,preCustomerImage: nil ,customerImage: obj.url_icon, customerCampaignTitle: obj.title!, customerName: obj.customer_title!, customerCategoryIcon: nil, customerDistanceToMe: String(describing: round((obj.distance ?? 0) * 100) / 100) , customerCoinValue: obj.coin ?? "0", customerDiscountValue: obj.discount!, tell: obj.customer_tell! ,address: obj.customer_address! , text: obj.text! ,workTime: obj.customer_work_time! ,website: obj.cusomer_web! ,customerBigImages: obj.url_pic, categoryID: obj.category_id, beaconCode : obj.beacon_code)
                
                if(currentLocation.coordinate.latitude != 0){
                    
                    let dis = String(format: "%.2f", currentLocation.distance(from: CLLocation.init(latitude: (Double(obj.lat!))!, longitude: (Double(obj.long!))!))/1000)
                    
                    obj.distance = Double(dis)
                    a.customerDistanceToMe = dis
                    
                }
                
                return a
            }else{
                let a = CustomerHomeTableCell.init(uuidMajorMinorMD5: uuidMajorMinorMD5 ,preCustomerImage: UIImage(data: NSData(base64Encoded: result!, options: .ignoreUnknownCharacters) as! Data) ,customerImage: obj.url_icon, customerCampaignTitle: obj.title!, customerName: obj.customer_title!, customerCategoryIcon: nil, customerDistanceToMe: String(describing: round((obj.distance ?? 0) * 100) / 100) , customerCoinValue: obj.coin ?? "0" , customerDiscountValue: obj.discount!, tell: obj.customer_tell! ,address: obj.customer_address! , text: obj.text! ,workTime: obj.customer_work_time! , website: obj.cusomer_web!,customerBigImages: obj.url_pic, categoryID: obj.category_id, beaconCode : obj.beacon_code)
                
                if(currentLocation.coordinate.latitude != 0){
                    
                    let dis = String(format: "%.2f", currentLocation.distance(from: CLLocation.init(latitude: (Double(obj.lat!))!, longitude: (Double(obj.long!))!))/1000)
                    
                    obj.distance = Double(dis)
                    a.customerDistanceToMe = dis
                    
                }
                
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
    
    func updateBadgeVlue(){
        
        var count = 0
        
        for obj in customerHomeTableCells {
            if(SaveAndLoadModel().getSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: obj.uuidMajorMinorMD5!)?.value(forKey: "isSeen") as! Bool == false){
                
                count += 1
                
            }
            
        }
        
        self.tabBarController?.tabBar.items?[1].badgeValue = String(count)
        
        if(count == 0){
            
            self.tabBarController?.tabBar.items?[1].badgeValue  = nil
            
        }
        
    }
    
    @IBAction func changeView(_ sender: Any) {

    }
    

    func deletSubView(){
        
//        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "IndexHomeViewController"))! as! IndexHomeViewController
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
        
        
//        self.addChildViewController(vc)
//            
//        vc.view.frame = CGRect(x:0,y: 0,width: self.container.frame.size.width, height: self.container.frame.size.height);
//        
//        self.container.addSubview(vc.view)
            
        self.popupView.alpha = 0
        
//        vc.didMove(toParentViewController: self)
            
        self.blurView.alpha = 0
            
        }){completion in
         
//            vc.IndexHomeTable.reloadData()
            
            self.loadHomeTable()
            
            self.IndexHomeTable.reloadData()
            
        }
        
    }
    
    var isDeleteMode: Bool = false
    
    @IBAction func deletePressed(_ sender: Any) {
        
        isDeleteMode = !isDeleteMode
        
        if(isDeleteMode == true){
            
            IndexHomeTable.allowsMultipleSelectionDuringEditing = true
            IndexHomeTable.setEditing(true, animated: true)
            
            binButtonView.image = nil
            binButtonView.title = "انصراف"
            binButtonView.setTitleTextAttributes([NSFontAttributeName:UIFont(name: "IRANYekanMobileFaNum-Bold", size: 13)!], for: .normal)
            deleteAllButton.title = "حذف"
            deleteAllButton.tintColor = UIColor.init(hex: "D50000")
            deleteAllButton.setTitleTextAttributes([NSFontAttributeName:UIFont(name: "IRANYekanMobileFaNum-Bold", size: 13)!], for: .normal)
        }else{
            
            IndexHomeTable.allowsMultipleSelectionDuringEditing = false
            IndexHomeTable.setEditing(false, animated: true)
            
            binButtonView.image = UIImage.init(named: "trash 18")?.imageWithColor(tintColor: UIColor.init(hex: "455a64"))
            binButtonView.tintColor = UIColor.init(hex: "455a64")
            
            binButtonView.title = nil
            deleteAllButton.tintColor = UIColor.init(hex: "455a64")
            deleteAllButton.title = "پیام ها"
            deleteAllButton.setTitleTextAttributes([NSFontAttributeName:UIFont(name: "IRANYekanMobileFaNum-Bold", size: 13)!], for: .normal)
        }
    }
    
    @IBAction func deleteAll(_ sender: Any) {
        
        if(isDeleteMode && self.IndexHomeTable.indexPathsForSelectedRows != nil){
            
            removeFromDB(cells: self.IndexHomeTable.indexPathsForSelectedRows!)
            
            isDeleteMode = false
            
            deleteAllButton.title = "پیام ها"
            
            IndexHomeTable.allowsMultipleSelectionDuringEditing = false
            IndexHomeTable.setEditing(false, animated: true)
            
            
            
        }
        
        
    }
    
    
    
    
    

}










