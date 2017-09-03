//
//  BuyCouponData.swift
//  BDing
//
//  Created by MILAD on 8/22/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class BuyCouponData : Decodable{
    
    var msg : String?
    
    required init?(json: JSON) {
        
        self.msg = "msg" <~~ json
        
        
    }
    
}
