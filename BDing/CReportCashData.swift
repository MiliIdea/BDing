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
    
    var name_family : String?
    
    var pic : String?
    
    required init?(json: JSON) {
        
        self.total = "total" <~~ json
        
        self.cash_title = "cash_title" <~~ json
        
        self.name_family = "name_family" <~~ json
        
        self.pic = "pic" <~~ json
        
    }
    
}
