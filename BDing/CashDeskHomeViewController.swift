//
//  CashDeskHomeViewController.swift
//  BDing
//
//  Created by MILAD on 1/22/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit

class CashDeskHomeViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource , UIScrollViewDelegate{

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    
    @IBOutlet weak var cashierName: UILabel!
    
    @IBOutlet weak var cashDeskName: UILabel!
    
    @IBOutlet weak var totalTransactions: UILabel!
    
    @IBOutlet weak var settingButton: DCBorderedButton!
    
    @IBOutlet weak var transactionsReportsButton: DCBorderedButton!
    
    @IBOutlet weak var transactionsButton: DCBorderedButton!
    
    @IBOutlet weak var holdingView: DCBorderedView!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var maximizeButton: UIButton!
    
    @IBOutlet weak var refreshImage: UIImageView!
    
    
    @IBOutlet weak var maximizeImage: UIImageView!
    
    
    @IBOutlet weak var waitingTable: UITableView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    
    @IBOutlet weak var drawerView: DCBorderedView!
    
    @IBOutlet weak var arrow: UIImageView!
    
    @IBOutlet weak var emptyImage: UIImageView!
    
    
    var cBuyerData : [CListBuyerData] = [CListBuyerData]()
    
    var isMaximize : Bool = false
    
    
    /////////////////responsive
    
    @IBOutlet weak var tImage: UIImageView!
    @IBOutlet weak var tLabel: UILabel!
    @IBOutlet weak var rImage: UIImageView!
    @IBOutlet weak var rLabel: UILabel!
    @IBOutlet weak var sImage: UIImageView!
    @IBOutlet weak var sLabel: UILabel!
    
    
    
    /////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        
        waitingTable.delegate = self
        
        waitingTable.dataSource = self
        
        tImage.frame.origin.x = transactionsButton.frame.origin.x + (transactionsButton.frame.width / 2) - (tImage.frame.width / 2)
        tImage.frame.origin.y = transactionsButton.frame.origin.y + (transactionsButton.frame.height / 2) - (tImage.frame.height / 2)
 
        rImage.frame.origin.x = transactionsReportsButton.frame.origin.x + (transactionsReportsButton.frame.width / 2) - (rImage.frame.width / 2)
        rImage.frame.origin.y = transactionsReportsButton.frame.origin.y + (transactionsReportsButton.frame.height / 2) - (rImage.frame.height / 2)

        sImage.frame.origin.x = settingButton.frame.origin.x + (settingButton.frame.width / 2) - (sImage.frame.width / 2)
        sImage.frame.origin.y = settingButton.frame.origin.y + (settingButton.frame.height / 2) - (sImage.frame.height / 2)
        
        emptyImage.alpha = 0
        
