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
    
    
    
}
