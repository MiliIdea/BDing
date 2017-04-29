//
//  CouponListResponseModel.swift
//  BDing
//
//  Created by MILAD on 4/28/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class CouponListResponseModel : Decodable{
    
    var code : String?
    
    var data : [CouponListData]?
    
    
    
    required init?(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.data = "data" <~~ json
        
        
    }
    
}
