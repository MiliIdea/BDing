//
//  MyCouponListResponseModel.swift
//  BDing
//
//  Created by MILAD on 4/29/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class MyCouponListResponseModel : Decodable{
    
    var code : String?
    
    var data : [MyCouponListData]?
    
    
    
    required init?(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.data = "data" <~~ json
        
        
    }
    
}
