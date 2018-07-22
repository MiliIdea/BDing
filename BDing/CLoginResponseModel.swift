//
//  CLoginResponseModel.swift
//  BDing
//
//  Created by MILAD on 1/27/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class CLoginResponseModel : Decodable{
    
    var code : String?
    
    var msg : String?

    var data : CLoginData?
    
    required init?(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.msg = "msg" <~~ json
        
        self.data = "data" <~~ json
    }
    
}
