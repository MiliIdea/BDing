//
//  SignUpModel.swift
//  BDing
//
//  Created by MILAD on 3/8/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class SignUpRequestModel {
    
    init(USERNAME: String! , PASSWORD: String!) {
        
        self.USERNAME = USERNAME
        
        self.PASSWORD = PASSWORD
        
        self.KEY = PASSWORD.md5()
        
        if USERNAME.contains("@") && USERNAME.contains(".") {
            
            self.TYPE = "email"
            
        }else{
            
            self.TYPE = "tell"
            
        }
        
        var temp = self.USERNAME
        
        temp?.append(self.PASSWORD)
        
        temp?.append(self.TYPE)
        
        self.HASH =  temp?.md5()
        
    }
    
    var FULLNAME: String?
    
    var USERNAME: String!
    
    var PASSWORD: String!
    
    var KEY: String!
    
    var BDATE: Date?
    
    var GENDER: String?
    
    var TYPE: String!
    
    var HASH: String!
    
    func getParams() -> [String: Any]{
        return ["username": USERNAME , "password": PASSWORD , "type":TYPE , "hash": HASH , "key": KEY , "gender": "" , "bdate": "" , "fullname": ""]
        
    }
    
}





















