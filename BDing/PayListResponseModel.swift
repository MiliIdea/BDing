//
//  PayListResponseModel.swift
//  BDing
//
//  Created by MILAD on 4/29/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class PayListResponseModel : Decodable{
    
    var code : String?
    
    var data : [PayListData]?
    
    
    
    required init?(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.data = "data" <~~ json
        
        
    }
    
}
