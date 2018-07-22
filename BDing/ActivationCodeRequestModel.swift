//
//  ActivationCodeRequestModel.swift
//  BDing
//
//  Created by MILAD on 5/13/17.
//  Copyright © 2017 MILAD. All rights reserved.
//


import Foundation

class ActivationCodeRequestModel{
    
    init(USERNAME : String! , CODE : String!) {
        
        self.USERNAME = USERNAME
        
        self.CODE = CODE
        
        var temp : String = self.USERNAME.md5()
        
        temp.append(self.CODE)
        
        temp.append(self.CODE.md5())

        temp = temp.md5()
        
        self.HASH = temp
    }
    
    
    var USERNAME : String!
    
    var CODE : String!
    
    var HASH : String!
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME , "code": CODE  , "hash": HASH]
        
    }
    
}
