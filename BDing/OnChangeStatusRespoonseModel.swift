//
//  OnChangeStatusRespoonseModel.swift
//  BDing
//
//  Created by MILAD on 2/14/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class OnChangeStatusRespoonseModel : Decodable{
    
    var code : String?
    
    var data : OnChangeStatusData?
    
    var msg : String?
    
    required init?(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.data = "data" <~~ json
        
        self.msg = "msg" <~~ json
        
    }
    
}
