//
//  CLoginRequestModel.swift
//  BDing
//
//  Created by MILAD on 1/24/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class CLoginRequestModel {
    
    init() {
        
        self.USERNAME = GlobalFields.PROFILEDATA?.mobile
        
        var temp = self.USERNAME
        
        temp?.append(self.USERNAME.md5())
        
        temp?.append(self.USERNAME)
        
        self.HASH =  temp?.md5()
        
    }
    
    var USERNAME: String!
    
    var HASH: String!
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME, "hash": HASH]
        
    }
    
}
