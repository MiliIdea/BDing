//
//  CCheckoutData.swift
//  BDing
//
//  Created by MILAD on 3/3/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class CCheckoutData : Decodable{
    
    var price : String?
    
    var cash_title : String?
    
    var start_time : String?
    
    var code : String?
    
    
    
    required init?(json: JSON) {
        
        self.price = "price" <~~ json
        
        self.cash_title = "cash_title" <~~ json
        
        self.start_time = "start_time" <~~ json
        
        self.code = "code" <~~ json
        
    }
    
}
