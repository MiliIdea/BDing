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
import CCBottomRefreshControl
import Hero
import CellAnimator


class AlarmViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource , UICollectionViewDataSource, UICollectionViewDelegate , ShowcaseDelegate{
    
    @IBOutlet weak var rightTable: UITableView!
    
    @IBOutlet weak var leftTable: UITableView!
    
    @IBOutlet weak var rightWidth: NSLayoutConstraint!
    
    @IBOutlet weak var leftWidth: NSLayoutConstraint! // left leading -172
    
    @IBOutlet weak var leftOrginalWidth: NSLayoutConstraint!
    
    @IBOutlet weak var changeModeButton: UIButton!
    
    @IBOutlet weak var lowInternetView: UIView!
    
  
    @IBOutlet var container: UIView!
    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var doSearchButton: DCBorderedButton!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var mapButton: UIButton!
    
    @IBOutlet weak var searchButtonView: UIButton!
    
    // SORT 
    
    @IBOutlet weak var sortView: UIView!
    
    @IBOutlet weak var sortButton: UIButton!
    
    @IBOutlet weak var nearestButton: DCBorderedButton!
    
    @IBOutlet weak var maxCoinButton: DCBorderedButton!
    
    @IBOutlet weak var mostPopularButton: DCBorderedButton!
    
    @IBOutlet weak var newestButton: DCBorderedButton!
    
    var isShowSortView : Bool = false
    
    let showcase = MaterialShowcase()
    
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
        
        var text : String = ""
        
        var prePic : [UIImage?]? = [UIImage]()

        var isSelected : [Bool] = [Bool]()
    }
    
    var lastSearch : LastSearchStruct? = nil
    
    var userRefreshControl : UIRefreshControl = UIRefreshControl.init()
    
    var showcaseCounter : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortView.alpha = 0
        
        searchIsPressed = false
        
        searchOrigin = self.doSearchButton.frame.origin.y
        self.searchView.frame.size.height = 0
        self.collectionView.frame.size.height = 0
        self.collectionView.alpha = 0
        self.doSearchButton.alpha = 0
        self.searchTextField.alpha = 0
        
//        var s: String? = GlobalFields.PROFILEDATA?.name
        
        let s2: String? = "دنبال چی می گردی؟ کجا می خوای بری؟"