        let h : CGFloat = self.view.frame.height
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1000 / 667 * h )
        
        profileImage.frame.size.width = profileImage.frame.size.height
        profileImage.frame.origin.x = (self.view.frame.width / 2) - (profileImage.frame.size.width / 2)
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        profileImage.layer.masksToBounds = true
        
        settingButton.frame.size.height = settingButton.frame.size.width
        settingButton.layer.cornerRadius = settingButton.frame.height / 2
        settingButton.cornerRadius = settingButton.frame.height / 2
        
        transactionsReportsButton.frame.size.height = transactionsReportsButton.frame.size.width
        transactionsReportsButton.layer.cornerRadius = transactionsReportsButton.frame.height / 2
        transactionsReportsButton.cornerRadius = transactionsReportsButton.frame.height / 2
        
        transactionsButton.frame.size.height = transactionsButton.frame.size.width
        transactionsButton.layer.cornerRadius = transactionsButton.frame.height / 2
        transactionsButton.cornerRadius = transactionsButton.frame.height / 2
        
        self.waitingTable.register(UINib(nibName: "CashDeskTableViewCell", bundle: nil), forCellReuseIdentifier: "cashDeskCell")
        
        self.cashierName.text = GlobalFields.cLastCashData?.name_family
        
        self.cashDeskName.text = GlobalFields.cLastCashData?.cash_title
        
        self.totalTransactions.text = GlobalFields.cLastCashData?.total_price
        
        if(GlobalFields.cPic != nil && GlobalFields.cPic != ""){
            
            let imageData = NSData(base64Encoded: (GlobalFields.cPic) , options:.ignoreUnknownCharacters)
            
            self.profileImage.image = UIImage(data: imageData as! Data)!
            
        }
        
        self.profileImage.frame.size.height = self.profileImage.frame.size.width
        
        self.profileImage.layer.cornerRadius = self.profileImage.frame.height
        
        //viewye profilePic va seta buttone vasat bayad gerd bashe
    
        refreshList("")
        
        usedTimer()
        
        waitingTable.isScrollEnabled = false
        
        self.navigationController?.isNavigationBarHidden = true
        
    }

    override func viewDidAppear(_ animated: Bool) {
        profileImage.frame.size.width = profileImage.frame.size.height
        profileImage.frame.origin.x = (self.view.frame.width / 2) - (profileImage.frame.size.width / 2)
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        profileImage.layer.masksToBounds = true
        tImage.frame.origin.x = transactionsButton.frame.origin.x + (transactionsButton.frame.width / 2) - (tImage.frame.width / 2)
        tImage.frame.origin.y = transactionsButton.frame.origin.y + (transactionsButton.frame.height / 2) - (tImage.frame.height / 2)
        
        rImage.frame.origin.x = transactionsReportsButton.frame.origin.x + (transactionsReportsButton.frame.width / 2) - (rImage.frame.width / 2)
        rImage.frame.origin.y = transactionsReportsButton.frame.origin.y + (transactionsReportsButton.frame.height / 2) - (rImage.frame.height / 2)
        
        sImage.frame.origin.x = settingButton.frame.origin.x + (settingButton.frame.width / 2) - (sImage.frame.width / 2)
        sImage.frame.origin.y = settingButton.frame.origin.y + (settingButton.frame.height / 2) - (sImage.frame.height / 2)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goSetting(_ sender: Any) {
    }
    
    func updateLastCash(){
        request(URLs.cLastCash , method: .post , parameters: CLastCashRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON2 = response.result.value {
                
                print("JSON ----------Last Cash----------->>>> " , JSON2)
                
                let obj2 = CLastCashResponseModel.init(json: JSON2 as! JSON)
                
                if ( obj2?.code == "200" ){
                    
                    GlobalFields.cLastCashData = obj2?.data
                    
                    self.cashierName.text = GlobalFields.cLastCashData?.name_family
                    
                    self.cashDeskName.text = GlobalFields.cLastCashData?.cash_title
                    
                    self.totalTransactions.text = GlobalFields.cLastCashData?.total_price
                    
                    if(GlobalFields.cPic != nil && GlobalFields.cPic != ""){
                        
                        let imageData = NSData(base64Encoded: (GlobalFields.cPic) , options:.ignoreUnknownCharacters)
                        
                        self.profileImage.image = UIImage(data: imageData as! Data)!
                        
                    }
                    
                }
                
            }
            
        }
    }
  
    @IBAction func goTransactionsReports(_ sender: Any) {
        
        request(URLs.cLastCash , method: .post , parameters: CLastCashRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON2 = response.result.value {
                
                print("JSON ----------Last Cash----------->>>> " , JSON2)
                
                let obj2 = CLastCashResponseModel.init(json: JSON2 as! JSON)
                
                if ( obj2?.code == "200" ){
                    
                    let objVC : UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "CashDeskHomeViewController"))! as UIViewController
                    
                    GlobalFields.cLastCashData = obj2?.data
                    print(CReportCashRequestModel.init().getParams())
                    request(URLs.cReportCash , method: .post , parameters: CReportCashRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
                        print()
                        
                        if let JSON = response.result.value {
                            
                            print("JSON ----------report list----------->>>> " , JSON)
                            
                            let obj = CReportCashResponseModel.init(json: JSON as! JSON)
                            
                            if ( obj?.code == "200" ){
                                
                                let objVC : CashReportViewController = (self.storyboard?.instantiateViewController(withIdentifier: "CashReportViewController"))! as! CashReportViewController
                                
                                    GlobalFields.cReportCashResponseModel = obj
                                
                                self.navigationController?.pushViewController(objVC, animated: true)
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        
    }
    
    @IBAction func goTransactions(_ sender: Any) {
    }
    
    func usedTimer()  {
        Timer.scheduledTimer(timeInterval: 7,
                             target: self,
                             selector: #selector(self.run(_:)),
                             userInfo: nil,
                             repeats: true)
    }
    
    func run(_ timer: AnyObject) {
        if(GlobalFields.autoUpdate == true){
            
            refreshList("")
            
        }
        if(!GlobalFields.payStatus.isEmpty){
            
            checkPayStatus()
            
        }
        
    }
    
    func checkPayStatus(){
        print(CPayStatusRequestModel.init(TYPE: "chasier").getParams())
        request(URLs.cPayStatus , method: .post , parameters: CPayStatusRequestModel.init(TYPE: "cashier").getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------Pay Status----------->>>> " , JSON)
                
                let obj = CPayStatusResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200"){
                    
                    if(obj?.data != nil){
                    
                        self.analyzeWaitingList(list : (obj?.data)!)
                        
                        self.waitingTable.reloadData()
                        
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func analyzeWaitingList(list : [CPayStatusData]){
        
        for ps in list{
            
            //ag success bud k notify midim az list del mishe
            
            if(ps.status_pay == "success"){
                
                if(GlobalFields.payStatus.index(where: {$0 == ps.buyer_id!}) != nil){
                    
                    GlobalFields.payStatus.remove(at: GlobalFields.payStatus.index(where: {$0 == ps.buyer_id!})!)
                    
                    var s : String = ps.price!
                    s.append(" تومان پرداخت ")
                    s.append(ps.name_family!)
                    s.append(" با موفقیت انجام شد")
                    
                    let notification = UILocalNotification()
                    notification.fireDate = Date()
                    notification.alertBody = s
                    notification.alertAction = "ok"
                    notification.soundName = UILocalNotificationDefaultSoundName
                    UIApplication.shared.presentLocalNotificationNow(notification)
                    
                    self.refreshList("")
                    
                    self.updateLastCash()
                    
                }
                
                
            }else if(ps.status_pay == "cancel"){
             //ag cansel bud k del mishe az list
                if(GlobalFields.payStatus.index(where: {$0 == ps.buyer_id!}) != nil){
                    
                    GlobalFields.payStatus.remove(at: GlobalFields.payStatus.index(where: {$0 == ps.buyer_id!})!)
                    
                    self.refreshList("")
                    
                }
                
            }
            
            
            //ag wait bud k mimune tu list hichi nemishe
        }
        
    }
    
    
    @IBAction func refreshList(_ sender: Any) {
        
        request(URLs.cListBuyer , method: .post , parameters: CListBuyerRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------refresh list----------->>>> " , JSON)
                
                let obj = CListBuyerResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                    
                    if(obj?.data != nil){
                        
                        self.cBuyerData = (obj?.data)!
                        
                        self.waitingTable.reloadData()
                        
                        if((obj?.data?.count)! == 0){
                            self.emptyImage.alpha = 1
                            self.waitingTable.alpha = 0
                        }else{
                            self.emptyImage.alpha = 0
                            self.waitingTable.alpha = 1
                        }
                        
                        self.navigationController?.isNavigationBarHidden = true
                        
                    }else{
                        self.emptyImage.alpha = 1
                        self.waitingTable.alpha = 0
                    }
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func maximize(_ sender: Any) {
        
        // bayad table ta bala biad
        
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        
        if(isMaximize == false){
            isMaximize = true
            self.refreshImage.image = UIImage.init(named: "AddButt (butt)")
            self.maximizeImage.image = UIImage.init(named: "Compress_48px")
            waitingTable.isScrollEnabled = true
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.holdingView.frame.origin.y = (30 / 667) * self.view.frame.height
                
                self.holdingView.frame.size.height = (600 / 667) * self.view.frame.height
                
                self.scrollView.isScrollEnabled = false
                
                self.holdingView.backgroundColor = UIColor.clear
                
                self.waitingTable.backgroundColor = UIColor.clear
                
                for v in self.scrollView.subviews {
                    
                    if((v != self.scrollView) && (v != self.holdingView)){
                        v.alpha = 0
                    }
                    
                }
                
            },completion: nil)
            
        }else{
            isMaximize = false
            waitingTable.isScrollEnabled = false
            self.refreshImage.image = UIImage.init(named: "AddButt (butt)-1")
            self.maximizeImage.image = UIImage.init(named: "Enlarge_24px")
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.holdingView.frame.origin.y = (450 / 667) * self.view.frame.height
                
                self.holdingView.frame.size.height = (316 / 667) * self.view.frame.height
                
                self.scrollView.isScrollEnabled = true
                
                self.holdingView.backgroundColor = UIColor.init(hex: "f1f1f1")
                
                self.waitingTable.backgroundColor = UIColor.init(hex: "f1f1f1")
                
                for v in self.scrollView.subviews {
                    
                    if((v != self.scrollView) && (v != self.holdingView)){
                        v.alpha = 1
                    }
                    
                }
                
            },completion: nil)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cBuyerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cashDeskCell", for: indexPath) as! CashDeskTableViewCell
        
        cell.name.text = cBuyerData[indexPath.row].name_family
        
        cell.userName.text = cBuyerData[indexPath.row].username
        
        cell.profileImage.frame.size.width = cell.profileImage.frame.height

        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2
        
        cell.profileImage.clipsToBounds = true
        
        cell.profileImage.layer.masksToBounds = true
        
        if(cBuyerData[indexPath.row].pic != nil && cBuyerData[indexPath.row].pic != ""){
        
            let imageData = NSData(base64Encoded: cBuyerData[indexPath.row].pic! , options:.ignoreUnknownCharacters)
            
            cell.profileImage.image = UIImage(data: imageData as! Data)!
            
        }
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
        cell.payButton.tag = indexPath.row
        
        cell.payButton.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
        
        if(GlobalFields.payStatus.contains(cBuyerData[indexPath.row].buyer_id!)){
            cell.payButton.setTitle("در حال انجام", for: .normal)
        }else{
            cell.payButton.setTitle("پرداخت", for: .normal)
        }
        
        if(cBuyerData[indexPath.row].status == "appointment_price"){
            cell.payButton.setTitle("در حال انجام", for: .normal)
            if(GlobalFields.payStatus.index(where: {$0 == cBuyerData[indexPath.row].buyer_id!}) == nil){
                GlobalFields.payStatus.append(cBuyerData[indexPath.row].buyer_id!)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (60 / 667) * self.view.frame.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.waitingTable.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        
    }
    
    
    func buttonClicked(_ sender: Any){
        
        if(sender is UIButton){
            
            var but : UIButton = sender as! UIButton
            
            if(but.title(for: .normal) == "پرداخت"){
                
                let vc = (self.storyboard?.instantiateViewController(withIdentifier: "CashPopupViewController"))! as! CashPopupViewController
                
                self.addChildViewController(vc)
                
                
                vc.view.frame = CGRect(x:0,y: 0,width: self.view.frame.size.width, height: self.view.frame.size.height)
                
                vc.view.tag = 234
                
                UIView.transition(with: self.view, duration: 0.4 , options: UIViewAnimationOptions.curveEaseIn ,animations: {self.view.addSubview(vc.view)}, completion: nil)
                
                vc.didMove(toParentViewController: self)
                
                var data = cBuyerData[(sender as! UIButton).tag]
                
                vc.setup(data: data)
                
                vc.view.alpha = 1
                
                self.view.alpha = 1
                
            }
            
        }
        
    }
    
    
    func deletSubView(){
        
        if let viewWithTag = self.view.viewWithTag(234) {
            
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
    
    
    @IBAction func showDrawer(_ sender: Any) {
        
        if( drawerView.frame.origin.y != self.view.frame.height / 667 * 641 ){
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.drawerView.frame.origin.y = self.view.frame.height / 667 * 641
                
                self.arrow.transform = CGAffineTransform(rotationAngle: (360.0 * CGFloat(M_PI)) / 180.0)
                
            },completion : nil)
            
        }else{
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.drawerView.frame.origin.y = self.view.frame.height / 667 * 577
                
                self.arrow.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(M_PI)) / 180.0)
                
            },completion : nil)
        }
        
    }
    
    
    @IBAction func backToBDingApp(_ sender: Any) {
        
        self.tabBarController?.tabBar.isHidden = false
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
    

}





