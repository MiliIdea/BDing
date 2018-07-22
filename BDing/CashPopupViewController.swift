//
//  CashPopupViewController.swift
//  BDing
//
//  Created by MILAD on 2/4/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit

class CashPopupViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var priceTextInput: UITextField!
    
    @IBOutlet weak var factorNumberTextInput: UITextField!
    
    var userID : String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup(data : CListBuyerData){
        
        self.name.text = data.name_family
        
        self.userName.text = data.username
        
        self.userID = data.buyer_id
        
        if(data.pic != nil && data.pic != ""){
            
            let imageData = NSData(base64Encoded: data.pic! , options:.ignoreUnknownCharacters)
            
            profileImage.image = UIImage(data: imageData as! Data)!
            
        }
    }
    
    
    @IBAction func confirmPay(_ sender: Any) {
        if(self.priceTextInput.text != ""){
            
            request(URLs.cDetermine , method: .post , parameters: CDetermineRequestModel.init(BUYER_ID: self.userID, PRICE: self.priceTextInput.text, FACTORNUM: self.factorNumberTextInput.text).getParams(), encoding: JSONEncoding.default).responseJSON { response in
                print()
                
                if let JSON = response.result.value {
                    
                    print("JSON ----------Determine----------->>>> " , JSON)
                    
                    let obj = CDetermineResponseModel.init(json: JSON as! JSON)
                    
                    if ( obj?.code == "200" ){
                        
                        GlobalFields.payStatus.append((obj?.data?.code)!)
                        
                        self.close("")
                        
                    }
                    
                }
                
            }
            
        }
    }
    
    
    @IBAction func close(_ sender: Any) {
        
        if(self.parent is CashDeskHomeViewController){
            
            let vc = self.parent as! CashDeskHomeViewController
            
            vc.waitingTable.reloadData()
            
            vc.deletSubView()
            
        }
        
    }
    
    @IBAction func tapGesture(_ sender: Any) {
        self.view.endEditing(true)
    }
    
}
