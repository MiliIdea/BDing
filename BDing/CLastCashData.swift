//
//  CLastCashData.swift
//  BDing
//
//  Created by MILAD on 2/28/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class CLastCashData : Decodable{
    
    var username : String?
    
    var name_family : String?
    
    var total_price : String?
    
    var cash_title : String?
    
    var status : String?
    
    var start_date : String?
    
    var end_date : String?
    
    var cash_id : String?
    
    
    
    required init?(json: JSON) {
        
        self.username = "username" <~~ json
        
        self.name_family = "name_family" <~~ json
        
        self.total_price = "total_price" <~~ json
        
        self.cash_title = "cash_title" <~~ json
        
        self.status = "status" <~~ json
        
        self.start_date = "start_date" <~~ json
        
        self.end_date = "end_date" <~~ json
        
        self.cash_id = "cash_id" <~~ json
        
    }
    
}
