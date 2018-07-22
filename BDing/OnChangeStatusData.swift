//
//  OnChangeStatusData.swift
//  BDing
//
//  Created by MILAD on 2/14/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class OnChangeStatusData : Decodable{
    
    var modifyDate : String?
    
    var status : String?
    
    required init?(json: JSON) {
        
        self.modifyDate = "modify_date" <~~ json
        
        self.status = "status" <~~ json
        
    }
    
}

