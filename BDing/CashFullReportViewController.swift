//
//  CashFullReportViewController.swift
//  BDing
//
//  Created by MILAD on 3/3/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit

class CashFullReportViewController: UIViewController  ,UITableViewDelegate ,UITableViewDataSource{

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.delegate = self
        
        table.dataSource = self
        
        self.table.register(UINib(nibName: "ReportHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "reportHistoryCell")
        
        table.layer.backgroundColor = UIColor.clear.cgColor
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (GlobalFields.cReportCashResponseModel?.data?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportHistoryCell", for: indexPath) as! ReportHistoryTableViewCell
        
        let row : CReportCashData = (GlobalFields.cReportCashResponseModel?.data?[indexPath.row])!
        
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
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (72 / 667) * self.view.frame.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.table.deselectRow(at: indexPath, animated: true)
    }
    
    
}
