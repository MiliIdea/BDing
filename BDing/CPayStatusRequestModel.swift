//
//  CPayStatusRequestModel.swift
//  BDing
//
//  Created by MILAD on 1/27/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class CPayStatusRequestModel {
    
    init(TYPE: String!) {
        
        self.CODE = GlobalFields.payStatus
        
        self.TYPE = TYPE
        
        if TYPE == "user" {
            
            let m = SaveAndLoadModel().load(entity: "USER")?[0]
            
            self.USERNAME = m?.value(forKey: "userID") as! String!
            
            self.TOKEN = m?.value(forKey: "token") as! String!
            
        }else{
        
            self.USERNAME = GlobalFields.cLoginResponseModel?.data?.user
            
            self.TOKEN = GlobalFields.cLoginResponseModel?.data?.token
            
        }
        
        var temp = self.USERNAME
        
        temp?.append(self.TOKEN)
        
        temp?.append(self.TOKEN.md5())
        
        self.HASH =  temp?.md5()
        
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var HASH: String!
    
    var CODE: [String]!
    
    var TYPE: String!
    
    func getParams() -> [String: Any]{
        
        return ["user": USERNAME, "hash": HASH , "token" : TOKEN , "item" : CODE , "type" : TYPE]
        
    }
    
}
