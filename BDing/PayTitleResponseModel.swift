//
//  PayTitleResponseModel.swift
//  BDing
//
//  Created by MILAD on 5/31/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class PayTitleResponseModel : Decodable{
    
    var code : String?
    
    var result : ResultTitle?
    
    
    
    required init?(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.result = "result" <~~ json
        
        
    }
    
}


