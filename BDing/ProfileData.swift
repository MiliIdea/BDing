//
//  ProfileData.swift
//  BDing
//
//  Created by MILAD on 3/14/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class ProfileData : Decodable{
    
    var bday : String?
    
    var birthdate : String?
    
    var all_coin : String?
    
    var bmonth : String?
    
    var byear : String?
    
    var count_coupon : String?
    
    var create_date : String?
    
    var email : String?
    
    var family : String?
    
    var fullname : String?
    
    var gender : String?
    
    var last_login : String?
    
    var mobile : String?
    
    var name : String?
    
    var type : String?
    
    var url_pic : String?
    
    var social_name : String!
    
    
    
    
    required init?(json: JSON) {
        
        self.bday = "bday" <~~ json
        
        self.all_coin = "all_coin" <~~ json
        
        self.birthdate = "birthdate" <~~ json
        
        self.bmonth = "bmonth" <~~ json
        
        self.byear = "byear" <~~ json
        
        self.count_coupon = "count_coupon" <~~ json
        
        self.create_date = "create_date" <~~ json
        
        self.email = "email" <~~ json
        
        self.family = "family" <~~ json
        
        self.fullname = "fullname" <~~ json
        
        self.gender = "gender" <~~ json
        
        self.last_login = "last_login" <~~ json
        
        self.mobile = "mobile" <~~ json
        
        self.name = "name" <~~ json
        
        self.type = "type" <~~ json
        
        self.url_pic = "url_pic" <~~ json
        
        self.social_name = "social_name" <~~ json
        
    }
    
}
