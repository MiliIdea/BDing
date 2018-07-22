//
//  CListBuyerData.swift
//  BDing
//
//  Created by MILAD on 1/27/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class CListBuyerData : Decodable{
    
    var username : String?
    
    var user_id : String?
    
    var name_family : String?
    
    var pic : String?
    
    var buyer_id : String?
    
    var status : String?
    
    required init?(json: JSON) {
        
        self.username = "username" <~~ json
        
        self.user_id = "user_id" <~~ json
        
        self.name_family = "name_family" <~~ json
        
        self.pic = "pic" <~~ json
        
        self.buyer_id = "buyer_id" <~~ json
        
        self.status = "status" <~~ json
        
    }
    
}
