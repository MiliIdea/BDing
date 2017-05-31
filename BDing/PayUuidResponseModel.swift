//
//  PayUuidResponseModel.swift
//  BDing
//
//  Created by MILAD on 5/31/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class PayUuidResponseModel : Decodable{
    
    var code : String?
    
    var result : [String]?
    
    
    
    required init?(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.result = "result" <~~ json
        
    }
    
}
