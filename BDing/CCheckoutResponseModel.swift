//
//  CCheckoutResponseModel.swift
//  BDing
//
//  Created by MILAD on 3/3/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class CCheckoutResponseModel : Decodable{
    
    var code : String?
    
    var data : CCheckoutData?
    
    required init?(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.data = "data" <~~ json
        
    }
    
}
