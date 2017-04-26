//
//  TakeCouponViewController.swift
//  BDing
//
//  Created by MILAD on 4/26/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit

class TakeCouponViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.register(UINib(nibName: "CouponTableViewCell", bundle: nil), forCellReuseIdentifier: "couponCell")
        
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
        return 15
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "couponCell", for: indexPath)
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        let vc = self.parent as! ProfilePageViewController
        
        vc.deletSubView()
        
    }


}
