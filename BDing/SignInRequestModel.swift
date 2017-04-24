//
//  SignInRequestModel.swift
//  BDing
//
//  Created by MILAD on 3/13/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class SignInRequestModel {
    
    init(USERNAME: String! , PASSWORD: String!) {
        
        self.USERNAME = USERNAME
        
        self.PASSWORD = PASSWORD
        
        if USERNAME.contains("@") && USERNAME.contains(".") {
            
            self.TYPE = "email"
            
        }else{
            
            self.TYPE = "tell"
            
        }
        
        var temp = self.PASSWORD.md5()
        
        temp.append(self.PASSWORD)
        
        temp.append(self.TYPE)
        
        self.HASH =  temp.md5()
        
    }
    
    
    var USERNAME: String!
    
    var PASSWORD: String!
    
    var TYPE: String!
    
    var HASH: String!
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME , "password": PASSWORD , "type":TYPE , "hash": HASH ]
        
    }
    
}





















