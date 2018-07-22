//
//  CTransactionReportData.swift
//  BDing
//
//  Created by MILAD on 3/5/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class CTransactionReportData : Decodable{
    
    var name_family : String?
    
    var social_name : String?
    
    var price : String?
    
    var date_time : String?
    
    var status_code : String?
    
    var t_code : String?
    
    var invoice_number : String?
    
    var pic : String?
    
    
    
    required init?(json: JSON) {
        
        self.price = "price" <~~ json
        
        self.social_name = "social_name" <~~ json
        
        self.price = "price" <~~ json
        
        self.date_time = "date_time" <~~ json
        
        self.status_code = "status_code" <~~ json
        
        self.t_code = "t_code" <~~ json
        
        self.invoice_number = "invoice_number" <~~ json
        
        self.pic = "pic" <~~ json
        
    }
    
}
