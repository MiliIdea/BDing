//
//  CLoginData.swift
//  BDing
//
//  Created by MILAD on 2/14/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class CLoginData : Decodable{
    
    var token : String?
    
    var customer_id : String? // id forushagahe
    
    var name_family : String?
    
    var pic: String?
    
    var user: String?
    
    required init?(json: JSON) {
        
        self.token = "token" <~~ json
        
        self.customer_id = "customer_id" <~~ json
        
        self.name_family = "name_family" <~~ json
        
        self.user = "user" <~~ json
        
        self.pic = "pic" <~~ json
        
    }
    
}
