//
//  CLastCashRequestModel.swift
//  BDing
//
//  Created by MILAD on 2/28/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class CLastCashRequestModel {
    
    init() {
        
        self.USERNAME = GlobalFields.cLoginResponseModel?.data?.user
        
        self.TOKEN = GlobalFields.cLoginResponseModel?.data?.token
        
        var temp = self.USERNAME
        
        temp?.append(self.TOKEN)
        
        temp?.append(self.TOKEN.md5())
        
        self.HASH =  temp?.md5()
        
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var HASH: String!
    
    func getParams() -> [String: Any]{
        
        return ["user": USERNAME, "hash": HASH , "token" : TOKEN]
        
    }
    
}
