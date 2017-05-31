//
//  AlarmViewController.swift
//  BDing
//
//  Created by MILAD on 3/4/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Lottie

class AlarmViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource , UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var rightTable: UITableView!
    
    @IBOutlet weak var leftTable: UITableView!
    
    @IBOutlet weak var rightWidth: NSLayoutConstraint!
    
    @IBOutlet weak var leftWidth: NSLayoutConstraint! // left leading -172
    
    @IBOutlet weak var leftOrginalWidth: NSLayoutConstraint!
    
    
  
    @IBOutlet var container: UIView!
    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var doSearchButton: DCBorderedButton!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var clearButton: UIButton!
    
    // SORT 
    
    @IBOutlet weak var sortView: UIView!
    
    @IBOutlet weak var sortButton: UIButton!
    
    @IBOutlet weak var nearestButton: DCBorderedButton!
    
    @IBOutlet weak var maxCoinButton: DCBorderedButton!
    
    @IBOutlet weak var mostPopularButton: DCBorderedButton!
    
    @IBOutlet weak var newestButton: DCBorderedButton!
    
    var isShowSortView : Bool = false
    
    ///////////////////////////////
    
    var cache: NSCache<AnyObject, AnyObject> = NSCache()
    
    ///////////////////////////////
    
    static var mode = true
    
    var searchOrigin : CGFloat = 0
    
    var isSearched : [Bool] = [Bool]()
    
    var searchIsPressed: Bool = true
    
    var animationView : LOTAnimationView?
    
    var customerHomeTableCells = [CustomerHomeTableCell]()
    
    struct LastSearchStruct {
        
        init(isSelected : [Bool]) {
            
            self.isSelected = isSelected
        }
        
        var prePic : [UIImage?]? = [UIImage]()

        var isSelected : [Bool] = [Bool]()
    }
    
    var lastSearch : LastSearchStruct? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MyFont().setFontForAllView(view: view)

        sortView.alpha = 0
        
        searchIsPressed = false
        
        searchOrigin = self.doSearchButton.frame.origin.y
        self.searchView.frame.size.height = 0
        self.collectionView.frame.size.height = 0
        self.collectionView.alpha = 0
        self.doSearchButton.alpha = 0
        self.searchTextField.alpha = 0
        
        var s: String? = GlobalFields.PROFILEDATA?.name
        
        let s2: String? = " دنبال چی میگردی"
        
        if(s == nil){
            
            s = ""
            
        }else{
            
            s2?.appending(" ")
            
        }
        
        self.searchTextField.placeholder = s2?.appending(s!)
        self.clearButton.alpha = 0
        self.blurView.alpha = 0
        
        var temp:[Bool] = [Bool]()
        
        for i in 0...(GlobalFields.CATEGORIES_LIST_DATAS?.count)! - 1 {
            
            temp.insert(false, at: i)
    
        }
        
        lastSearch = LastSearchStruct.init(isSelected: temp)
        
        isSearched = [Bool]()
        
        for i in 0...(GlobalFields.CATEGORIES_LIST_DATAS?.count)! - 1 {
            
            lastSearch?.prePic?.insert(nil, at: i)
            
            isSearched.insert(false, at: i)
            
        }
        
        doSearchButton.isEnabled = false
        
        collectionView.register(UINib(nibName: "FilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionViewCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self

        
        ///======////
        rightTable.dataSource = self
        rightTable.delegate = self
//        rightTable.register(UITableViewCell.self, forCellReuseIdentifier: "rightCell")
        
        leftTable.dataSource = self
        leftTable.delegate = self
//        leftTable.register(UITableViewCell.self, forCellReuseIdentifier: "leftCell")
        
        loadHomeTable()
        
        self.rightTable.reloadData()
        
        self.leftTable.reloadData()
        
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

    
    
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    @IBAction func playResizeTables(_ sender: Any) {
        
//        if(rightTable.isDragging || leftTable.isDragging){
//            
//            return
//            
//        }
        
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
//                self.leftWidth.constant = -(self.rightTable.superview?.frame.width)!/2+4
//                self.rightTable.frame.size.width = (self.rightTable.superview?.frame.width)!
//                self.rightWidth.constant = (self.rightTable.superview?.frame.width)!-4

                self.leftOrginalWidth.constant = self.view.frame.width / 2
                
                self.leftWidth.constant = -(self.view.frame.width)/2+4
                self.rightTable.frame.size.width = (self.view.frame.width)
                self.rightWidth.constant = (self.rightTable.superview?.frame.width)!-4
                
                
                ////////=========///////

                for c in 1...self.rightTable.numberOfRows(inSection: 0) {
                    
                    (self.rightTable.cellForRow(at: IndexPath(row: c-1, section: 0)) as? IndexHomeTableViewCell)?.setFirst()
                    
                }
                
                self.leftTable.contentOffset = self.rightTable.contentOffset
                
                
                self.view.layoutIfNeeded()
                
                
            }else {
                
                print(self.leftTable.contentOffset)
                print(self.rightTable.contentOffset)
                
//                if(self.rightTable.isDragging || self.leftTable.isDragging){
                
                    self.rightTable.contentOffset.y = 0
                    self.leftTable.contentOffset.y = 0
                    
//                }else{
//                    
//                    
//                    self.leftTable.contentOffset = CGPoint(x: 0, y: CGFloat((self.leftTable.indexPathsForVisibleRows?.first?.row)!) * ((self.leftTable.visibleCells.first?.frame.height)! * 1.3))
//                    
//                    
//                    self.rightTable.contentOffset = self.leftTable.contentOffset
//                    
//                }
                
                //resizing table double
                self.leftWidth.constant = -16

//                self.rightTable.frame.size.width = self.leftTable.frame.width
//                self.rightWidth.constant =  self.leftTable.frame.width

                
                self.rightTable.frame.size.width = self.view.frame.width / 2
                
                self.leftTable.frame.size.width = self.view.frame.width / 2
                
                self.rightWidth.constant =  self.leftTable.frame.width
                
                self.leftOrginalWidth.constant = self.view.frame.width / 2
                
                for c in 1...self.rightTable.numberOfRows(inSection: 0) {
                    
                    (self.rightTable.cellForRow(at: IndexPath(row: c-1, section: 0)) as? IndexHomeTableViewCell)?.setLast()
                    (self.leftTable.cellForRow(at: IndexPath(row: c-1, section: 0)) as? IndexHomeTableViewCell)?.setLast()
                    
                }
                
                self.view.layoutIfNeeded()
                
            }
            
        }, completion: nil)
        
        print(self.leftTable.contentOffset)
        print(self.rightTable.contentOffset)
        print()
        
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
                
                vc.setup(data: self.customerHomeTableCells[indexPath.row] , isPopup: false , rect: nil)
                
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
                
                vc.setup(data: self.customerHomeTableCells[(indexPath.row * 2) + 1] , isPopup: false , rect: nil)
                
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

        customerHomeTableCells.removeAll()
        
        if(GlobalFields.BEACON_LIST_DATAS != nil){
            
            for obj in GlobalFields.BEACON_LIST_DATAS! {
                
                var tempCode = obj.url_icon?.url
                
                tempCode?.append((obj.url_icon?.code!)!)
                
                let result: String? = isThereThisPicInDB(code: (tempCode?.md5())!)
                
                var catIcon : UIImage? = nil
                
                for cat in GlobalFields.CATEGORIES_LIST_DATAS! {
                    
                    if(cat.category_code == obj.category_id){
                        
                        LoadPicture().proLoad(view: nil,picModel: cat.url_icon!){ resImage in
                            
                            catIcon = resImage
                            
                            var c1 : CGColor = UIColor(hex: "f5f7f8").cgColor
                            var c2 : CGColor = UIColor(hex: "7c1f72").cgColor
                            
                            let colorsString = cat.color_code?.characters.split(separator: "-").map(String.init)
                            
                            if(colorsString != nil && colorsString?[0] != nil && colorsString?[1] != nil){
                                
                                c1 = UIColor(hex: (colorsString?[0])!).cgColor
                                
                                c2 = UIColor(hex: (colorsString?[1])!).cgColor
                                
                            }
                            
                            catIcon = self.setTintGradient(image: catIcon!, c: [c1,c2])
                            
                            //////
                            
                            if(result == nil){
                                let a = CustomerHomeTableCell.init(uuidMajorMinorMD5: nil,preCustomerImage: nil ,customerImage: obj.url_icon, customerCampaignTitle: obj.title!, customerName: obj.customer_title!, customerCategoryIcon: catIcon!, customerDistanceToMe: "0", customerCoinValue: "0", customerCoinIcon: image, customerDiscountValue: obj.discount!, customerDiscountIcon: image, tell: obj.customer_tell! ,address: obj.customer_address! , text: obj.text! ,workTime: obj.customer_work_time! ,website: obj.cusomer_web! ,customerBigImages: obj.url_pic)
                                self.customerHomeTableCells.append(a)
                                
                                self.rightTable.reloadData()
                                
                                self.leftTable.reloadData()
                            }else{
                                let a = CustomerHomeTableCell.init(uuidMajorMinorMD5: nil,preCustomerImage: UIImage(data: NSData(base64Encoded: result!, options: .ignoreUnknownCharacters) as! Data) ,customerImage: obj.url_icon, customerCampaignTitle: obj.title!, customerName: obj.customer_title!, customerCategoryIcon: catIcon!, customerDistanceToMe: "0", customerCoinValue: "0", customerCoinIcon: image, customerDiscountValue: obj.discount!, customerDiscountIcon: image, tell: obj.customer_tell! ,address: obj.customer_address! , text: obj.text! ,workTime: obj.customer_work_time! , website: obj.cusomer_web!,customerBigImages: obj.url_pic)
                                self.customerHomeTableCells.append(a)
                                
                                self.rightTable.reloadData()
                                
                                self.leftTable.reloadData()
                                
                            }
                            
                            //////
                            
                        }
                        
                    }
                    
                }
                
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
    
    
    
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    @IBAction func search(_ sender: Any) {
        
        self.searchIsPressed = !self.searchIsPressed
        
        if(self.searchIsPressed == false){
            
            hiddenSearchView()
            
        }else{
            
            showSearchView()
            
        }
        
    }
    
    func someAction(sender:UITapGestureRecognizer?){
        
        self.searchIsPressed = !self.searchIsPressed
        
        if(self.searchIsPressed == false){
            
            hiddenSearchView()
            
        }else{
            
            showSearchView()
            
        }
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            let currentPoint = touch.location(in: blurView)
            
            if(currentPoint.y > 0 && currentPoint.x > 0 && isShowSortView == true){
                
                hiddenSortView()
                
            }
            
            if(currentPoint.y > 0 && currentPoint.x > 0 && self.searchIsPressed == true){
                
                self.searchIsPressed = !self.searchIsPressed

                if(self.searchIsPressed == false){
                    
                    hiddenSearchView()
                    
                }else{
                    
                    showSearchView()
                    
                }
                
            }
            
        }
        
    }
    
    func showSearchView(){
        
        hiddenSortView()
        
        isShowSortView = false
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.searchView.frame.size.height = 180
                self.collectionView.frame.size.height = 70
                self.collectionView.alpha = 1
                self.doSearchButton.alpha = 1
                self.doSearchButton.frame.size.height = 30
                self.clearButton.alpha = 1
                self.clearButton.frame.size.height = 30
                self.clearButton.frame.origin.y = self.searchView.frame.height - 10 - self.clearButton.frame.height
                self.doSearchButton.frame.origin.y = self.searchView.frame.height - 10 - self.clearButton.frame.height
                self.searchTextField.alpha = 1
                self.blurView.alpha = 0.85

            
        } , completion : nil)

        
    }
    
    
    func hiddenSearchView(){
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.searchView.frame.size.height = 0
            self.collectionView.frame.size.height = 0
            self.collectionView.alpha = 0
            self.doSearchButton.alpha = 0
            self.doSearchButton.frame.size.height = 0
            self.doSearchButton.frame.origin.y -= 180
            self.clearButton.alpha = 0
            self.clearButton.frame.size.height = 0
            self.clearButton.frame.origin.y -= 180
            self.searchTextField.alpha = 0
            self.blurView.alpha = 0
            
            
        } , completion : nil)
        
        
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
    

    
    @IBAction func clearSearch(_ sender: Any) {
        
        
        for j in 0...(self.isSearched.count - 1) {
            
            self.lastSearch?.isSelected[j] = false
            
        }
        
        collectionView.reloadData()
        
        if(isNewSeach(ls: lastSearch?.isSelected) == true){
            
            doSearchButton.normalBackgroundColor = UIColor(hex: "4bb272")
            
            doSearchButton.normalTextColor = UIColor.white
            
            doSearchButton.isEnabled = true
            
        }else{
            
            doSearchButton.normalBackgroundColor = UIColor.white
            
            doSearchButton.normalTextColor = UIColor.black
            
            doSearchButton.isEnabled = false
            
            
        }
        
        
    }
    
    
    
    
    
    @IBAction func doingSearch(_ sender: Any) {
        
        var lat: String
        
        var long: String
        
        let locManager = CLLocationManager()
        
        locManager.requestWhenInUseAuthorization()
        
        var currentLocation = CLLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized){
            
            currentLocation = locManager.location!
            
        }
        
        long = String(currentLocation.coordinate.longitude)
        
        lat = String(currentLocation.coordinate.latitude)
        
