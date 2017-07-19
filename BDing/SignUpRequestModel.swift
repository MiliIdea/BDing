//
//  SignUpModel.swift
//  BDing
//
//  Created by MILAD on 3/8/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class SignUpRequestModel {
    
    // describtion : bdate should be d/m/y in miladi
    
    init(USERNAME: String! , PASSWORD: String! , SOCIALNAME : String! , GENDER :String? , BDATE : String? , NAME: String? , FAMILYNAME : String? ,EMAIL : String?) {
        
        self.USERNAME = USERNAME
        
        self.PASSWORD = PASSWORD
        
        self.SOCIALNAME = SOCIALNAME
        
        self.BDATE = BDATE
        
        self.GENDER = GENDER
        
        self.KEY = PASSWORD.md5()
   
        self.TYPE = "tell"
        
        self.NAME = NAME
        
        self.FAMILYNAME = FAMILYNAME
        
        if(NAME != nil && FAMILYNAME != nil){
            
            var fn : String = NAME!
            
            fn.append(" ")
            
            fn.append(FAMILYNAME!)
            
            self.FULLNAME = fn
            
        }
        
        self.EMAIL = EMAIL

        var temp = self.USERNAME
        
        temp?.append(self.PASSWORD)
        
        temp?.append(self.TYPE)
        
        self.HASH =  temp?.md5()
        
    }
    
    var FULLNAME: String?
    
    var NAME: String?
    
    var FAMILYNAME: String?
    
    var EMAIL: String?
    
    var USERNAME: String!
    
    var PASSWORD: String!
    
    var SOCIALNAME: String!
    
    var KEY: String!
    
    var BDATE: String?
    
    var GENDER: String?
    
    var TYPE: String!
    
    var HASH: String!
    
    func getParams() -> [String: Any]{
        return ["username": USERNAME , "password": PASSWORD , "type":TYPE , "hash": HASH , "key": KEY , "gender": GENDER , "bdate": BDATE , "fullname": FULLNAME , "email" : EMAIL, "social_name" : SOCIALNAME , "name" : NAME , "family" : FAMILYNAME]
        
    }
    
}





















