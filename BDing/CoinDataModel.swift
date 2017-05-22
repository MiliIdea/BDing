//
//  CoinDataModel.swift
//  BDing
//
//  Created by MILAD on 5/21/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class CoinDataModel : Decodable{
    
    var coin : String?
    
    var last_user_coin : String?
    
    var user_coin : String?
    
    var msg : String?
    
    required init?(json: JSON) {
        
        self.coin = "coin" <~~ json
        
        self.last_user_coin = "last_user_coin" <~~ json
        
        self.user_coin = "user_coin" <~~ json
        
        self.msg = "msg" <~~ json
        
    }
    
}
