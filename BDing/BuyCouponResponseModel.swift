//
//  buyCouponResponseModel.swift
//  BDing
//
//  Created by MILAD on 8/22/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class BuyCouponResponseModel : Decodable{
    
    var code : String?
    
    var data : BuyCouponData?
    
    required init?(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.data = "data" <~~ json
        
    }
    
}
