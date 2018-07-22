//
//  CashCloseViewController.swift
//  BDing
//
//  Created by MILAD on 2/27/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit

class CashCloseViewController: UIViewController {

    @IBOutlet weak var cashName: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cashName.text = GlobalFields.cLastCashData?.cash_title
        
        price.text = GlobalFields.cLastCashData?.total_price
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeCash(_ sender: Any) {
        
        request(URLs.cCheckout , method: .post , parameters: CCheckoutRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------checkout----------->>>> " , JSON)
                
                let obj = CCheckoutResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                    
                    let objVC : UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ProfilePageViewController"))! as! ProfilePageViewController
                    
                    self.tabBarController?.tabBar.isHidden = false
                    
                    self.navigationController?.pushViewController(objVC, animated: true)
                    
                    
                    
                }
                
            }
            
        }
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
