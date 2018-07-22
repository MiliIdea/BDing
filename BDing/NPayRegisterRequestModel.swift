//
//  NPayRegister.swift
//  BDing
//
//  Created by MILAD on 3/11/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class NPayRegisterRequestModel {
    
    init(BEACON : String!) {
        
        let m = SaveAndLoadModel().load(entity: "USER")?[0]
        
        self.USERID = m?.value(forKey: "userID") as! String!
        
        self.TOKEN = m?.value(forKey: "token") as! String!
        
        self.BEACON = BEACON
        
        var temp : String! = self.USERID
        
        temp.append(self.TOKEN)
        
        temp.append(self.TOKEN.md5())
        
        self.HASH =  temp.md5()
        
    }
    
    
    var USERID: String!
    
    var TOKEN: String!
    
    var HASH: String!
    
    var BEACON: String!
    
    func getParams() -> [String: Any]{
        
        return ["user": USERID , "token": TOKEN  ,"beacon": BEACON , "hash": HASH ]
        
    }
}
