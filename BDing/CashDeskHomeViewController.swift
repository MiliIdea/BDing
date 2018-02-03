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
    
    @IBOutlet weak var profileImage: DesignableImageView!
    
    @IBOutlet weak var cashierName: UILabel!
    
    @IBOutlet weak var cashDeskName: UILabel!
    
    @IBOutlet weak var totalTransactions: UILabel!
    
    @IBOutlet weak var settingButton: DCBorderedButton!
    
    @IBOutlet weak var transactionsReportsButton: DCBorderedButton!
    
    @IBOutlet weak var transactionsButton: DCBorderedButton!
    
    @IBOutlet weak var holdingView: DCBorderedView!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var maximizeButton: UIButton!
    
    @IBOutlet weak var waitingTable: UITableView!
    
    
    var cBuyerData : [CListBuyerData] = [CListBuyerData]()
    
    var isMaximize : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        
        waitingTable.delegate = self
        
        waitingTable.dataSource = self
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1000 )
        
        self.waitingTable.register(UINib(nibName: "CashDeskTableViewCell", bundle: nil), forCellReuseIdentifier: "cashDeskCell")
        
        self.cashierName.text = GlobalFields.cReportCashData?.name_family
        
        self.cashDeskName.text = GlobalFields.cReportCashData?.cash_title
        
        self.totalTransactions.text = GlobalFields.cReportCashData?.total
        
        if(GlobalFields.cReportCashData?.pic != nil && GlobalFields.cReportCashData?.pic != ""){
            
            let imageData = NSData(base64Encoded: (GlobalFields.cReportCashData?.pic!)! , options:.ignoreUnknownCharacters)
            
            self.profileImage.image = UIImage(data: imageData as! Data)!
            
        }
        
        //viewye profilePic va seta buttone vasat bayad gerd bashe
    
        
        self.navigationController?.isNavigationBarHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goSetting(_ sender: Any) {
    }
  
    @IBAction func goTransactionsReports(_ sender: Any) {
    }
    
    @IBAction func goTransactions(_ sender: Any) {
    }
    
    @IBAction func refreshList(_ sender: Any) {
        
        request(URLs.cListBuyer , method: .post , parameters: CListBuyerRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------refresh list----------->>>> " , JSON)
                
                let obj = CListBuyerResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                    
                    self.cBuyerData = (obj?.data)!
                    
                    self.waitingTable.reloadData()
                    
                    self.navigationController?.isNavigationBarHidden = true
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func maximize(_ sender: Any) {
        
        // bayad table ta bala biad
        
        if(isMaximize == false){
            isMaximize = true
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.holdingView.frame.origin.y = 30
                
                self.holdingView.frame.size.height = 600
                
                self.scrollView.isScrollEnabled = false
                
            },completion: nil)
            
        }else{
            isMaximize = false
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.holdingView.frame.origin.y = 450
                
                self.holdingView.frame.size.height = 316
                
                self.scrollView.isScrollEnabled = true
                
            },completion: nil)
            
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cBuyerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cashDeskCell", for: indexPath) as! CashDeskTableViewCell
        
        cell.name.text = cBuyerData[indexPath.row].name_family
        
        cell.userName.text = cBuyerData[indexPath.row].user_id

        if(cBuyerData[indexPath.row].pic != nil && cBuyerData[indexPath.row].pic != ""){
        
            let imageData = NSData(base64Encoded: cBuyerData[indexPath.row].pic! , options:.ignoreUnknownCharacters)
            
            cell.profileImage.image = UIImage(data: imageData as! Data)!
            
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        
    }
    
    

}
