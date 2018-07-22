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
import CryptoSwift

class CategoryViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    
    struct  SubCategories {
        var name: String!
        var image: PicModel?
        var numberOfMembers: Int!
        var preImage: UIImage?
        var visible : Bool
        var subCategoryCode : String
        var all_track : Bool = false
        
        init(preImage: UIImage?,name: String , image: PicModel? , numberOfMembers: Int , subCategoryCode: String , all_track : Bool?) {
            self.name = name
            self.image = image
            self.preImage = preImage
            self.numberOfMembers = numberOfMembers
            self.visible = false
            if(all_track != nil){
                
                self.all_track = all_track!
                
            }else{
                
                self.all_track = false
                
            }
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

    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var windowHeight : CGFloat = 0
    
    override func viewDidAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Category")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        super.viewDidAppear(animated)
            
//        self.loadCategoryTable()
//        
//        self.tableViewCategory.reloadData()
//        
//        loading.stopAnimating()

    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        windowHeight = self.view.frame.height
        
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
        
        loading.startAnimating()
        
        loading.hidesWhenStopped = true
       
        self.cache = NSCache()
        
        self.loadCategoryTable()
        
        self.tableViewCategory.reloadData()
        
        loading.stopAnimating()
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
            
            let myImage2 = UIImage(named:"Icon")?.imageWithColor(tintColor: UIColor.white)
            
            cell2?.iconView.image = myImage2
            
            cell2?.boarderView.frame.size.height = (cell2?.frame.height)!
            
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
                
                LoadPicture().proLoad(view: cell2?.iconView, picModel: dataCell2.image!){ resImage in
                 
                    if(self.getExpandedSection() != -1){
                       
                        if(self.sections.count - 1 >= self.getExpandedSection() && self.sections[self.getExpandedSection()].items.count >= indexPath.row - self.getExpandedSection()-1){
                            
                            self.sections[self.getExpandedSection()].items[indexPath.row - self.getExpandedSection()-1].preImage = resImage
                            
                            cell2?.iconView.image = resImage
                            
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
                
                if (sections[getSectionIndex(row: indexPath.row)].image?.url != nil){
                    
                    LoadPicture().proLoad(view: myCell!.imageViewCell1, picModel: (sections[getSectionIndex(row: indexPath.row)].image)!){resImage in
                        
                        let myLayer = CALayer()
                        
                        let myImage = resImage.imageWithColor(tintColor: UIColor.white)
                        
                        self.sections[self.getSectionIndex(row: indexPath.row)].preImage = myImage
                        
                        let rect = myCell!.imageViewCell1.bounds
                        
                        myLayer.frame = CGRect(x: rect.minX + rect.width * 0.25, y: rect.minY + rect.height * 0.25, width: rect.width * 0.5, height: rect.height * 0.5)
                        
                        myLayer.contents = myImage.cgImage
                        
                        myCell?.imageViewCell1.layer.addSublayer(myLayer)
                        
                        myCell?.imageViewCell1.contentMode = UIViewContentMode.scaleAspectFit
                        
                    }
                }
            }
            
            myCell?.layer.zPosition = 1
            
            return myCell!
            
        }

        
    }
 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if(getExpandedSection() != -1 && indexPath.row > getExpandedSection() && indexPath.row <= (getExpandedSection() + sections[getExpandedSection()].items.count) ){
            
            return windowHeight / 8 - 10
            
        }else{
            
            return windowHeight / 8
            
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
        
        
        
            tableView.beginUpdates()
            
            loadCategoryTableTwo(count: self.getSectionIndex(row: indexPath.row))
            
            for s in 0...self.sections.count-1 {
                
                if(self.sections[s].collapsed == false){
                    
                    if(s == self.getSectionIndex(row: indexPath.row)){
                        isDoubleClick = true
                    }
                    
                    var indexes : [IndexPath] = [IndexPath]()
                    
                    for n in 1...GlobalFields.CATEGORIES_LIST_DATAS![s].item!.count {
                        
                        sections[s].items[n-1].visible = false
                        
                        indexes.append( IndexPath(row: self.getSectionIndex(row: indexPath.row)+n , section: 0))
                        
                    }
                    
                    tableView.deleteRows(at: indexes, with: .automatic)
                    
                    countOfDeleted = GlobalFields.CATEGORIES_LIST_DATAS![s].item!.count
                    indexOfDeleted = s
                    
                }
                self.sections[s].collapsed = true
                
            }
            
            if(!isDoubleClick){
                
//                loadCategoryTableTwo(count: self.getSectionIndex(row: indexPath.row))
                
                
                var indexes : [IndexPath] = [IndexPath]()
                
                if(indexOfDeleted < self.getSectionIndex(row: indexPath.row)){
                    
                    self.sections[self.getSectionIndex(row: indexPath.row - countOfDeleted)].collapsed = false
                    if(self.sections[self.getSectionIndex(row: indexPath.row - countOfDeleted)].items.count > 0){
                        
                        for n in 1...self.sections[self.getSectionIndex(row: indexPath.row - countOfDeleted)].items.count {
                            
                            
                            sections[self.getSectionIndex(row: indexPath.row - countOfDeleted)].items[n-1].visible = true
                            indexes.append(IndexPath(row: self.getSectionIndex(row: (indexPath.row - countOfDeleted))+n , section: 0))
                            
                        }
                        
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
                    
                    tableView.contentOffset.y = (self.windowHeight / 8) * CGFloat(self.getSectionIndex(row: (indexPath.row - countOfDeleted)))
                    
                }else{
                    tableView.contentOffset.y = (self.windowHeight / 8) * CGFloat(self.getSectionIndex(row: (indexPath.row)))
                    
                }
                
                
            },completion : nil)
            
        
        
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
        
//        if(isLast == true){
//        
//            let maskPath = UIBezierPath(roundedRect: cell.boarderView.bounds, byRoundingCorners: [.bottomLeft, .bottomRight],cornerRadii: CGSize(width: 8.0, height: 8.0))
//            
//            let shape = CAShapeLayer()
//            
//            shape.path = maskPath.cgPath
//            
//            shape.borderWidth = 0
//            
//            cell.boarderView.layer.mask = shape
//            
//        }else{
//            
//            let maskPath = UIBezierPath(roundedRect: cell.boarderView.bounds, byRoundingCorners: [.bottomLeft, .bottomRight],cornerRadii: CGSize(width: 0, height: 0))
//            
//            let shape = CAShapeLayer()
//            
//            shape.path = maskPath.cgPath
//            
//            shape.borderWidth = 0
//            
//            cell.boarderView.layer.mask = shape
//            
//        }
        
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
                
                var tempCode = obj.url_icon?.url
                
                tempCode?.append((obj.url_icon?.code!)!)
                
                let result: String? = self.isThereThisPicInDB(code: (tempCode?.md5())!)
                
                if(result == nil){
                    
                    let colorsString = obj.color_code?.characters.split(separator: "-").map(String.init)
                    
                    if(colorsString != nil && colorsString?[0] != nil && colorsString?[1] != nil){
                        let a = Section.init(preImage: nil,name: obj.title!, image: obj.url_icon, items: subs, color1: UIColor(hex:(colorsString?[0])! ).cgColor, color2: UIColor(hex: (colorsString?[1])!).cgColor, collapsed: true , categoryCode: obj.category_code!)
                        self.sections.append(a)
                        self.tableViewCategory.reloadData()
                        
                    }else{
                        let a = Section.init(preImage: nil,name: obj.title!, image: obj.url_icon, items: subs, color1: c1, color2: c2, collapsed: true , categoryCode: obj.category_code!)
                        self.sections.append(a)
                        self.tableViewCategory.reloadData()
                    }
                    
                    
                }else{
                    
                    let colorsString = obj.color_code?.characters.split(separator: "-").map(String.init)
                    
                    if(colorsString != nil && colorsString?[0] != nil && colorsString?[1] != nil){
                        let a = Section.init(preImage: UIImage(data: NSData(base64Encoded: result!, options: .ignoreUnknownCharacters) as! Data),name: obj.title!, image: obj.url_icon, items: subs, color1: UIColor(hex:(colorsString?[0])! ).cgColor, color2: UIColor(hex: (colorsString?[1])!).cgColor, collapsed: true, categoryCode: obj.category_code!)
                        self.sections.append(a)
                        self.tableViewCategory.reloadData()
                        
                    }else{
                        let a = Section.init(preImage: UIImage(data: NSData(base64Encoded: result!, options: .ignoreUnknownCharacters) as! Data),name: obj.title!, image: obj.url_icon, items: subs, color1: c1, color2: c2, collapsed: true ,categoryCode: obj.category_code!)
                        self.sections.append(a)
                        self.tableViewCategory.reloadData()
                    }
                    
                }
            
            }
            
        
        
    }


    func loadCategoryTableTwo(count : Int){
        
        
//        var count = -1
//        for obj in GlobalFields.CATEGORIES_LIST_DATAS! {
//            count += 1
            var subs = [SubCategories]()
//            obj.item!
            for s in GlobalFields.CATEGORIES_LIST_DATAS![count].item! {
                
                var tempCode = s.url_icon?.url
                
                tempCode?.append((s.url_icon?.code!)!)
                
                let result: String? = self.isThereThisPicInDB(code: (tempCode?.md5())!)
                
                var count: Int = 0
                
                if(s.count != nil){
                    count = Int(s.count!)!
                }
                
                if(result == nil){
                    
                    let subT = SubCategories(preImage: nil,name: s.title!, image: s.url_icon, numberOfMembers: count , subCategoryCode: s.sub_code! , all_track : Bool.init(s.all_track!))
                    
                    subs.append(subT)
                    
                }else{
                    
                    let subT = SubCategories(preImage: UIImage(data: NSData(base64Encoded: result!, options: .ignoreUnknownCharacters) as! Data) ,name: s.title!, image: s.url_icon, numberOfMembers: count , subCategoryCode: s.sub_code! , all_track : Bool.init(s.all_track!))
                    
                    subs.append(subT)
                    
                    
                }
                
            }
            
            sections[count].items = subs
            
//        }
        
        
        
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "categorySubcategorySegue"){
            
            loadSubCategories(segue: segue , sender : sender)
            
        }
        
        
    }
    
    
    
    func loadSubCategories(segue: UIStoryboardSegue, sender: Any?){
        
        let nextVc = segue.destination as! CategoryPageViewController
        
        let row = self.tableViewCategory.indexPath(for: (sender as! CategoryTableViewCell2))!.row
        
        let subC = getClickedSubCategory(index: self.tableViewCategory.indexPath(for: (sender as! CategoryTableViewCell2))!)
        
        print(self.getSectionIndex(row: row))
        
        let color = self.sections[self.getSectionIndex(row: row)]
        
        nextVc.color1 = color.color1
        
        nextVc.color2 = color.color2
        
        if(subC?.image != nil){
            
            nextVc.catIconPicModel = subC?.image
            
        }
        
        nextVc.nameTitle = (subC?.name)!
        
        nextVc.loading.startAnimating()
        
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
            
            long = String(currentLocation.coordinate.longitude)
            
            lat = String(currentLocation.coordinate.latitude)
            
            if(lat == "0" && long == "0"){
                
                long = String(51.4212297)
                
                lat = String(35.6329044)
                
            }
            
            
            if(subC?.all_track == true){
                
                request(URLs.getBeaconList , method: .post , parameters: BeaconListRequestModel(LAT: lat, LONG: long, REDIUS: String(GlobalFields.BEACON_RANG), SEARCH: nil, CATEGORY: sections[getSectionIndex(row: self.tableViewCategory.indexPath(for: (sender as! CategoryTableViewCell2))!.row)].categoryCode, SUBCATEGORY: nil).getParams(allSearch : true), encoding: JSONEncoding.default).responseJSON { response in
                    print()
                    
                    if let JSON = response.result.value {
                        
                        print("JSON ----------LOAD SUBCATEGORY----------->>>> ")
                        
                        let obj = BeaconListResponseModel.init(json: JSON as! JSON)
                        
                        print(JSON)
                        
                        print("=++++++++++++++++=")
                        if(obj?.code == "5005"){
                            GlobalFields().goErrorPage(viewController: self)
                        }
                        if ( obj?.code == "200" ){
                            
                            
                            if(obj?.data == nil){
                                
                                //TODO
                                print("dar in lat long beacon nadarim!")
                                nextVc.table.alpha = 0
                                
                                nextVc.loading.stopAnimating()
                                
                                nextVc.loading.alpha = 0
                                
                            }else{
                                //bayad bere tu liste category
                                
                                nextVc.table.alpha = 1
                                
                                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                                    
                                    
                                    print(obj?.data ?? "")
//
//                                    let image : UIImage = UIImage(named:"amlak")!
                                    
                                    let locManager = CLLocationManager()
                                    
                                    locManager.requestAlwaysAuthorization()
                                    
                                    var currentLocation = CLLocation()
                                    
                                    if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways ||
                                        CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
                                        
                                        currentLocation = locManager.location!
                                        
                                    }
                                    
                                    for i in (obj?.data!)! {
//                                        LoadPicture().proLoad(view: nil , picModel: i.url_icon!){ resImage in
//                                            
//                                            for c in nextVc.customerHomeTableCells {
//                                                
//                                                if(c.customerImage?.url == i.url_icon?.url){
//                                                    
//                                                    if(c.customerImage?.code == i.url_icon?.code){
//                                                        
//                                                        c.preCustomerImage = resImage
//                                                        
//                                                        //                                                            nextVc.table.reloadData()
//                                                        
//                                                    }
//                                                    
//                                                }
//                                                
//                                            }
//                                            
//                                        }
                                        
                                        let a = CustomerHomeTableCell.init(uuidMajorMinorMD5: nil,preCustomerImage: nil ,customerImage: i.url_icon, customerCampaignTitle: i.title!, customerName: i.customer_title!, customerCategoryIcon: nil, customerDistanceToMe: String(describing: round((i.distance ?? 0) * 100) / 100) , customerCoinValue: i.coin ?? "0", customerDiscountValue: i.discount!, tell: i.customer_tell ?? "" ,address: i.customer_address ?? "" ,text : i.text!  ,workTime: i.customer_work_time ?? "" , website: i.cusomer_web ?? "",customerBigImages: i.url_pic , categoryID: i.category_id, beaconCode : i.beacon_code , campaignCode : i.campaign_code, lat : i.lat , long : i.long)
                                        
                                        if(currentLocation.coordinate.latitude != 0){
                                            
                                            let dis = String(format: "%.2f", currentLocation.distance(from: CLLocation.init(latitude: (Double(i.lat!))!, longitude: (Double(i.long!))!))/1000)
                                            
                                            i.distance = Double(dis)
                                            a.customerDistanceToMe = dis
                                            
                                        }
                                        
                                        nextVc.customerHomeTableCells.append(a)
                                        
                                    }
                                    
                                    nextVc.table.reloadData()
                                    
                                    nextVc.loading.stopAnimating()
                                    
                                }, completion: nil)
                                
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }else{
                
                request(URLs.getBeaconList , method: .post , parameters: BeaconListRequestModel(LAT: lat, LONG: long, REDIUS: String(GlobalFields.BEACON_RANG), SEARCH: nil, CATEGORY: nil, SUBCATEGORY: (subC?.subCategoryCode)!).getParams(allSearch : true), encoding: JSONEncoding.default).responseJSON { response in
                    print()
                    
                    if let JSON = response.result.value {
                        
                        print("JSON ----------LOAD SUBCATEGORY----------->>>> ")
                        
                        let obj = BeaconListResponseModel.init(json: JSON as! JSON)
                        
//                        print(JSON)
//                        
//                        print("=++++++++++++++++=")
                        if(obj?.code == "5005"){
                            GlobalFields().goErrorPage(viewController: self)
                        }
                        if ( obj?.code == "200" ){
                            
//                            print(BeaconListRequestModel(LAT: lat, LONG: long, REDIUS: String(GlobalFields.BEACON_RANG), SEARCH: nil, CATEGORY: nil, SUBCATEGORY: subC?.subCategoryCode).getParams(allSearch : true))
//                            
//                            print(obj?.data)
                            
                            if(obj?.data == nil){
                                
                                //TODO
                                print("dar in lat long beacon nadarim!")
                                
                                nextVc.table.alpha = 0
                                
                                nextVc.loading.stopAnimating()
                                
                                nextVc.loading.alpha = 0
                                
                            }else{
                                //bayad bere tu liste category
                                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                                    
                                    nextVc.parentView = "CategoryViewController"
     
                                    for i in (obj?.data!)! {
                                        
                                        let a = CustomerHomeTableCell.init(uuidMajorMinorMD5: nil,preCustomerImage: nil ,customerImage: i.url_icon, customerCampaignTitle: i.title ?? "", customerName: i.customer_title ?? "", customerCategoryIcon: nil, customerDistanceToMe: String(describing: round((i.distance ?? 0) * 100) / 100) , customerCoinValue: i.coin ?? "0", customerDiscountValue: i.discount ?? "", tell: i.customer_tell ?? "" ,address: i.customer_address ?? "" ,text : i.text ?? "" ,workTime: i.customer_work_time ?? "", website: i.cusomer_web ?? "",customerBigImages: i.url_pic, categoryID: i.category_id, beaconCode : i.beacon_code , campaignCode : i.campaign_code, lat : i.lat , long : i.long)
                                        nextVc.customerHomeTableCells.append(a)
                                        
                                    }
                                    
                                    nextVc.table.reloadData()
                                    
                                    nextVc.loading.stopAnimating()
                                    
                                }, completion: nil)
                                
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
















