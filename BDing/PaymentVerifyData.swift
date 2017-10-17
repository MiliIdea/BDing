//
//  PaymentVerifyData.swift
//  BDing
//
//  Created by MILAD on 10/14/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class PaymentVerifyData : Decodable{
    
    var code : String?
    
    var url : String?
    
    var all_ding : String?
    
    required init?(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.url = "url" <~~ json
        
        self.all_ding = "all_ding" <~~ json
        
    }
    
}
