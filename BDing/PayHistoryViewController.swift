//
//  PayHistoryViewController.swift
//  BDing
//
//  Created by MILAD on 4/26/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit

class PayHistoryViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var lowInternetView: UIView!
    
    var payHistory: [PayListData] = [PayListData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loading.hidesWhenStopped = true;
        loading.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray;
        loading.startAnimating()
        
        self.automaticallyAdjustsScrollViewInsets = false
        table.contentInset = UIEdgeInsets.zero
        
        self.table.register(UINib(nibName: "PayHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "historyCell")

        table.dataSource = self
        table.delegate = self
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return payHistory.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! PayHistoryTableViewCell
        
        cell.title.text = payHistory[indexPath.row].title_pay
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        formatter.calendar = Calendar(identifier: .gregorian)
        
        let d1 = formatter.date(from: (payHistory[indexPath.row].date)!)
        
        formatter.dateFormat = "yy/MM/dd"
        
        formatter.calendar = Calendar(identifier: .persian)
        
        cell.detail.text = formatter.string(from: d1!)
        
        cell.price.text = payHistory[indexPath.row].price!
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.view.frame.width * 7 / 32
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loading.stopAnimating()
    }
    
    @IBAction func backButton(_ sender: Any) {
        
         _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func lowInternetAction(_ sender: Any) {
        
        requestForPayHistory()
        
    }
    
    
    func requestForPayHistory(){
        
        let nextVc : PayHistoryViewController = self
        
        nextVc.loading.startAnimating()
        
        nextVc.table.alpha = 1
        
        nextVc.lowInternetView.alpha = 0
        
        let manager = SessionManager.default2
        
        manager.request(URLs.paylistHistory , method: .post , parameters: PayListRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            ///////////////////////////
            ///////////////////////////
            ///////////////////////////
            
            switch (response.result) {
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    //HANDLE TIMEOUT HERE
                    
                    nextVc.loading.stopAnimating()
                    
                    nextVc.table.alpha = 0
                    
                    nextVc.lowInternetView.alpha = 1
                    
                    return
                    
                }
                break
                
            default: break
                
            }
            
            ///////////////////////////
            ///////////////////////////
            ///////////////////////////
            
            if let JSON = response.result.value {
                
                print("JSON ----------MY HISTORY----------->>>> ")
                //create my coupon response model
                if(PayListResponseModel.init(json: JSON as! JSON)?.code == "200"){
                    
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        
                        if(PayListResponseModel.init(json: JSON as! JSON)?.data == nil){
                            
                            // data nadarim
                            
                        }else{
                            nextVc.payHistory = (PayListResponseModel.init(json: JSON as! JSON)?.data)!
                            
                            nextVc.table.reloadData()
                            
                        }
                        
                        if(nextVc.payHistory.count == 0){
                            
                            nextVc.table.alpha = 0
                            
                        }else{
                            
                            nextVc.table.alpha = 1
                            
                        }
                        
                    }, completion: nil)
                    
                }
                
                
                print(JSON)
                
            }
            
        }
        
        
    }
    
}
