//
//  CheckRequestModel.swift
//  BDing
//
//  Created by MILAD on 12/5/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class CheckRequestModel {

    init(USERNAME: String! , SOCIALNAME : String!) {
        
        self.USERNAME = USERNAME
  
        self.SOCIALNAME = SOCIALNAME
       
        var temp = self.USERNAME
        
        temp?.append(self.SOCIALNAME)
        
        temp?.append(self.SOCIALNAME.md5())
        
        self.HASH =  temp?.md5()
        
    }
    
    var USERNAME: String!

    var SOCIALNAME: String!
    
    var HASH: String!
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME, "hash": HASH , "social_name" : SOCIALNAME]
        
    }
    
}





















