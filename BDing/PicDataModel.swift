//
//  PicDataModel.swift
//  BDing
//
//  Created by MILAD on 4/9/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class PicDataModel : Decodable{
    
    var data : String?
    
    var status: String?
    
    var type: String?
    
    var code: String?
    
    var send_code: String?
    
    
    required init?(json: JSON) {
        
        self.data = "data" <~~ json
        
        self.status = "status" <~~ json
        
        self.type = "type" <~~ json
        
        self.code = "code" <~~ json
        
        self.send_code = "send_code" <~~ json
        
    }
    
}
