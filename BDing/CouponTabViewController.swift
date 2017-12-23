//
//  CouponTabViewController.swift
//  BDing
//
//  Created by MILAD on 11/15/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit

class CouponTabViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{
    
    @IBOutlet weak var myDingLabel: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var buyCouponsTable: UITableView!
    
    @IBOutlet weak var myCouponsTable: UITableView!
    
    @IBOutlet weak var emptyImage: UIImageView!
    
    var coupons: [CouponListData]? = [CouponListData]()
    
    var myCoupons : [MyCouponListData]? = [MyCouponListData]()
    
    var couponsPrePics : [UIImage?]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.buyCouponsTable.register(UINib(nibName: "CouponTableViewCell", bundle: nil), forCellReuseIdentifier: "couponCell")
        
        self.myCouponsTable.register(UINib(nibName: "MyCouponTableViewCell", bundle: nil), forCellReuseIdentifier: "myCouponCell")
        
        buyCouponsTable.dataSource = self
        buyCouponsTable.delegate = self
        
        myCouponsTable.dataSource = self
        myCouponsTable.delegate = self
        
        myCouponsTable.alpha = 0
        
        segmentedControl.selectedSegmentIndex = 1
        
        let font : UIFont = UIFont(name: "IRANYekanMobileFaNum", size: 14.0)!
        segmentedControl.setTitleTextAttributes([NSFontAttributeName: font] , for: .normal)
        
        self.requestForGetCoupon()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        myDingLabel.text = GlobalFields.PROFILEDATA?.all_coin
        
        if(GlobalFields.needUpdateMyCoupon == true){
            
            self.requestForMyCoupon()
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func controlPages(_ sender: Any) {
        if(segmentedControl.selectedSegmentIndex == 1){
            myCouponsTable.alpha = 0
            buyCouponsTable.alpha = 1
            emptyImage.alpha = 0
            if(coupons == nil || (coupons?.isEmpty)!){
                buyCouponsTable.alpha = 0
                emptyImage.alpha = 1
                emptyImage.image = UIImage.init(named: "emptyCoupon")
            }
        }else{
            myCouponsTable.alpha = 1
            buyCouponsTable.alpha = 0
            emptyImage.alpha = 0
            if(myCoupons == nil || (myCoupons?.isEmpty)!){
                myCouponsTable.alpha = 0
                emptyImage.alpha = 1
                emptyImage.image = UIImage.init(named: "emptyMyCoupon")
            }
            if(GlobalFields.needUpdateMyCoupon == true){
                
                self.requestForMyCoupon()
                
            }
        }
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Table Delegate functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if(tableView == buyCouponsTable){
            if(coupons == nil){
                
                return 0
                
            }
            return (coupons?.count)!
        }else{
            if(myCoupons == nil){
                
                return 0
                
            }
            return (myCoupons?.count)!
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == buyCouponsTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "couponCell", for: indexPath) as! CouponTableViewCell
            
            cell.dingLabel.text = coupons?[indexPath.row].coin
            
            cell.couponImage.image = UIImage.init(named: "couponD")
            
            LoadPicture().proLoad(view: cell.couponImage,picType: "coupon" , picModel: (coupons?[indexPath.row].url_pic)!){ resImage in
                
                cell.couponImage.image = resImage
                
                cell.couponImage.contentMode = UIViewContentMode.scaleAspectFill
                
            }
        
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCouponCell", for: indexPath) as! MyCouponTableViewCell
            
            let data : MyCouponListData = (myCoupons?[indexPath.row])!
            
            cell.titleLabel.text = data.title
            
            cell.detailLabel.text = data.coupon_code
            
            cell.couponImage.superview?.frame.size.width = (cell.couponImage.superview?.frame.height)!
            
            cell.tikView.frame.size.width = (cell.tikView.frame.height)
            
            if(data.count_used == "0"){
                
                cell.tikView.alpha = 0
                
            }else{
                
                cell.titleLabel.textColor = UIColor(hexString: "2196f3")
                
            }
            
            if((couponsPrePics?.count)! < indexPath.row + 1 || couponsPrePics?[indexPath.row] == nil){
                
                LoadPicture().proLoad(view : cell.couponImage,picType: "coupon", picModel: data.url_pic2!){ resImage in
                    
                    if((self.couponsPrePics?.count)! < (self.coupons?.count)!){
                        
                        for _ in self.coupons!{
                            
                            self.couponsPrePics?.append(nil)
                            
                        }
                        
                    }
                    
                    self.couponsPrePics?[indexPath.row] = resImage
                    
                    cell.couponImage.image = resImage
                    
                    cell.couponImage.contentMode = UIViewContentMode.scaleAspectFit
                    
                }
                
                
            } else {
                
                cell.couponImage.image = couponsPrePics?[indexPath.row]
                
                cell.couponImage.contentMode = UIViewContentMode.scaleAspectFit
                
            }
            
            
            return cell
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == buyCouponsTable){
            return self.view.frame.width * 426 / 1418
        }else{
            return self.view.frame.width * 70 / 320
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        loading.stopAnimating()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView == myCouponsTable){
            if(self.myCoupons?[indexPath.row].count_used != "0"){
                return
            }
            
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "CouponPopupViewController"))! as! CouponPopupViewController
            
            self.addChildViewController(vc)
            
            
            vc.view.frame = CGRect(x:0,y: 0,width: self.view.frame.size.width, height: self.view.frame.size.height)
            
            vc.view.tag = 1234

            UIView.transition(with: self.view, duration: 0.4 , options: UIViewAnimationOptions.curveEaseIn ,animations: {self.view.addSubview(vc.view)}, completion: nil)
            
