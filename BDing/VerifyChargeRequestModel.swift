//
//  VerifyChargeRequestModel.swift
//  BDing
//
//  Created by MILAD on 3/12/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class VerifyChargeRequestModel {
    
    
    init(CODE : String!) {
        
        self.CODE = CODE
        
        let m = SaveAndLoadModel().load(entity: "USER")?[0]
        
        self.USERID = m?.value(forKey: "userID") as! String!
        
        self.TOKEN = m?.value(forKey: "token") as! String!
        
        var temp = (self.CODE + self.TOKEN).md5()
        
        temp.append((self.TOKEN + self.USERID.md5()).md5())
        
        self.HASH =  temp.md5()
        
    }
    
    
    var USERID: String!
    
    var TOKEN: String!
    
    var HASH: String!
    
    var CODE: String!
    
    func getParams() -> [String: Any]{
        
        return ["user": USERID , "token": TOKEN  , "hash": HASH , "code": CODE]
        
    }
    
}