//        
//        if(s == nil){
//            
//            s = ""
//            
//        }else{
//            
//            s2?.appending(" ")
//            
//        }
        
        self.searchTextField.placeholder = s2
        self.clearButton.alpha = 0
        self.blurView.alpha = 0
        
        if(view != nil){
            
            loading.frame(forAlignmentRect: (view?.frame)!)
            
            loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            view?.addSubview(loading)
            
            loading.hidesWhenStopped = true
            
            loading.frame.origin.x = (view?.frame.width)! / 2
            
            loading.frame.origin.y = (view?.frame.height)! / 2
            
        }
        
        loading.startAnimating()
        doingSearch("first")
        
        showcase.delegate = self
        
        
        
    }
    
    
    
    func dismissed() {
        
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            
            self.showcase.setTargetView(view: self.searchButtonView) // always required to set targetView
            self.showcase.primaryText = "جستجو"
            self.showcase.secondaryText = "در بین دسته بندی‌های مختلف، با جستجوی نام و یا آدرس، مکان‌های مورد علاقه خود را پیدا کنید."
            MyFont().setFontForAllView(view: self.showcase)
            
            self.showcase.show(id: "2",completion: {
                _ in
                self.view.isUserInteractionEnabled = true
            })
            
            
        }
        self.view.isUserInteractionEnabled = true
    }

    
    func firstLoad(){
        MyFont().setFontForAllView(view: view)
        
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
        
        self.rightTable.register(UINib(nibName: "IndexHomeTableViewCell", bundle: nil), forCellReuseIdentifier: "indexHomeTableCellID")
        
        self.leftTable.register(UINib(nibName: "IndexHomeTableViewCell", bundle: nil), forCellReuseIdentifier: "indexHomeTableCellID")
        
        
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
        
        self.searchTextField.addTarget(self, action: #selector(AlarmViewController.searchFieldChange), for: UIControlEvents.editingChanged)
        
        
        userRefreshControl.triggerVerticalOffset = 100
        
        userRefreshControl.addTarget(self, action: #selector(AlarmViewController.loadHomeTable), for: UIControlEvents.valueChanged)
        
        self.rightTable.bottomRefreshControl = userRefreshControl
        
        rightTable.heroModifiers = [.cascade]
        
        leftTable.heroModifiers = [.cascade]
        
        changeColorOfSort(i: 2)
        
        searchButtonView.setImage(searchButtonView.currentImage?.imageWithColor(tintColor: UIColor.init(hex: "455a64")).withRenderingMode(.alwaysOriginal), for: .normal)
        
        sortButton.setImage(sortButton.currentImage?.imageWithColor(tintColor: UIColor.init(hex: "455a64")).withRenderingMode(.alwaysOriginal), for: .normal)
        
        mapButton.setImage(mapButton.currentImage?.imageWithColor(tintColor: UIColor.init(hex: "455a64")).withRenderingMode(.alwaysOriginal), for: .normal)
        
        changeModeButton.setImage(changeModeButton.currentImage?.imageWithColor(tintColor: UIColor.init(hex: "455a64")).withRenderingMode(.alwaysOriginal), for: .normal)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Home")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        (UIApplication.shared.delegate as! AppDelegate).locationManager.startRangingBeacons(in: (UIApplication.shared.delegate as! AppDelegate).beaconRegion)
        
        if(self.customerHomeTableCells.count == 0){
           
            loadHomeTable()
            
            self.rightTable.reloadData()
            
            self.leftTable.reloadData()
            
        }
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            self.showcase.setTargetView(tabBar: (self.tabBarController?.tabBar)! , itemIndex: 4) // always required to set targetView
            self.showcase.primaryText = "خانه"
            self.showcase.secondaryText = " در این صفحه آدرس و جزئیات کسب کارهایی را مشاهده می‌کنید که با حضور در محل آنها، می‌توانید امتیاز (دینگ) جمع کنید."
            MyFont().setFontForAllView(view: self.showcase)
            
            self.showcase.show(id: "1",completion: {
                _ in
                // You can save showcase state here
                // Later you can check and do not show it again
                
                self.view.isUserInteractionEnabled = true
                
            })
            
            
        }
        
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
        
        AlarmViewController.mode = !AlarmViewController.mode
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {

            if !AlarmViewController.mode {
                
                self.changeModeButton.setImage(UIImage.init(named: "mode one")?.imageWithColor(tintColor: UIColor.init(hex: "455a64")).withRenderingMode(.alwaysOriginal), for: .normal)
                
                
                for c in 1...self.rightTable.numberOfRows(inSection: 0) {
                    
                    if ((c-1) % 2 != 0) {
                        
                        (self.rightTable.cellForRow(at: IndexPath(row: c-1, section: 0)) as? IndexHomeTableViewCell)?.alpha = 0
                        
                    }
                    
                    (self.leftTable.cellForRow(at: IndexPath(row: c-1, section: 0)) as? IndexHomeTableViewCell)?.setLast(screenWidth: self.view.frame.width)
                    
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
                
                self.changeModeButton.setImage(UIImage.init(named: "mode two")?.imageWithColor(tintColor: UIColor.init(hex: "455a64")).withRenderingMode(.alwaysOriginal), for: .normal)
                
                
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
                    
                    (self.rightTable.cellForRow(at: IndexPath(row: c-1, section: 0)) as? IndexHomeTableViewCell)?.setFirst(screenWidth: self.view.frame.width)
                    
                }
                
                self.leftTable.contentOffset = self.rightTable.contentOffset
                
                
                self.view.layoutIfNeeded()
                
                
            }else {
                
                print(self.leftTable.contentOffset)
                print(self.rightTable.contentOffset)
                
//                if(self.rightTable.isDragging || self.leftTable.isDragging){
                
                    self.rightTable.contentOffset.y = 0
                    self.leftTable.contentOffset.y = 0
                
                //resizing table double
                self.leftWidth.constant = -16 + 2
                
                self.rightTable.frame.size.width = self.view.frame.width / 2
                
                self.leftTable.frame.size.width = self.view.frame.width / 2
                
                self.rightWidth.constant =  self.leftTable.frame.width + 2
                
                self.leftOrginalWidth.constant = self.view.frame.width / 2
                
                for c in 1...self.rightTable.numberOfRows(inSection: 0) {
                    
                    (self.rightTable.cellForRow(at: IndexPath(row: c-1, section: 0)) as? IndexHomeTableViewCell)?.setLast(screenWidth: self.view.frame.width)
                    (self.leftTable.cellForRow(at: IndexPath(row: c-1, section: 0)) as? IndexHomeTableViewCell)?.setLast(screenWidth: self.view.frame.width)
                    
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
        
            print(" =======>>>>>> ",indexPath.row)
            
            let cell = self.rightTable.dequeueReusableCell(withIdentifier: "indexHomeTableCellID" , for: indexPath) as! IndexHomeTableViewCell
            
            let tableCell = customerHomeTableCells[indexPath.row]
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                cell.customerName.text = tableCell.customerName
                cell.customerCampaignTitle.text = tableCell.customerCampaignTitle
                cell.customerDistanceToMe.text = tableCell.customerDistanceToMe
            
            })
            
            if(tableCell.preCustomerImage != nil){
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    cell.customerThumbnail.image = tableCell.preCustomerImage
                    
                })
                
            }
            
            ///////cat icon
            if(tableCell.customerCategoryIcon != nil){
                
                DispatchQueue.main.async(execute: { () -> Void in
                    autoreleasepool { () -> () in
    
                        cell.customerCategoryThumbnail.image = tableCell.customerCategoryIcon
    
                    }
                })
                
            }else{
                if((GlobalFields.BEACON_LIST_DATAS?.count)! - 1 >= indexPath.row ){
                    let cat = findCategory(catID: tableCell.categoryID)
                    
                    if(cat != nil){
                        
                        LoadPicture().proLoad(view: cell.customerCategoryThumbnail, picModel: (cat?.url_icon)!) { resImage in
                            
                            cell.customerCategoryThumbnail.image = resImage

                            self.customerHomeTableCells[indexPath.row].customerCategoryIcon = resImage
                            
                        }
                        
                        
                    }
                }
            }
            
            ///////
            DispatchQueue.main.async(execute: { () -> Void in
                
                cell.customerCampaignCoin.text = tableCell.customerCoinValue
                cell.customerCampaignDiscount.text = tableCell.customerDiscountValue
                cell.customerCategoryThumbnail.image = tableCell.customerCategoryIcon
                cell.coinThumbnail.image = tableCell.customerCoinIcon
                cell.discountThumbnail.image = tableCell.customerDiscountIcon
                //////////
                if(AlarmViewController.mode){
                    cell.viewH.constant = self.view.frame.width * 8.5 / 32
                    cell.setFirst(screenWidth: self.view.frame.width)
                }else{
                    cell.setLast(screenWidth: self.view.frame.width)
                }
            })
            
            cell.heroModifiers = [.fade, .scale(0.5)]
            cell.selectionStyle = .none
            return cell
            
        }else if tableView == leftTable{
            
            let cell2 = self.leftTable.dequeueReusableCell(withIdentifier: "indexHomeTableCellID" , for: indexPath) as! IndexHomeTableViewCell
            
            let tableCell = customerHomeTableCells[indexPath.row * 2 + 1]
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                cell2.customerName.text = tableCell.customerName
                cell2.customerCampaignTitle.text = tableCell.customerCampaignTitle
                cell2.customerDistanceToMe.text = tableCell.customerDistanceToMe
            
            })
            if(tableCell.preCustomerImage != nil){
                
                DispatchQueue.main.async(execute: { () -> Void in
                    autoreleasepool { () -> () in
                        
                        cell2.customerThumbnail.image = tableCell.preCustomerImage
                    
                    }
                })
                
            }
