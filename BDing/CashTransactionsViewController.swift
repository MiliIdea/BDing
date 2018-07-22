//
//  CashTransactionsViewController.swift
//  BDing
//
//  Created by MILAD on 2/27/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit

class CashTransactionsViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var beforeMonthImage: UIImageView!
    
    @IBOutlet weak var lastWeekImage: UIImageView!
    
    @IBOutlet weak var todayImage: UIImageView!
    
    @IBOutlet weak var dButton: UIButton!
    
    @IBOutlet weak var mButton: UIButton!
    
    @IBOutlet weak var wButton: UIButton!
    
    var transactions : [CTransactionReportData] = [CTransactionReportData]()
    
    @IBOutlet weak var emptyImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.delegate = self
        
        table.dataSource = self
        
        self.table.register(UINib(nibName: "CTransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "CTransaction")
        
        table.layer.backgroundColor = UIColor.clear.cgColor
        
        today("")
        
        emptyImage.alpha = 0
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func beforeMonth(_ sender: Any) {
        
        table.alpha = 0
        
        todayImage.alpha = 0
        
        lastWeekImage.alpha = 0
        
        beforeMonthImage.alpha = 1
        
        dButton.setTitleColor(UIColor.init(hex: "2D44A8"), for: .normal)
        
        mButton.setTitleColor(UIColor.init(hex: "ffffff"), for: .normal)
        
        wButton.setTitleColor(UIColor.init(hex: "2D44A8"), for: .normal)
        
        request(URLs.cTransaction , method: .post , parameters: CTransactionReportRequestModel.init(DAY: "30").getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------Transaction Today----------->>>> " , JSON)
                
                let obj = CTransactionReportResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                    
                    if(obj?.data != nil){
                        
                        self.transactions = (obj?.data)!
                        
                        self.table.reloadData()
                        
                        if((obj?.data?.count)! == 0){
                            self.emptyImage.alpha = 1
                            self.table.alpha = 0
                        }else{
                            self.emptyImage.alpha = 0
                            self.table.alpha = 1
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func lastWeek(_ sender: Any) {
        
        table.alpha = 0
        
        todayImage.alpha = 0
        
        lastWeekImage.alpha = 1
        
        beforeMonthImage.alpha = 0
        
        dButton.setTitleColor(UIColor.init(hex: "2D44A8"), for: .normal)
        
        mButton.setTitleColor(UIColor.init(hex: "2D44A8"), for: .normal)
        
        wButton.setTitleColor(UIColor.init(hex: "ffffff"), for: .normal)
        
        print(CTransactionReportRequestModel.init(DAY: "7").getParams())
        
        request(URLs.cTransaction , method: .post , parameters: CTransactionReportRequestModel.init(DAY: "7").getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------Transaction Today----------->>>> " , JSON)
                
                let obj = CTransactionReportResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                    
                    if(obj?.data != nil){
                        
                        self.transactions = (obj?.data)!
                        
                        self.table.reloadData()
                        
                        if((obj?.data?.count)! == 0){
                            self.emptyImage.alpha = 1
                            self.table.alpha = 0
                        }else{
                            self.emptyImage.alpha = 0
                            self.table.alpha = 1
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func today(_ sender: Any) {
        
        table.alpha = 0
        
        todayImage.alpha = 1
        
        lastWeekImage.alpha = 0
        
        beforeMonthImage.alpha = 0
        
        dButton.setTitleColor(UIColor.init(hex: "ffffff"), for: .normal)
        
        mButton.setTitleColor(UIColor.init(hex: "2D44A8"), for: .normal)
        
        wButton.setTitleColor(UIColor.init(hex: "2D44A8"), for: .normal)
        
        
        request(URLs.cTransaction , method: .post , parameters: CTransactionReportRequestModel.init(DAY: "1").getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------Transaction Today----------->>>> " , JSON)
                
                let obj = CTransactionReportResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                    
                    if(obj?.data != nil){
                    
                        self.transactions = (obj?.data)!
                        
                        self.table.reloadData()
                        
                        if((obj?.data?.count)! == 0){
                            self.emptyImage.alpha = 1
                            self.table.alpha = 0
                        }else{
                            self.emptyImage.alpha = 0
                            self.table.alpha = 1
                        }
                        
                        
                        
                    }else{
                        self.emptyImage.alpha = 1
                        self.table.alpha = 0
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    
    
    ////
    ////
    ////
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.transactions.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CTransaction", for: indexPath) as! CTransactionTableViewCell
        
        let row : CTransactionReportData = (self.transactions[indexPath.row])
        
        cell.name.text = row.name_family
        
        cell.userName.text = row.social_name
        
        cell.factorNumber.text = row.invoice_number
        
        cell.followUpNumber.text = row.t_code
        
        cell.price.text = row.price!
        
        cell.profileImage.frame.size.width = cell.profileImage.frame.height
        
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2
        
        cell.profileImage.clipsToBounds = true
        
        cell.profileImage.layer.masksToBounds = true
        
        if(row.pic != nil && row.pic != ""){
            
            let imageData = NSData(base64Encoded: row.pic! , options:.ignoreUnknownCharacters)
            
            cell.profileImage.image = UIImage(data: imageData as! Data)!
            
        }
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
        if(row.date_time != nil && row.date_time != ""){
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            
            formatter.calendar = Calendar(identifier: .gregorian)
            
            let d = formatter.date(from: row.date_time!)
            
            formatter.dateFormat = "yy/MM/dd"
            
            formatter.calendar = Calendar(identifier: .persian)
            
            cell.date.text = formatter.string(from: d!)
            
            formatter.dateFormat = "hh:mm"
            
            cell.time.text = formatter.string(from: d!)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (115 / 667) * self.view.frame.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.table.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}
