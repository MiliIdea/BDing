//
//  CLastCashResponseModel.swift
//  BDing
//
//  Created by MILAD on 2/28/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class CLastCashResponseModel : Decodable{
    
    var code : String?
    
    var data : CLastCashData?
    
    required init?(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.data = "data" <~~ json
        
    }
    
}
