//
//  CheckResponseModel.swift
//  BDing
//
//  Created by MILAD on 12/5/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class CheckResponseModel : Decodable{
    
    var code : String?
    
    var msg : String?
    
    var data : CheckData?
    
    required init(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.msg = "msg" <~~ json
        
        self.data = "data" <~~ json
        
    }
    
}
