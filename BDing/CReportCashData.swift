//
//  CReportCashData.swift
//  BDing
//
//  Created by MILAD on 1/27/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class CReportCashData : Decodable{
    
    var total : String?
    
    var cash_title : String?
    
    var start_time : String?
    
    var end_time : String?
    
    var name_family : String?
    
    var close_cash : String?
    
    var code : String?
    
    required init?(json: JSON) {
        
        self.total = "total" <~~ json
        
        self.cash_title = "cash_title" <~~ json
        
        self.start_time = "start_time" <~~ json
        
        self.end_time = "end_time" <~~ json
        
        self.name_family = "name_family" <~~ json
        
        self.close_cash = "close_cash" <~~ json
        
        self.code = "code" <~~ json
        
    }
    
}
