//
//  CategoryViewController.swift
//  BDingTest
//
//  Created by Milad on 2/19/17.
//  Copyright © 2017 Milad. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import Lottie

class CategoryViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    
    struct  SubCategories {
        var name: String!
        var image: PicModel?
        var numberOfMembers: Int!
        var preImage: UIImage?
        var visible : Bool
        var subCategoryCode : String
        
        init(preImage: UIImage?,name: String , image: PicModel? , numberOfMembers: Int , subCategoryCode: String) {
            self.name = name
            self.image = image
            self.preImage = preImage
            self.numberOfMembers = numberOfMembers
            self.visible = false
            self.subCategoryCode = subCategoryCode
        }
        
    }
    
    struct Section {
        var name: String!
        var image: PicModel?
        var items: [SubCategories]!
        var collapsed: Bool!
        var color1: CGColor!
        var color2: CGColor!
        var preImage: UIImage?
        var categoryCode : String
        
        init(preImage: UIImage?,name: String , image: PicModel?, items: [SubCategories], color1: CGColor , color2: CGColor , collapsed: Bool = false , categoryCode: String) {
            self.name = name
            self.items = items
            self.image = image
            self.preImage = preImage
            self.collapsed = collapsed
            self.color1 = color1
            self.color2 = color2
            self.categoryCode = categoryCode
        }
    }

    
    var sections = [Section]()
    
    var cache: NSCache<AnyObject, AnyObject> = NSCache()
    
    var animationView : LOTAnimationView?

    @IBOutlet weak var tableViewCategory: UITableView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet var container: UIView!
    
    @IBOutlet weak var loadingAnimationView: UIView!

    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async(){
            
            self.showLoadingAnim()
        
        }

    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableViewCategory.dataSource = self
        
        tableViewCategory.delegate = self
        
        self.animationView = LOTAnimationView(name: "finall")
        
        self.animationView?.frame.size.height = 50
        
        self.animationView?.frame.size.width = 50
        
        self.animationView?.frame.origin.y = self.view.frame.height / 2 - 25
        
        self.animationView?.frame.origin.x = self.view.frame.width / 2 - 25
        
        self.animationView?.contentMode = UIViewContentMode.scaleAspectFit
        
        self.animationView?.alpha = 1
        
        self.animationView?.layer.zPosition = 1
        
        self.animationView?.animationSpeed = 4
        
        self.animationView?.loopAnimation = true
        
        self.tableViewCategory.alpha = 0
        
        DispatchQueue.main.async(){
            
            self.loadCategoryTable()
            
            self.tableViewCategory.reloadData()
            
        }

        self.cache = NSCache()
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.animationView?.pause()
        
        self.animationView?.alpha = 0
        
        self.tableViewCategory.alpha = 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = sections.count
        
        for section in sections {
            
            if(!section.collapsed){
                
                for sub in section.items{
                    
                    if(sub.visible == true){
                        
                        count += 1
                        
                    }
                    
                }
//                count += section.items.count
                
            }
            
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(getExpandedSection() != -1 && indexPath.row > getExpandedSection() && indexPath.row <= (getExpandedSection() + sections[getExpandedSection()].items.count) ){
            
            let cell2 =  tableView.dequeueReusableCell(withIdentifier: "cell2") as? CategoryTableViewCell2
            
            var dataCell2 = sections[getExpandedSection()].items[indexPath.row - getExpandedSection()-1]
            
            cell2?.labelViewCell2.text = dataCell2.name
            
            let myImage2 = UIImage(named:"profile_pic")?.imageWithColor(tintColor: UIColor.white)
            
            cell2?.iconView.image = myImage2
            
            cell2?.setLayers(image: myImage2!)
            
            cell2?.labelNumOfItemsCell2.text = String(dataCell2.numberOfMembers)
            
            if(dataCell2.name  == sections[getExpandedSection()].items[sections[getExpandedSection()].items.count - 1].name){
                
                print(indexPath.row)
                print(getExpandedSection())
                
                setCurve(isLast: true, cell: cell2!)
                
            }else{
                
                setCurve(isLast: false, cell: cell2!)
                
            }
            
            if(dataCell2.preImage != nil){
                
                cell2?.iconView.image = dataCell2.preImage?.imageWithColor(tintColor: UIColor.white)
                
                cell2?.iconView.contentMode = UIViewContentMode.scaleAspectFit
                
            }else{
                
                var im: UIImage? = loadImage(picModel: dataCell2.image!)
                
                if(im != nil){
                    
                    im = im?.imageWithColor(tintColor: UIColor.white)
                    
                    dataCell2.preImage = im
                    
                    cell2?.iconView.image = im
                    
                    cell2?.iconView.contentMode = UIViewContentMode.scaleAspectFit
                    
                }else{
                    
                    request("http://"+(dataCell2.image?.url)! ,method: .post ,parameters: BeaconPicRequestModel(CODE: dataCell2.image?.code, FILE_TYPE: dataCell2.image?.file_type).getParams(), encoding : JSONEncoding.default).responseJSON { response in
                        
                        if let image = response.result.value {
                            
                            let obj = PicDataModel.init(json: image as! JSON)
                            
                            let imageData = NSData(base64Encoded: (obj?.data!)!, options: .ignoreUnknownCharacters)
                            
                            var coding: String = (dataCell2.image?.url)!
                            
                            coding.append((dataCell2.image?.code)!)
                            
                            SaveAndLoadModel().save(entityName: "IMAGE", datas: ["imageCode": coding.md5() , "imageData": obj?.data!])
                            
                            self.cache.setObject(imageData!, forKey: coding.md5() as AnyObject)
                            
                            var pic = UIImage(data: imageData as! Data)
                            
                            pic = pic?.imageWithColor(tintColor: UIColor.white)
                            
                            dataCell2.preImage = pic
                            
                            cell2?.iconView.image = pic
                            
                            cell2?.iconView.contentMode = UIViewContentMode.scaleAspectFit
                            
                        }
                    }
                    
                }
                
            }
            
            cell2?.setLayout()
            
            return cell2!
            
            
        }else{
            
            
            let myCell =  tableView.dequeueReusableCell(withIdentifier: "cell1") as? CategoryTableViewCell1
            
            myCell?.imageViewToggle.image = myCell?.imageViewToggle.image?.imageWithColor(tintColor: UIColor.lightGray)
            
            myCell?.imageViewToggle.tintColor = UIColor.lightGray
            
            myCell?.labelViewCell1.text = sections[getSectionIndex(row: indexPath.row)].name
            
//            myCell!.imageViewCell1.layer.zPosition = 2
//            
//            myCell!.imageViewCell1.frame.origin.y = 0
//            
//            myCell!.imageViewCell1.frame.size.height = 61
            
            DispatchQueue.main.async(execute: { () -> Void in
            myCell!.imageViewCell1.layer.addSublayer(self.setGradientLayer(myView: myCell!.imageViewCell1, color1: self.sections[self.getSectionIndex(row: indexPath.row)].color1 , color2: self.sections[self.getSectionIndex(row: indexPath.row)].color2))
            
            })
            myCell?.imageViewToggle.tintColor = UIColor.lightGray
            
            if(sections[getSectionIndex(row: indexPath.row)].collapsed == true){
                
                setSelectedCell(isSelected: false, cell: myCell!)
                
            }else{
                
                setSelectedCell(isSelected: true, cell: myCell!)
                
            }
            
            
            ////////////////////////////////////////////////////////////
            
            if(sections[getSectionIndex(row: indexPath.row)].preImage != nil){
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    myCell?.imageViewCell1.image = self.sections[self.getSectionIndex(row: indexPath.row)].preImage
                    
                    // set image layer
                    
                    let myLayer = CALayer()
                    
                    let pic = self.sections[self.getSectionIndex(row: indexPath.row)].preImage
                    
                    let myImage = pic?.imageWithColor(tintColor: UIColor.white)
                    
                    self.sections[self.getSectionIndex(row: indexPath.row)].preImage = myImage
                    
                    let rect = myCell!.imageViewCell1.bounds
                    
                    myLayer.frame = CGRect(x: rect.minX + rect.width * 0.25, y: rect.minY + rect.height * 0.25, width: rect.width * 0.5, height: rect.height * 0.5)
                    
                    myLayer.contents = myImage?.cgImage
                    
                    myCell?.imageViewCell1.layer.addSublayer(myLayer)
                })
                

                
            }else {
                
                let im : UIImage? = loadImage(picModel: sections[getSectionIndex(row: indexPath.row)].image!)
                
                if(im != nil){
                    
                    let myL = CALayer()
                    
                    let myI = im?.imageWithColor(tintColor: UIColor.white)
                    
                    self.sections[self.getSectionIndex(row: indexPath.row)].preImage = myI
                    
                    let rect = myCell!.imageViewCell1.bounds
                    
                    myL.frame = CGRect(x: rect.minX + rect.width * 0.25, y: rect.minY + rect.height * 0.25, width: rect.width * 0.5, height: rect.height * 0.5)
                    
                    myL.contents = myI?.cgImage
                    
                    myCell?.imageViewCell1.layer.addSublayer(myL)
                    
                    myCell?.imageViewCell1.contentMode = UIViewContentMode.scaleAspectFit
                    
                } else if (sections[getSectionIndex(row: indexPath.row)].image?.url != nil){
                    
                    var tempCode = sections[getSectionIndex(row: indexPath.row)].image?.url
                    
                    tempCode?.append((sections[getSectionIndex(row: indexPath.row)].image?.code)!)
                    
                    let result: String? = isThereThisPicInDB(code: (tempCode?.md5())!)
                    
                    if(result == nil){
                        
                        request("http://"+(sections[getSectionIndex(row: indexPath.row)].image?.url)! ,method: .post ,parameters: BeaconPicRequestModel(CODE: sections[getSectionIndex(row: indexPath.row)].image?.code, FILE_TYPE: sections[getSectionIndex(row: indexPath.row)].image?.file_type).getParams(), encoding : JSONEncoding.default).responseJSON { response in
                            
                            if let image = response.result.value {
                                
                                let obj = PicDataModel.init(json: image as! JSON)
                                
                                let imageData = NSData(base64Encoded: (obj?.data!)!, options: .ignoreUnknownCharacters)
                                
                                var coding: String = (self.sections[self.getSectionIndex(row: indexPath.row)].image?.url)!
                                
                                coding.append((self.sections[self.getSectionIndex(row: indexPath.row)].image?.code)!)
                                
                                SaveAndLoadModel().save(entityName: "IMAGE", datas: ["imageCode": coding.md5() , "imageData": obj?.data!])
                                
                                self.cache.setObject(imageData!, forKey: coding.md5() as AnyObject)
                                
                                //                                         set image layer
                                
                                let myLayer = CALayer()
                                
                                let pic = UIImage(data: imageData as! Data)
                                
                                let myImage = pic?.imageWithColor(tintColor: UIColor.white)
                                
                                self.sections[self.getSectionIndex(row: indexPath.row)].preImage = myImage
                                
                                let rect = myCell!.imageViewCell1.bounds
                                
                                myLayer.frame = CGRect(x: rect.minX + rect.width * 0.25, y: rect.minY + rect.height * 0.25, width: rect.width * 0.5, height: rect.height * 0.5)
                                
                                myLayer.contents = myImage?.cgImage
                                
                                myCell?.imageViewCell1.layer.addSublayer(myLayer)
                                
                                myCell?.imageViewCell1.contentMode = UIViewContentMode.scaleAspectFit
                                
                            }
                            
                        }
                    }
                }
            }
            
            myCell?.layer.zPosition = 1
            
            return myCell!
            
        }

        
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
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if(getExpandedSection() != -1 && indexPath.row > getExpandedSection() && indexPath.row < (getExpandedSection() + sections[getExpandedSection()].items.count) ){
         
            return UIScreen.main.bounds.height / 8 - 10
            
        }else{
            
            return UIScreen.main.bounds.height / 8
            
        }
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func getClickedSubCategory(index : IndexPath) -> SubCategories?{
        
        if(getExpandedSection() == -1){
            
            return nil
            
        }else if(index.row <= getExpandedSection()){
            
            return nil
            
        }else if(index.row > getExpandedSection() && index.row <= (getExpandedSection() + sections[getExpandedSection()].items.count)){
            
            return sections[getExpandedSection()].items[index.row - getExpandedSection()-1]
            
        }else{
            
            return nil
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        var isDoubleClick: Bool = false
            
        var countOfDeleted: Int = 0
            
        var indexOfDeleted: Int = 0
        
        let subC = getClickedSubCategory(index: indexPath)
        
        if(subC != nil){
            
            var lat: String
            
            var long: String
            
            let locManager = CLLocationManager()
            
            locManager.requestWhenInUseAuthorization()
            
            var currentLocation = CLLocation()
            
            if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized){
                
                currentLocation = locManager.location!
                
            }
            
            //        long = String(currentLocation.coordinate.longitude)
            //        
            //        lat = String(currentLocation.coordinate.latitude)
            
            long = String(51.411739)
            
            lat = String(35.625465)
            
            request(URLs.getBeaconList , method: .post , parameters: BeaconListRequestModel(LAT: lat, LONG: long, REDIUS: nil, SEARCH: nil, CATEGORY: nil, SUBCATEGORY: (subC?.subCategoryCode)!).getParams(), encoding: JSONEncoding.default).responseJSON { response in
                print()
                
                if let JSON = response.result.value {
                    
                    print("JSON ----------LOAD SUBCATEGORY----------->>>> ")
                    
                    let obj = BeaconListResponseModel.init(json: JSON as! JSON)
                    
                    print(JSON)
                    
                    print("=++++++++++++++++=")
                    
                    if ( obj?.code == "200" ){
                        
                        print(BeaconListRequestModel(LAT: lat, LONG: long, REDIUS: nil, SEARCH: nil, CATEGORY: nil, SUBCATEGORY: subC?.subCategoryCode).getParams())
                        
                        print(obj?.data)
                        
                        if(obj?.data == nil){
                            
                            //TODO
                            print("dar in lat long beacon nadarim!")
                            
                        }else{
                            //bayad bere tu liste category
                            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                                let vc = (self.storyboard?.instantiateViewController(withIdentifier: "CategoryPageViewController"))! as! CategoryPageViewController
                                
                                vc.parentView = "CategoryViewController"
                                
                                print(obj?.data)
                                
                                let image : UIImage = UIImage(named:"amlak")!
                                for i in (obj?.data!)! {
                                    let a = CustomerHomeTableCell.init(preCustomerImage:nil ,customerImage: i.url_icon, customerCampaignTitle: i.title!, customerName: i.customer_title!, customerCategoryIcon: image, customerDistanceToMe: "0", customerCoinValue: "0", customerCoinIcon: image, customerDiscountValue: i.discount!, customerDiscountIcon: image, tell: i.customer_tell! ,address: i.customer_address! ,text : i.text!  ,workTime: i.customer_work_time! , website: i.cusomer_web!,customerBigImages: i.url_pic)
                                    vc.customerHomeTableCells.append(a)
                                    
                                    
                                }
 
                                self.addChildViewController(vc)
                                
                                vc.view.frame = CGRect(x:0,y: 0,width: self.container.frame.size.width, height: self.container.frame.size.height);
                                
                                self.container.addSubview(vc.view)
                                
                                vc.didMove(toParentViewController: self)
                                
                                let color = self.sections[self.getSectionIndex(row: indexPath.row)]
                                
                                vc.setGradientLayer(color1: color.color1, color2: color.color2)
                                
                                vc.subCategoryIcon.image = self.loadImage(picModel: (subC?.image)!)?.imageWithColor(tintColor: UIColor.white)
                                
                                vc.subCategoryIcon.contentMode = UIViewContentMode.scaleAspectFit
                                
                                vc.subCategoryName.text = subC?.name
                                
                                self.navigationBar.alpha = 0
                                
                                self.tableViewCategory.alpha = 0
                                
                            }, completion: nil)

                            
                        }
                        
                    }
                    
                }
                
            }
            
        }else{
        
            tableView.beginUpdates()
            
            for s in 0...self.sections.count-1 {
                
                if(self.sections[s].collapsed == false){
                    
                    if(s == self.getSectionIndex(row: indexPath.row)){
                        isDoubleClick = true
                    }
                    
                    var indexes : [IndexPath] = [IndexPath]()
                    
                    for n in 1...self.sections[s].items.count {
                        
                        sections[s].items[n-1].visible = false
                        
                        indexes.append( IndexPath(row: self.getSectionIndex(row: indexPath.row)+n , section: 0))
                        
                    }
                    
                    tableView.deleteRows(at: indexes, with: .automatic)
                    
                    countOfDeleted = self.sections[s].items.count
                    indexOfDeleted = s
                    
                }
                self.sections[s].collapsed = true
                
            }
            
            if(!isDoubleClick){
                
                var indexes : [IndexPath] = [IndexPath]()
                
                if(indexOfDeleted < self.getSectionIndex(row: indexPath.row)){
                    
                    self.sections[self.getSectionIndex(row: indexPath.row - countOfDeleted)].collapsed = false
                    
                    for n in 1...self.sections[self.getSectionIndex(row: indexPath.row - countOfDeleted)].items.count {
                        
                        
                        sections[self.getSectionIndex(row: indexPath.row - countOfDeleted)].items[n-1].visible = true
                        indexes.append(IndexPath(row: self.getSectionIndex(row: (indexPath.row - countOfDeleted))+n , section: 0))
                        
                    }
                    
                    tableView.insertRows(at: indexes, with: .automatic)
                    
                }else{
                    
                    self.sections[self.getSectionIndex(row: indexPath.row)].collapsed = false
                    
                    for n in 1...self.sections[self.getSectionIndex(row: indexPath.row)].items.count {
                        
                        
                        sections[self.getSectionIndex(row: indexPath.row)].items[n-1].visible = true
                        
                        indexes.append(IndexPath(row: self.getSectionIndex(row: indexPath.row)+n , section: 0))
                        
                        
                    }
                    
                    tableView.insertRows(at: indexes, with: .automatic)
                }
                
                
            }
            
            
            tableView.reloadData()
            tableView.endUpdates()
            
            
            UIView.animate(withDuration: 0.5, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                if(indexOfDeleted < self.getSectionIndex(row: indexPath.row)){
                    
                    tableView.contentOffset.y = 70 * CGFloat(self.getSectionIndex(row: (indexPath.row - countOfDeleted)))
                    
                }else{
                    tableView.contentOffset.y = 70 * CGFloat(self.getSectionIndex(row: (indexPath.row)))
                    
                }
                
                
            },completion : nil)
            
        }
        
    }
    
    
    func deletSubView(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "CategoryViewController"))! as! CategoryViewController
            
            self.addChildViewController(vc)
            
            vc.view.frame = CGRect(x:0,y: 0,width: self.container.frame.size.width, height: self.container.frame.size.height);
            
            self.container.addSubview(vc.view)
            
            vc.didMove(toParentViewController: self)
            
        }, completion: nil)
        
    }

    
    
    func setGradientLayer(myView: UIView , color1: CGColor , color2: CGColor) -> CALayer {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = myView.bounds
        
        gradientLayer.frame.size.height += 1
        
        gradientLayer.frame.origin.y = 0
        
        gradientLayer.colors = [color1, color2]
        
        gradientLayer.startPoint = CGPoint(x: 0,y: 0.5)
        
        gradientLayer.endPoint = CGPoint(x: 1,y: 0.5)
        
        return gradientLayer
        
    }

    //
    // MARK: - Helper Functions
    //
    func getSectionIndex( row: Int) -> Int {
        
        if(getExpandedSection() == -1){
            
            return row
            
        }else if(row <= getExpandedSection()){
            
            return row
            
        }else if(row > getExpandedSection() && row <= (getExpandedSection() + sections[getExpandedSection()].items.count)){
            
            return getExpandedSection()
            
        }else{

            return row - sections[getExpandedSection()].items.count
            
        }

    }
    
    func getHeaderIndices() -> [Int] {
        var index = 0
        var indices: [Int] = []
        
        for section in sections {
            indices.append(index)
            index += section.items.count + 1
        }
        
        return indices
    }
    
    func getExpandedSection() -> Int {
        
        var count = 0
        
        for section in sections{
            
            if(!section.collapsed){
                
                return count
                
            }
            
            count += 1
            
        }
        
        return -1
        
    }
    
    
    
    func isThereThisPicInDB (code: String) -> String?{
        
        for i in SaveAndLoadModel().load(entity: "IMAGE")!{
            
            if(i.value(forKey: "imageCode") as! String == code){
                
                return i.value(forKey: "imageData") as! String
                
            }
            
        }
        
        return nil
        
    }
    
    func setCurve(isLast: Bool,cell: CategoryTableViewCell2){
        
        if(isLast == true){
        
            let maskPath = UIBezierPath(roundedRect: cell.boarderView.bounds, byRoundingCorners: [.bottomLeft, .bottomRight],cornerRadii: CGSize(width: 8.0, height: 8.0))
            
            let shape = CAShapeLayer()
            
            shape.path = maskPath.cgPath
            
            shape.borderWidth = 0
            
            cell.boarderView.layer.mask = shape
            
        }else{
            
            let maskPath = UIBezierPath(roundedRect: cell.boarderView.bounds, byRoundingCorners: [.bottomLeft, .bottomRight],cornerRadii: CGSize(width: 0, height: 0))
            
            let shape = CAShapeLayer()
            
            shape.path = maskPath.cgPath
            
            shape.borderWidth = 0
            
            cell.boarderView.layer.mask = shape
            
        }
        
    }
    
    func setSelectedCell(isSelected: Bool , cell: CategoryTableViewCell1){
        
        if(isSelected){
            cell.imageViewToggle.image = UIImage(named: "ic_keyboard_arrow_up_48pt")
            
            cell.boarderView.layer.cornerRadius = 0
            
            let maskPath = UIBezierPath(roundedRect: cell.boarderView.bounds, byRoundingCorners: [.topLeft, .topRight],cornerRadii: CGSize(width: 8.0, height: 8.0))
            
            let shape = CAShapeLayer()
            
            shape.path = maskPath.cgPath
            
            shape.borderWidth = 0
            
            cell.boarderView.layer.mask = shape
            
            cell.boarderView.backgroundColor = UIColor(hex: "#f5f7f8")
        
        }else{
    
            cell.boarderView.backgroundColor = UIColor.white
            
            cell.imageViewToggle.image = UIImage(named: "ic_keyboard_arrow_down_18pt")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                
                cell.boarderView.layer.cornerRadius = 8
    
            }
        }
    
    }
    
    func showLoadingAnim(){

        self.view.addSubview(self.animationView!)
        
        self.animationView?.play()
        
    }
    
    
    func loadCategoryTable(){
        
        let c1 = UIColor(hex: "f5f7f8").cgColor
        let c2 = UIColor(hex: "7c1f72").cgColor
        
        
        sections.removeAll()
        
            for obj in GlobalFields.CATEGORIES_LIST_DATAS! {
            
                var subs = [SubCategories]()
                
                for s in obj.item! {
                    
                    var tempCode = s.url_icon?.url
                    
                    tempCode?.append((s.url_icon?.code!)!)
                    
                    let result: String? = self.isThereThisPicInDB(code: (tempCode?.md5())!)
                    
                    var count: Int = 0
                    
                    if(s.count != nil){
                        count = Int(s.count!)!
                    }
                    
                    if(result == nil){
                        
                        let subT = SubCategories(preImage: nil,name: s.title!, image: s.url_icon, numberOfMembers: count , subCategoryCode: s.sub_code!)
                        
                        subs.append(subT)
                        
                    }else{
                        
                        let subT = SubCategories(preImage: UIImage(data: NSData(base64Encoded: result!, options: .ignoreUnknownCharacters) as! Data) ,name: s.title!, image: s.url_icon, numberOfMembers: count , subCategoryCode: s.sub_code!)
                        
                        subs.append(subT)
                        
                    }
                    
                }
                
                var tempCode = obj.url_icon?.url
                
                tempCode?.append((obj.url_icon?.code!)!)
                
                let result: String? = self.isThereThisPicInDB(code: (tempCode?.md5())!)
                
                if(result == nil){
                    
                    let colorsString = obj.color_code?.characters.split(separator: "-").map(String.init)
                    
                    if(colorsString != nil && colorsString?[0] != nil && colorsString?[1] != nil){
                        let a = Section.init(preImage: nil,name: obj.title!, image: obj.url_icon, items: subs, color1: UIColor(hex:(colorsString?[0])! ).cgColor, color2: UIColor(hex: (colorsString?[1])!).cgColor, collapsed: true , categoryCode: obj.category_code!)
                        self.sections.append(a)
                        
                    }else{
                        let a = Section.init(preImage: nil,name: obj.title!, image: obj.url_icon, items: subs, color1: c1, color2: c2, collapsed: true , categoryCode: obj.category_code!)
                        self.sections.append(a)
                    }
                    
                    
                }else{
                    
                    let colorsString = obj.color_code?.characters.split(separator: "-").map(String.init)
                    
                    if(colorsString != nil && colorsString?[0] != nil && colorsString?[1] != nil){
                        let a = Section.init(preImage: UIImage(data: NSData(base64Encoded: result!, options: .ignoreUnknownCharacters) as! Data),name: obj.title!, image: obj.url_icon, items: subs, color1: UIColor(hex:(colorsString?[0])! ).cgColor, color2: UIColor(hex: (colorsString?[1])!).cgColor, collapsed: true, categoryCode: obj.category_code!)
                        self.sections.append(a)
                        
                    }else{
                        let a = Section.init(preImage: UIImage(data: NSData(base64Encoded: result!, options: .ignoreUnknownCharacters) as! Data),name: obj.title!, image: obj.url_icon, items: subs, color1: c1, color2: c2, collapsed: true ,categoryCode: obj.category_code!)
                        self.sections.append(a)
                    }
                    
                }
            
            }
            
        
        
    }


}
