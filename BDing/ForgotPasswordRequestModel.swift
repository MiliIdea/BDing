//
//  ForgotPasswordRequestModel.swift
//  BDing
//
//  Created by MILAD on 5/13/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class ForgotpasswordRequestModel{
    
    init(USERNAME : String!) {
        
        self.USERNAME = USERNAME
        
        var temp : String = self.USERNAME.md5()
        
        temp.append(self.USERNAME)
        
        temp.append(String(self.USERNAME.characters.count).md5())
        
        temp = temp.md5()
        
        self.HASH = temp
    }
    
    
    var USERNAME : String!

    var HASH : String!
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME , "hash": HASH]
        
    }
  
}
