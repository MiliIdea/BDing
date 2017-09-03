//
//  FAQResponseModel.swift
//  BDing
//
//  Created by MILAD on 8/15/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class FAQResponseModel : Decodable{
    
    var code : String?
    
    var data : [FAQData]?
    
    
    
    required init?(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.data = "data" <~~ json
        
    }
    
}