            vc.didMove(toParentViewController: self)
            
            vc.setup(myCoupon: (self.myCoupons?[indexPath.row])!, coupon: nil , isMyCoupon: true)
            
            vc.view.alpha = 1
            
            self.view.alpha = 1

            self.myCouponsTable.deselectRow(at: indexPath, animated: true)
            
        }else{
        
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "CouponPopupViewController"))! as! CouponPopupViewController
            
            UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.addChildViewController(vc)
                
                vc.view.frame = CGRect(x:0,y: 0,width: self.view.frame.size.width, height: self.view.frame.size.height)
                
                vc.view.tag = 123
                
                self.view.addSubview(vc.view)
                
                vc.didMove(toParentViewController: self)
                
                vc.setup(myCoupon: nil, coupon: (self.coupons?[indexPath.row])! , isMyCoupon: false)
                
                vc.view.alpha = 1
                
                self.view.alpha = 1
      
            },completion : nil)
            
            
            self.buyCouponsTable.deselectRow(at: indexPath, animated: true)
            
        }
        
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    func deletSubView(){
        
        if let viewWithTag = self.view.viewWithTag(123) {
            
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
    
    
    func requestForGetCoupon(){
        
        let nextVc : CouponTabViewController = self
        
//        nextVc.loading.startAnimating()
        
        nextVc.buyCouponsTable.alpha = 1
        
//        nextVc.lowInternetView.alpha = 0
        
        let manager = SessionManager.default2
        
        manager.request(URLs.getCoupons , method: .post , parameters: GetCouponRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            ///////////////////////////
            ///////////////////////////
            ///////////////////////////
            
            switch (response.result) {
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    //HANDLE TIMEOUT HERE
                    
//                    nextVc.loading.stopAnimating()
                    
                    nextVc.buyCouponsTable.alpha = 0
                    
//                    nextVc.lowInternetView.alpha = 1
                    
                    return
                    
                }
                break
                
            default: break
                
            }
            
            ///////////////////////////
            ///////////////////////////
            ///////////////////////////
            
            if let JSON = response.result.value {
                
                print(GetCouponRequestModel.init().getParams())
                
                print("JSON ----------GET COUPON----------->>>> " ,JSON)
                //create my coupon response model
                if(CouponListResponseModel.init(json: JSON as! JSON)?.code == "5005"){
                    GlobalFields().goErrorPage(viewController: self)
                }
                if(CouponListResponseModel.init(json: JSON as! JSON)?.code == "200"){
                    
                    nextVc.coupons = CouponListResponseModel.init(json: JSON as! JSON)?.data
                    
//                    nextVc.loading.stopAnimating()
                    
                    nextVc.buyCouponsTable.reloadData()
                    
                    if(nextVc.coupons == nil || nextVc.coupons?.count == 0){
                        
                        nextVc.buyCouponsTable.alpha = 0
                        
                    }else{
                        
                        nextVc.buyCouponsTable.alpha = 1
                        
                    }
                    
                    
                }
                
                print(JSON)
                
            }
            
        }
        
        
    }
    
    
    func requestForMyCoupon(){

        let nextVc : CouponTabViewController = self

//        nextVc.loading.startAnimating()

        nextVc.myCouponsTable.alpha = 1

//        nextVc.lowInternetView.alpha = 0

        print(MyCouponRequestModel.init().getParams())

        let manager = SessionManager.default2

        manager.request(URLs.getMyCoupon , method: .post , parameters: MyCouponRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()

            ///////////////////////////
            ///////////////////////////
            ///////////////////////////

            switch (response.result) {
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    //HANDLE TIMEOUT HERE

//                    nextVc.loading.stopAnimating()

                    nextVc.myCouponsTable.alpha = 0

//                    nextVc.lowInternetView.alpha = 1

                    return

                }
                break

            default: break

            }

            ///////////////////////////
            ///////////////////////////
            ///////////////////////////

            if let JSON = response.result.value {

                print("JSON ----------MY COUPON----------->>>> " ,JSON)
                //create my coupon response model
                if(MyCouponListResponseModel.init(json: JSON as! JSON)?.code == "5005"){
                    GlobalFields().goErrorPage(viewController: self)
                }
                if( MyCouponListResponseModel.init(json: JSON as! JSON)?.code == "200"){
                    
                    GlobalFields.needUpdateMyCoupon = false

                    UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {

                        if(MyCouponListResponseModel.init(json: JSON as! JSON)?.data != nil){

                            nextVc.myCoupons = MyCouponListResponseModel.init(json: JSON as! JSON)?.data

                            //                            nextVc.couponsPrePics = [UIImage].init(reserveCapacity: (MyCouponListResponseModel.init(json: JSON as! JSON)?.data?.count)!)

                            nextVc.couponsPrePics = [UIImage].init()


//                            nextVc.loading.stopAnimating()

                            if(nextVc.myCoupons == nil || nextVc.myCoupons?.count == 0){

                                nextVc.myCouponsTable.alpha = 0

                            }else{

                                nextVc.myCouponsTable.alpha = 1

                            }

                        }else{
                            nextVc.myCouponsTable.alpha = 0
                        }

                        nextVc.myCouponsTable.reloadData()

                    }, completion: nil)


                }


                print(JSON)

            }

        }


    }
    
    
    @IBAction func swipeRight(_ sender: Any) {
        
        segmentedControl.selectedSegmentIndex = 0
        
        self.controlPages("")
        
    }
    
    @IBAction func swipeLeft(_ sender: Any) {
        
        segmentedControl.selectedSegmentIndex = 1
        
        self.controlPages("")
        
    }
    
    
}









