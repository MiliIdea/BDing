//
//  SetCoinResponseModel.swift
//  BDing
//
//  Created by MILAD on 5/21/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation


class SetCoinResponseModel : Decodable{
    
    var code : String?
    
    var data : CoinDataModel?
    
    var msg : String?
    
    
    required init?(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.data = "data" <~~ json
        
        self.msg = "msg" <~~ json
    }
    
}