//            else{
//
//                
//                LoadPicture().proLoad(view: cell2.customerThumbnail, picModel: tableCell.customerImage!) { resImage in
//                    
//                    cell2.customerThumbnail.image = resImage
//                    
//                    self.customerHomeTableCells[indexPath.row].preCustomerImage = resImage
//                    
//                }
//
//                
//            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                cell2.customerCampaignCoin.text = tableCell.customerCoinValue
                cell2.customerCampaignDiscount.text = tableCell.customerDiscountValue
                cell2.customerCategoryThumbnail.image = tableCell.customerCategoryIcon
                cell2.coinThumbnail.image = tableCell.customerCoinIcon
                cell2.discountThumbnail.image = tableCell.customerDiscountIcon
                ////////////
            
                cell2.viewH.constant = self.view.frame.width * 8.5 / 32
                
                cell2.setLast(screenWidth: self.view.frame.width)
            })
            
            cell2.heroModifiers = [.fade, .scale(0.5)]
            cell2.selectionStyle = .none
            return cell2
            
        }
        
        return UITableViewCell()
        
    }
    
    func findCategory(catID : String!) -> CategoryListData?{
        
        for c in GlobalFields.CATEGORIES_LIST_DATAS! {
            
            if(c.category_code == catID){
                
                return c
                
            }
            
        }
        
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == rightTable{
            if(AlarmViewController.mode){
                
                return self.view.frame.width * 8.5 / 32
                
            }else{
                
                if(indexPath.row % 2 != 0){
                    
                    return 0
                    
                }
                return self.view.frame.width * CGFloat(0.46875)
            }
            
        }else{
            
            return self.view.frame.width * CGFloat(0.46875)
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        CellAnimator.animateCell(cell: cell, withTransform: CellAnimator.TransformFlip, andDuration: 0.3)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        
        if(tableView == rightTable){
            
            rightTable.deselectRow(at: indexPath, animated: true)
            
            performSegue(withIdentifier: "rightCellDetailSegue", sender: rightTable.cellForRow(at: indexPath))
            
            
        }else {
            
            leftTable.deselectRow(at: indexPath, animated: true)
            
            performSegue(withIdentifier: "leftCellDetailSegue", sender: leftTable.cellForRow(at: indexPath))
            
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

    
    var lazyLoaded : Int = 0
    
    let loading : UIActivityIndicatorView = UIActivityIndicatorView()
    
    func loadHomeTable(){
    
        loading.startAnimating()
        
//        DispatchQueue.global(qos: .userInteractive).async {
            //create customer Home Table Cell from web service :)
            let image : UIImage = UIImage(named:"mal")!
        
        let locManager = CLLocationManager()
        
        locManager.requestAlwaysAuthorization()
        
        var currentLocation = CLLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            currentLocation = locManager.location!
            
        }
        
            if(GlobalFields.BEACON_LIST_DATAS != nil){
                
                var count = 0
                
                var end = self.lazyLoaded + 9
                
                if((GlobalFields.BEACON_LIST_DATAS?.count)! - 1 < end){
                    
                    end = (GlobalFields.BEACON_LIST_DATAS?.count)! - 1
                    
                }
                
                if((GlobalFields.BEACON_LIST_DATAS?.count)! <= lazyLoaded){
                    
                    lazyLoaded = (GlobalFields.BEACON_LIST_DATAS?.count)! - 1
                    
                }
                
                for obj in (GlobalFields.BEACON_LIST_DATAS?[self.lazyLoaded...end])! {
                    
                    let a = CustomerHomeTableCell.init(uuidMajorMinorMD5: nil,preCustomerImage: nil ,customerImage: obj.url_icon, customerCampaignTitle: obj.title!, customerName: obj.customer_title!, customerCategoryIcon: nil, customerDistanceToMe: String(describing: round((obj.distance ?? 0) * 100) / 100), customerCoinValue: obj.coin ?? "0", customerDiscountValue: obj.discount ?? "%0", tell: obj.customer_tell ?? "" ,address: obj.customer_address ?? "" , text: obj.text ?? "" ,workTime: obj.customer_work_time ?? "" ,website: obj.cusomer_web ?? "" ,customerBigImages: obj.url_pic, categoryID: obj.category_id, beaconCode : obj.beacon_code , campaignCode : obj.campaign_code, lat : obj.lat , long : obj.long)
                    
                    if((Double(obj.lat!))! == 0 || (Double(obj.long!))! == 0){
                        
                        obj.distance = 0
                        a.customerDistanceToMe = "-"
                        
                    }else if(currentLocation.coordinate.latitude != 0){
                        
                        let dis = String(format: "%.2f", currentLocation.distance(from: CLLocation.init(latitude: (Double(obj.lat!))!, longitude: (Double(obj.long!))!))/1000)
                        
                        obj.distance = Double(dis)
                        a.customerDistanceToMe = dis
                        
                    }
                    
                    
                    a.preCustomerImage = UIImage.init(named: "default")
                    
                    if(a.customerImage?.url != nil){
                        
                        LoadPicture().proLoad(view: nil , picModel: a.customerImage!) {
                            
                            resImage in
                            
                            a.preCustomerImage = resImage
                            
                            for cust in self.customerHomeTableCells{
                                
                                if( a.customerImage?.url == cust.customerImage?.url ){
                                    
                                    if( a.customerImage?.code == cust.customerImage?.code ){
                                        
                                        cust.preCustomerImage = resImage
                                        
                                        if(self.rightTable != nil && self.rightTable.cellForRow(at: .init(row: self.customerHomeTableCells.index(of: cust)!, section: 0)) != nil  ){
                                            (self.rightTable.cellForRow(at: .init(row: self.customerHomeTableCells.index(of: cust)!, section: 0)) as! IndexHomeTableViewCell).customerThumbnail.image = resImage
                                            
                                        }
                                        
                                        break
                                    
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    if(customerHomeTableCells.count != GlobalFields.BEACON_LIST_DATAS?.count){
                        self.customerHomeTableCells.append(a)
                    }
                    count += 1
                    
                    if(count == 9){
                        
                        self.lazyLoaded += 9
                        
                        self.loading.stopAnimating()
                        
                        print("%%%%%%%%%%%%%%% count %%%%%%%%%%%%%%%%")
                        print(self.customerHomeTableCells.count)

                        
                        break
                        
                    }
                    
                }
                
            }
            
            print("%%%%%%%%%%%%%%% count %%%%%%%%%%%%%%%%")
            print(self.customerHomeTableCells.count)
        
//        if(self.customerHomeTableCells.count == 0){
//            
//            self.rightTable.alpha = 0
//            
//            self.leftTable.alpha = 0
//            
//            self.lowInternetView.alpha = 1
//            
//            self.loading.alpha = 0
//            
//            return
//            
//        }
        
            self.rightTable.reloadData()
            
            self.leftTable.reloadData()
            
            self.loading.stopAnimating()
        DispatchQueue.global(qos: .userInteractive).async {
            DispatchQueue.main.async {
                self.userRefreshControl.endRefreshing()
            }
        }

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == rightTable){
            leftTable.contentOffset = rightTable.contentOffset
//            let  height = scrollView.frame.size.height
//            let contentYoffset = scrollView.contentOffset.y
//            let distanceFromBottom = scrollView.contentSize.height - contentYoffset
//            if distanceFromBottom == height {
//                loadHomeTable()
//            }
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

        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Search")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
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
        
        searchTextField.text = ""
        
        if(isNewSeach(ls: lastSearch?.isSelected) == true){
            
            doSearchButton.normalBackgroundColor = UIColor(hex: "4bb272")
            
            doSearchButton.normalTextColor = UIColor.white
            
            searchTextField.text = ""
            
            doSearchButton.isEnabled = true
            
        }else{
            
            doSearchButton.normalBackgroundColor = UIColor.white
            
            doSearchButton.normalTextColor = UIColor.black
            
            doSearchButton.isEnabled = false
            
            
        }
        
        
    }
    
    
    func searchFieldChange(){
        
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
    
        loading.startAnimating()
        
        self.view.isUserInteractionEnabled = false
        
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
        
        if(lat == "0" && long == "0"){
            
            long = String(51.4212297)
            
            lat = String(35.6329044)
            
        }
        
        var categoryList:[String] = [String]()
        
        if(self.isSearched.count > 0){
            for j in 0...(self.isSearched.count - 1) {
                
                if(self.lastSearch?.isSelected[j] == true){
                    
                    categoryList.append((GlobalFields.CATEGORIES_LIST_DATAS?[j].category_code)!)
                    
                }
                
            }
        }

        self.lastSearch?.text = self.searchTextField.text!
        
        print(BeaconListRequestModel(LAT: lat, LONG: long, REDIUS: String(GlobalFields.BEACON_RANG), SEARCH: searchTextField.text, CATEGORY: String(describing: categoryList), SUBCATEGORY: nil).getParams(allSearch : true))
        let manager = SessionManager.default2
        
        manager.request(URLs.getBeaconList , method: .post , parameters: BeaconListRequestModel(LAT: lat, LONG: long, REDIUS: String(GlobalFields.BEACON_RANG), SEARCH: searchTextField.text, CATEGORY: String(describing: categoryList), SUBCATEGORY: nil).getParams(allSearch : true), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            ///////////////////////////
            ///////////////////////////
            ///////////////////////////
            
            switch (response.result) {
            case .failure(let error):
                    
                    self.loading.stopAnimating()
                    
                    self.rightTable.alpha = 0
                    
                    self.leftTable.alpha = 0
                    
                    self.lowInternetView.alpha = 1
                    
                    self.view.isUserInteractionEnabled = true
                    
                    return
                    
                break
                
            default: break
                
            }
            
            ///////////////////////////
            ///////////////////////////
            ///////////////////////////
            
            self.rightTable.alpha = 1
            
            self.leftTable.alpha = 1
            
            self.lowInternetView.alpha = 0

            
            if let JSON = response.result.value {
                
                print("JSON ----------BEACON----------->>>> " , JSON)
                
                let obj = BeaconListResponseModel.init(json: JSON as! JSON)
                
                self.loading.stopAnimating()
                
                self.view.isUserInteractionEnabled = true
                
                if ( obj?.code == "200" ){
                    
                    GlobalFields.BEACON_LIST_DATAS = obj?.data
                    
                    if(self.isSearched.count > 0){
                        
                        for i in 0...(self.isSearched.count - 1) {
                            
                            self.isSearched[i] = (self.lastSearch?.isSelected[i])!
                            
                        }
                        
                    }
                    
                    self.lazyLoaded = 0
                    
                    self.customerHomeTableCells.removeAll()
                    
                    self.loadHomeTable()
                    
                    self.rightTable.reloadData()
                    
                    self.leftTable.reloadData()
                    
                    self.view.endEditing(true)
                    
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
                    
                    if(sender is String){
                        
                        if((sender as! String) == "first"){
                            self.sortView.alpha = 0
                            
                            self.searchIsPressed = false
                            
                            self.searchOrigin = self.doSearchButton.frame.origin.y
                            self.searchView.frame.size.height = 0
                            self.collectionView.frame.size.height = 0
                            self.collectionView.alpha = 0
                            self.doSearchButton.alpha = 0
                            self.searchTextField.alpha = 0
                            self.clearButton.alpha = 0
                            self.blurView.alpha = 0
                            self.firstLoad()
                            self.hiddenSearchView()
                            
                            
                        }
                        
                    }
                    
                    if(obj?.data == nil || obj?.data?.count == 0){
                        
                        Notifys().notif(message: "هیچ موردی یافت نشد!"){ alarm in
                            
                            self.present(alarm, animated: true, completion: nil)
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        
    }
    
    
    
    func isNewSeach(ls:[Bool]?) -> Bool{
        
        if(ls == nil){
            
            return false
            
        }
        
        for i in 0...(ls?.count)!-1 {
            
            if(ls?[i] != isSearched[i]){
                
                return true
                
            }
            
        }
        
        if(self.searchTextField.text != self.lastSearch?.text){
            
            return true
            
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
        
        customerHomeTableCells.removeAll()
        
        lazyLoaded = 0
  
        loadHomeTable()
        
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
    
    func mostPopular(){
        
        var result : [BeaconListData] = [BeaconListData]()
        
        while (GlobalFields.BEACON_LIST_DATAS?.count)! > 0 {
            
            let index = findMostPopular(datas: GlobalFields.BEACON_LIST_DATAS!)
            
            result.append((GlobalFields.BEACON_LIST_DATAS?[index])!)
            
            GlobalFields.BEACON_LIST_DATAS?.remove(at: index)
            
        }
        
        GlobalFields.BEACON_LIST_DATAS = result
        
        customerHomeTableCells.removeAll()
        
        lazyLoaded = 0
        
        loadHomeTable()
        
        self.rightTable.reloadData()
        
        self.leftTable.reloadData()
        
        
    }
    
    func findMostPopular(datas : [BeaconListData]) -> Int{
        
        var max : BeaconListData = (datas[0])
        
        var index : Int = 0
        
        for i in 0...datas.count - 1 {
            
            if(max.popular == nil){
                
                max.popular = "0"
                
            }
            if(datas[i].popular == nil){
                
                datas[i].popular = "0"
                
            }
            
            if(Double(datas[i].popular!)! > Double(max.popular!)!){
                
                max = datas[i]
                index = i
                
            }
            
            
        }
        
        return index
        
    }
    
    
    func newest(){
        
        var result : [BeaconListData] = [BeaconListData]()
        
        while (GlobalFields.BEACON_LIST_DATAS?.count)! > 0 {
            
            let index = findMaxNew(datas: GlobalFields.BEACON_LIST_DATAS!)
            
            result.append((GlobalFields.BEACON_LIST_DATAS?[index])!)
            
            GlobalFields.BEACON_LIST_DATAS?.remove(at: index)
            
        }
        
        GlobalFields.BEACON_LIST_DATAS = result
        
        customerHomeTableCells.removeAll()
        
        lazyLoaded = 0
        
        loadHomeTable()
        
        self.rightTable.reloadData()
        
        self.leftTable.reloadData()
        
    }
    
    
    func findMaxNew(datas : [BeaconListData]) -> Int{
        
        var max : BeaconListData = (datas[0])
        
        var index : Int = 0
        
        for i in 0...datas.count - 1 {
            
            if(max.start_date == nil){
                
                max.start_date = Date()
                
            }
            if(datas[i].start_date == nil){
                
                datas[i].start_date = Date()
                
            }
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "dd/MM/yyyy"
            
            formatter.calendar = Calendar(identifier: .gregorian)
            
            let d1 = datas[i].start_date!
            
            print(i)
            print(d1)
            
            let d2 = max.start_date!
            
            if(d1 > d2){
                
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
        
        customerHomeTableCells.removeAll()
        
        lazyLoaded = 0
        
        loadHomeTable()
        
        self.rightTable.reloadData()
        
        self.leftTable.reloadData()
        
    }
    
    func findMaxNear(datas : [BeaconListData]) -> Int{
        
        var max : BeaconListData = (datas[0])
        
        var index : Int = 0
        
        for i in 0...datas.count - 1 {
            
            if(max.distance == nil){
                
                max.distance = 0
                
            }
            if(datas[i].distance == nil){
                
                datas[i].distance = 0
                
            }
            
            
            if(datas[i].distance! < max.distance!){
                
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
            
            self.blurView.alpha = 0.85
            
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
            
        }){ completion in
         
            self.loading.stopAnimating()
            
            self.view.isUserInteractionEnabled = true
            
        }
        
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
        
        loading.startAnimating()
        
        self.view.isUserInteractionEnabled = false
        
        maxCoinSort()
        
        changeColorOfSort(i : 1)
        
        hiddenSortView()
        
    }
    
    @IBAction func nearest(_ sender: Any) {
        
        loading.startAnimating()
        
        self.view.isUserInteractionEnabled = false
        
        maxNearSort()
        
        changeColorOfSort(i : 3)
        
        hiddenSortView()
        
    }
    
    @IBAction func mostPopular(_ sender: Any) {
        
        loading.startAnimating()
        
        self.view.isUserInteractionEnabled = false
        
        mostPopular()
        
        changeColorOfSort(i : 4)
        
        hiddenSortView()
        
    }

    @IBAction func newest(_ sender: Any) {
        
        loading.startAnimating()
        
        self.view.isUserInteractionEnabled = false
        
        newest()
        
        changeColorOfSort(i : 2)
        
        hiddenSortView()
        
    }
    
    func changeColorOfSort(i : Int){
        
        maxCoinButton.backgroundColor = UIColor.white
        
        maxCoinButton.setTitleColor(UIColor.black, for: .normal)
        
        newestButton.backgroundColor = UIColor.white
        
        newestButton.setTitleColor(UIColor.black, for: .normal)
        
        nearestButton.backgroundColor = UIColor.white
        
        nearestButton.setTitleColor(UIColor.black, for: .normal)
        
        mostPopularButton.backgroundColor = UIColor.white
        
        mostPopularButton.setTitleColor(UIColor.black, for: .normal)
        
        switch i {
        case 1:
            
            maxCoinButton.backgroundColor = UIColor.init(hex: "2196f3")
            
            maxCoinButton.setTitleColor(UIColor.white, for: .normal)
            
            break
            
        case 2:
            
            newestButton.backgroundColor = UIColor.init(hex: "2196f3")
            
            newestButton.setTitleColor(UIColor.white, for: .normal)
            
            break
        
        case 3:
            
            nearestButton.backgroundColor = UIColor.init(hex: "2196f3")
            
            nearestButton.setTitleColor(UIColor.white, for: .normal)
            
            break
            
        case 4:
            
            mostPopularButton.backgroundColor = UIColor.init(hex: "2196f3")
            
            mostPopularButton.setTitleColor(UIColor.white, for: .normal)
            
            break
            
        default:
            break
        }
    
        
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

    var pinsImage : [String : UIImage] = [String : UIImage]()
    
    @IBAction func map(_ sender: Any) {

        
        pinsImage.removeAll()
        
        loading.activityIndicatorViewStyle = .whiteLarge
        
        loading.color = UIColor.black
        
        loading.startAnimating()
        
        self.view.isUserInteractionEnabled = false
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            for c in GlobalFields.CATEGORIES_LIST_DATAS! {
                
                if(c.url_icon_map?.url != nil){
                    
                    LoadPicture().proLoad(view: nil, picModel: c.url_icon_map!){resImage in
                        
                        self.pinsImage[c.category_code!] = resImage
         
                        if( self.pinsImage.count == GlobalFields.CATEGORIES_LIST_DATAS!.count){
                            
                            self.loading.stopAnimating()
                            
                            self.performSegue(withIdentifier: "homeMapSegue", sender: "")
                
                            self.view.isUserInteractionEnabled = true
                        }
                        
                    }
                    
                }
                
            }
        }

    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "rightCellDetailSegue"){
            (segue.destination as! DetailViewController).setup(data: customerHomeTableCells[(self.rightTable.indexPath(for: (sender as! IndexHomeTableViewCell))?.row)!], isPopup: false, rect: nil)
        }else if(segue.identifier == "leftCellDetailSegue"){
            
            (segue.destination as! DetailViewController).setup(data: customerHomeTableCells[(self.leftTable.indexPath(for: (sender as! IndexHomeTableViewCell))?.row)! * 2 + 1], isPopup: false, rect: nil)
            
        }else if(segue.identifier == "homeMapSegue"){
            
            (segue.destination as! MapViewController).pinsImage = pinsImage
            
        }
        
    }
    
    
    @IBAction func lowInternetAction(_ sender: Any) {
       
        
        self.lowInternetView.alpha = 0
        
        self.loading.alpha = 1
        
        self.loading.startAnimating()
        
        self.view.isUserInteractionEnabled = false
        
        doingSearch("first")
        
    }
    
    


}


