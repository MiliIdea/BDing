//
//  NPayRegisterResponseModel.swift
//  BDing
//
//  Created by MILAD on 3/11/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class NPayRegisterResponseModel : Decodable{
    
    var status : String?
    
    var type : String?
    
    var code : String?
    
    required init?(json: JSON) {
        
        self.status = "status" <~~ json
        
        self.type = "type" <~~ json
        
        self.code = "code" <~~ json
        
    }
    
}
