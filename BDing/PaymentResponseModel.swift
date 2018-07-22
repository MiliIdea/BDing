//
//  PaymentResponseModel.swift
//  BDing
//
//  Created by MILAD on 10/14/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class PaymentResponseModel : Decodable{
    
    var code : String?
    
    var data : PaymentData?
    
    required init?(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.data = "data" <~~ json
        
    }
    
}
