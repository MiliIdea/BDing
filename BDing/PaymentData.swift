//
//  PaymentData.swift
//  BDing
//
//  Created by MILAD on 10/14/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class PaymentData : Decodable{
    
    var code : String?
    
    required init?(json: JSON) {
        
        self.code = "code" <~~ json
        
    }
    
}
