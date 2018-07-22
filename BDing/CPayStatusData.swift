//
//  CPayStatusData.swift
//  BDing
//
//  Created by MILAD on 1/27/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class CPayStatusData : Decodable{
    
    var price : String?
    
    var cash_title : String?
    
    var start_time : String?
    
    var code : String?
    
    var status_pay: String?
    
    var buyer_id: String?
    
    var name_family: String?
    
    var pay_cash_title: String?
    
    required init?(json: JSON) {
        
        self.price = "price" <~~ json
        
        self.cash_title = "cash_title" <~~ json
        
        self.start_time = "start_time" <~~ json
        
        self.code = "t_code" <~~ json
        
        self.status_pay = "status_pay" <~~ json
        
        self.buyer_id = "buyer_id" <~~ json
        
        self.name_family = "name_family" <~~ json
        
        self.pay_cash_title = "pay_cash_title" <~~ json
        
    }
    
}
