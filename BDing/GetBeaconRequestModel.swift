//
//  GetBeaconRequestModel.swift
//  BDing
//
//  Created by MILAD on 4/23/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class GetBeaconRequestModel {
    
    init(UUID: String! , MAJOR: String! , MINOR: String!) {
        
        let m = SaveAndLoadModel().load(entity: "USER")?[0]
        
        self.USERID = m?.value(forKey: "userID") as! String!
        
        self.TOKEN = m?.value(forKey: "token") as! String!
        
        var code : String = UUID
        
        code.append("-")
        
        code.append(MAJOR)
        
        code.append("-")
        
        code.append(MINOR)
        
        self.CODE = code
        
        var temp = self.USERID!.md5()
        
        temp.append(self.TOKEN.md5())
        
        temp.append(self.CODE.md5().md5())
        
        self.HASH =  temp.md5()
        
    }
    
    
    var USERID: String!
    
    var TOKEN: String!
    
    var HASH: String!
    
    var CODE: String!
    
    func getParams() -> [String: Any]{
        
        return ["user": USERID , "token": TOKEN  , "hash": HASH , "code": CODE ]
        
    }
    
}
