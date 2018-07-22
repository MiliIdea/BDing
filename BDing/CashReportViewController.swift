//
//  CashReportViewController.swift
//  BDing
//
//  Created by MILAD on 2/27/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit

class CashReportViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var cashName: UILabel!
    
    @IBOutlet weak var cash: UILabel!
    
    @IBOutlet weak var table: UITableView!
    
    
    @IBOutlet weak var moreButton: DCBorderedView!
    
    @IBOutlet weak var emptyImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.delegate = self
        
        table.dataSource = self
        
        self.table.register(UINib(nibName: "ReportHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "reportHistoryCell")
        
        name.text = GlobalFields.cLastCashData?.name_family
        
        cashName.text = GlobalFields.cLastCashData?.cash_title
        
        cash.text = GlobalFields.cLastCashData?.total_price
        
        table.layer.backgroundColor = UIColor.clear.cgColor
        
        if(GlobalFields.cPic != nil && GlobalFields.cPic != ""){
            
            let imageData = NSData(base64Encoded: (GlobalFields.cPic) , options:.ignoreUnknownCharacters)
            
            self.profilePic.image = UIImage(data: imageData as! Data)!
            
        }
        
        table.isScrollEnabled = false
        
        if((GlobalFields.cReportCashResponseModel?.data?.count)! > 3){
            moreButton.alpha = 1
        }else{
            moreButton.alpha = 0
        }
        
        if(GlobalFields.cReportCashResponseModel?.data?.count == 0){
            table.alpha = 0
            emptyImage.alpha = 1
        }else{
            table.alpha = 1
            emptyImage.alpha = 0
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func closeCash(_ sender: Any) {
    }
    
    @IBAction func seeMore(_ sender: Any) {
        
        
        
    }
    
    @IBAction func back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
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
        return (GlobalFields.cReportCashResponseModel?.data?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportHistoryCell", for: indexPath) as! ReportHistoryTableViewCell
        
        let row : CReportCashData = (GlobalFields.cReportCashResponseModel?.data?[indexPath.row])!
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
        cell.cashName.text = row.cash_title
        
        cell.price.text = row.total
        
        if(row.close_cash == row.name_family ){
            
            cell.whoClosed.text = "توسط صندوقدار"
            cell.circleColor.backgroundColor = UIColor.fromHex(hexString: "2D44A8")
            
        }else{
            
            cell.whoClosed.text = "توسط مدیر سازمان"
            cell.circleColor.backgroundColor = UIColor.fromHex(hexString: "B3A6F5")
        }
        
        if(row.end_time != nil && row.end_time != ""){
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            
            formatter.calendar = Calendar(identifier: .gregorian)
            
            let d = formatter.date(from: row.end_time!)
            
            formatter.dateFormat = "yy/MM/dd  hh:mm"
            
            formatter.calendar = Calendar(identifier: .persian)
            
            cell.dateAndTime.text = formatter.string(from: d!)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (72 / 667) * self.view.frame.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.table.deselectRow(at: indexPath, animated: true)
    }
    

}
