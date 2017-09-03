//
//  BeaconListResponseModel.swift
//  BDing
//
//  Created by MILAD on 3/14/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class BeaconListResponseModel : Decodable{
    
    var code : String?
    
    var data : [BeaconListData]?
    
    var msg : String?
    
    
    
    required init?(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.data = "data" <~~ json
        
        self.msg = "msg" <~~ json
        
        
    }
    
}