//        long = String(51.4212297)
//        
//        lat = String(35.6329044)
        
        var categoryList:[String] = [String]()
        
        for j in 0...(self.isSearched.count - 1) {
            
            if(self.lastSearch?.isSelected[j] == true){
                
                categoryList.append((GlobalFields.CATEGORIES_LIST_DATAS?[j].category_code)!)
                
            }
            
        }
        
        
        request(URLs.getBeaconList , method: .post , parameters: BeaconListRequestModel(LAT: lat, LONG: long, REDIUS: String(GlobalFields.BEACON_RANG), SEARCH: nil, CATEGORY: String(describing: categoryList), SUBCATEGORY: nil).getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------BEACON----------->>>> ")
                
                let obj = BeaconListResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                    
                    GlobalFields.BEACON_LIST_DATAS = obj?.data
                    
                    for i in 0...(self.isSearched.count - 1) {
                        
                        self.isSearched[i] = (self.lastSearch?.isSelected[i])!
                        
                    }
                    
                    self.loadHomeTable()
                    
                    self.rightTable.reloadData()
                    
                    self.leftTable.reloadData()
                    
                    self.someAction(sender: nil)
                    
                    if(self.isNewSeach(ls: self.lastSearch?.isSelected) == true){
                        
                        self.doSearchButton.normalBackgroundColor = UIColor(hex: "4bb272")
                        
                        self.doSearchButton.normalTextColor = UIColor.white
                        
                        self.doSearchButton.isEnabled = true
                        
                    }else{
                        
                        self.doSearchButton.normalBackgroundColor = UIColor.white
                        
                        self.doSearchButton.normalTextColor = UIColor.black
                        
                        self.doSearchButton.isEnabled = false
                        
                        
                    }
                    
                }
                
            }
            
        }
        
        
    }
    
    
    
    func isNewSeach(ls:[Bool]?) -> Bool{
        
        for i in 0...(ls?.count)!-1 {
            
            if(ls?[i] != isSearched[i]){
                
                return true
                
            }
            
        }
        
        return false
        
    }
    
    
    
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (GlobalFields.CATEGORIES_LIST_DATAS?.count)!
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath as IndexPath) as! FilterCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
      
        
        let data = GlobalFields.CATEGORIES_LIST_DATAS?[indexPath.item]
        
        var c1 : CGColor = UIColor(hex: "f5f7f8").cgColor
        var c2 : CGColor = UIColor(hex: "7c1f72").cgColor
        
        let colorsString = data?.color_code?.characters.split(separator: "-").map(String.init)
        
        if(colorsString != nil && colorsString?[0] != nil && colorsString?[1] != nil){
            
            c1 = UIColor(hex: (colorsString?[0])!).cgColor
            
            c2 = UIColor(hex: (colorsString?[1])!).cgColor
            
        }
        
        //////// set data in cell
        
        cell.title.text = data?.title
        
        MyFont().setLightFont(view: cell.title, mySize: 10)
        
        // set image
        
        
        if(lastSearch?.prePic?[indexPath.item] == nil){
            
            if(data?.url_icon?.url != nil){
                
                var im: UIImage? = loadImage(picModel: (data?.url_icon!)!)
                
                if(im != nil){
                    
                    im = im?.imageWithColor(tintColor: UIColor.white)
                    
                    lastSearch?.prePic?[indexPath.item] = im
                    
                    cell.image.image = im
                    
                }else{
                    
                    request("http://"+(data!.url_icon?.url)! ,method: .post ,parameters: BeaconPicRequestModel(CODE: data!.url_icon?.code, FILE_TYPE: data?.url_icon?.file_type).getParams(), encoding : JSONEncoding.default).responseJSON { response in
                        
                        if let image = response.result.value {
                            
                            let obj = PicDataModel.init(json: image as! JSON)
                            
                            let imageData = NSData(base64Encoded: (obj?.data!)!, options: .ignoreUnknownCharacters)
                            
                            var coding: String = (data!.url_icon?.url)!
                            
                            coding.append((data?.url_icon?.code)!)
                            
                            SaveAndLoadModel().save(entityName: "IMAGE", datas: ["imageCode": coding.md5() , "imageData": obj?.data!])
                            
                            self.cache.setObject(imageData!, forKey: coding.md5() as AnyObject)
                            
                            let pic = UIImage(data: imageData as! Data)
                            
                            self.lastSearch?.prePic?.insert(pic, at: indexPath.item)
                            
                            cell.image.image = pic
                            
                            cell.image.contentMode = UIViewContentMode.scaleAspectFit
                            
                        }
                    }
                    
                }
                
            }
            
        }else{
            
            cell.image.image = lastSearch?.prePic?[indexPath.item]
            
            cell.image.contentMode = UIViewContentMode.scaleAspectFit
            
        }
        
        
        
        
        
        //end seting image
        
        if(lastSearch?.isSelected[indexPath.item] == false){
            // not selected
            
            cell.circleView.layer.insertSublayer(setGradientLayer(myView: cell.circleView, color1: UIColor.white.cgColor, color2: UIColor.white.cgColor), below: cell.circleView.layer.sublayers?.last)
            
            cell.image.image = setTintGradient(image: cell.image.image!, c: [c1,c2])
            
        }else{
            //selected
            
            cell.circleView.layer.insertSublayer(setGradientLayer(myView: cell.circleView, color1: c1, color2: c2), below: cell.circleView.layer.sublayers?.last)
            
            cell.image.image = setTintGradient(image: cell.image.image!, c: [UIColor.white.cgColor ,UIColor.white.cgColor])
            
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = GlobalFields.CATEGORIES_LIST_DATAS?[indexPath.item]
        
        var c1 : CGColor = UIColor(hex: "f5f7f8").cgColor
        var c2 : CGColor = UIColor(hex: "7c1f72").cgColor
        
        let colorsString = data?.color_code?.characters.split(separator: "-").map(String.init)
        
        if(colorsString != nil && colorsString?[0] != nil && colorsString?[1] != nil){
            
            c1 = UIColor(hex: (colorsString?[0])!).cgColor
            
            c2 = UIColor(hex: (colorsString?[1])!).cgColor
            
        }
        
        var cell = collectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell
        
        if(lastSearch?.isSelected[indexPath.item] == false){
            
            // selected
            
            lastSearch?.isSelected[indexPath.item] = true
            
            cell.circleView.layer.insertSublayer(setGradientLayer(myView: cell.circleView, color1: c1, color2: c2), below: cell.circleView.layer.sublayers?.last)
            
            cell.image.image = setTintGradient(image: cell.image.image!, c: [UIColor.white.cgColor ,UIColor.white.cgColor])
            
        }else{
            
            //deselected
            
            lastSearch?.isSelected[indexPath.item] = false
            
            cell.circleView.layer.insertSublayer(setGradientLayer(myView: cell.circleView, color1: UIColor.white.cgColor, color2: UIColor.white.cgColor), below: cell.circleView.layer.sublayers?.last)
            
            cell.image.image = setTintGradient(image: cell.image.image!, c: [c1,c2])
            
        }
        
        
        //if lastSearch.isSelected != lastSearched
        // set doSearchButton green and enable it
        //else disable doSearchButton
        
        if(isNewSeach(ls: lastSearch?.isSelected) == true){
            
            doSearchButton.normalBackgroundColor = UIColor(hex: "4bb272")
            
            doSearchButton.normalTextColor = UIColor.white
            
            doSearchButton.isEnabled = true
            
        }else{
            
            doSearchButton.normalBackgroundColor = UIColor.white
            
            doSearchButton.normalTextColor = UIColor.black
            
            doSearchButton.isEnabled = false
            
            
        }
        
        
        
        print("You selected cell #\(indexPath.item)!")
    }
    
    
    
    
    
    
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //SORT
    
    func maxCoinSort(){

        var result : [BeaconListData] = [BeaconListData]()
        
        while (GlobalFields.BEACON_LIST_DATAS?.count)! > 0 {
            
            let index = findMax(datas: GlobalFields.BEACON_LIST_DATAS!)
            
            result.append((GlobalFields.BEACON_LIST_DATAS?[index])!)
            
            GlobalFields.BEACON_LIST_DATAS?.remove(at: index)
            
        }
        
        GlobalFields.BEACON_LIST_DATAS = result
        
        self.rightTable.reloadData()
        
        self.leftTable.reloadData()
        
    }
    
    func findMax(datas : [BeaconListData]) -> Int{
        
        var max : BeaconListData = (datas[0])
        
        var index : Int = 0
        
        for i in 0...datas.count - 1 {
            
            if(max.coin == nil){
                
                max.coin = "0"
                
            }
            if(datas[i].coin == nil){
                
                datas[i].coin = "0"
                
            }
            
            
            if(Int(datas[i].coin!)! > Int(max.coin!)!){
                
                max = datas[i]
                index = i
                
            }
            
            
        }
        
        return index
        
    }
    
    
    
    func maxNearSort(){
        
        var result : [BeaconListData] = [BeaconListData]()
        
        while (GlobalFields.BEACON_LIST_DATAS?.count)! > 0 {
            
            let index = findMaxNear(datas: GlobalFields.BEACON_LIST_DATAS!)
            
            result.append((GlobalFields.BEACON_LIST_DATAS?[index])!)
            
            GlobalFields.BEACON_LIST_DATAS?.remove(at: index)
            
        }
        
        GlobalFields.BEACON_LIST_DATAS = result
        
        self.rightTable.reloadData()
        
        self.leftTable.reloadData()
        
    }
    
    func findMaxNear(datas : [BeaconListData]) -> Int{
        
        var max : BeaconListData = (datas[0])
        
        var index : Int = 0
        
        for i in 0...datas.count - 1 {
            
            if(max.distance == nil){
                
                max.distance = "0"
                
            }
            if(datas[i].distance == nil){
                
                datas[i].distance = "0"
                
            }
            
            if(Double(datas[i].distance!)! < Double(max.distance!)!){
                
                max = datas[i]
                index = i
                
            }
            
            
        }
        
        return index
        
    }
    
    func showSortView(){
        
        hiddenSearchView()
        
        searchIsPressed = false
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.sortView.alpha = 1
            
            self.sortView.frame.size.height = 180
            
            self.blurView.alpha = 1
            
            self.mostPopularButton.frame.size.height = 30
            
            self.mostPopularButton.frame.origin.y = 110
            
            self.newestButton.frame.size.height = 30
            
            self.newestButton.frame.origin.y = 110
            
            self.nearestButton.frame.size.height = 30
            
            self.nearestButton.frame.origin.y = 35
            
            self.maxCoinButton.frame.size.height = 30
            
            self.maxCoinButton.frame.origin.y = 35
            
            
        }, completion : nil )
        
    }
    
    func hiddenSortView(){
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.sortView.alpha = 0
            
            self.sortView.frame.size.height = 0
            
            self.blurView.alpha = 0
            
            self.mostPopularButton.frame.size.height = 0
            
            self.newestButton.frame.size.height = 0
            
            self.nearestButton.frame.size.height = 0
            
            self.maxCoinButton.frame.size.height = 0
            
        }, completion : nil )
        
    }
    
    
    
    @IBAction func popupSort(_ sender: Any) {
        
        if(isShowSortView){
            
            hiddenSortView()
            
            isShowSortView = false
            
        }else{
            
            showSortView()
            
            isShowSortView = true
            
            
        }
        
    }
    
    
    @IBAction func sortMaxCoin(_ sender: Any) {
        
        maxCoinSort()
        
        hiddenSortView()
        
    }
    
    @IBAction func nearest(_ sender: Any) {
        
        maxNearSort()
        
        hiddenSortView()
        
    }
    
    @IBAction func mostPopular(_ sender: Any) {
        
        hiddenSortView()
        
    }

    @IBAction func newest(_ sender: Any) {
        
        hiddenSortView()
        
    }
    
    
    
    
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    func setTintGradient(image: UIImage , c : [CGColor] ) -> UIImage{
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale);
        let context = UIGraphicsGetCurrentContext()
        context!.translateBy(x: 0, y: image.size.height)
        context!.scaleBy(x: 1.0, y: -1.0)
        
        context!.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width : image.size.width, height : image.size.height)
        
        // Create gradient
        
        let colors = c as CFArray
        let space = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: space, colors: colors, locations: nil)
        
        // Apply gradient
        
        context!.clip(to: rect, mask: image.cgImage!)
        context!.drawLinearGradient(gradient!, start: CGPoint(x:0, y:0), end: CGPoint(x:0,y: image.size.height), options: CGGradientDrawingOptions(rawValue: 0))
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return gradientImage!
        
    }
    
    
    
    func setGradientLayer(myView: UIView , color1: CGColor , color2: CGColor) -> CALayer {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = myView.bounds
        
        gradientLayer.colors = [color1, color2]
        
        gradientLayer.startPoint = CGPoint(x: 0,y: 0.5)
        
        gradientLayer.endPoint = CGPoint(x: 1,y: 0.5)
        
        return gradientLayer
        
    }

    
    @IBAction func map(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "MapViewController"))! as! MapViewController
            
            self.addChildViewController(vc)
            
            vc.view.frame = CGRect(x:0,y: 0,width: self.container.frame.size.width, height: self.container.frame.size.height);
            
            var counter = 0
            
            vc.pinsImage.removeAll()
            
            for c in GlobalFields.CATEGORIES_LIST_DATAS! {
                
                if(c.url_icon_map?.url != nil){
         
                    vc.pinsImage[c.category_code!] = c.url_icon_map
                            
                    counter += 1

                }
                
            }
            
            var b : Bool = true
            
            while b {
                
                sleep(1)
                
                if(counter == GlobalFields.CATEGORIES_LIST_DATAS!.count){
                    
                    self.container.addSubview(vc.view)
                    
                    vc.didMove(toParentViewController: self)
                    
                    self.navigationBar.alpha = 0
                    
                    self.rightTable.alpha = 0
                    
                    self.leftTable.alpha = 0
                    
                    b = false
                    
                }
                
            }
            
            
//            self.container.addSubview(vc.view)
//
//            vc.didMove(toParentViewController: self)
//
//            self.navigationBar.alpha = 0
//
//            self.rightTable.alpha = 0
//            
//            self.leftTable.alpha = 0
            
        }, completion: nil)
        
        
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
