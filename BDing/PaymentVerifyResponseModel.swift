//
//  PaymentVerifyResponseModel.swift
//  BDing
//
//  Created by MILAD on 10/14/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class PaymentVerifyResponseModel : Decodable{
    
    var code : String?
    
    var data : PaymentVerifyData?
    
    var msg : String?
    
    required init?(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.data = "data" <~~ json
        
        self.msg = "msg" <~~ json
        
    }
    
}
