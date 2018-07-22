//
//  setCoinRequestModel.swift
//  BDing
//
//  Created by MILAD on 4/26/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class SetCoinRequestModel {
    

    
    init(CODE: String! , campaign_code : String!) {
        
        self.CODE = CODE
        
        self.TYPE = "beacon"
        
        self.MODE = "show"
        
        let m = SaveAndLoadModel().load(entity: "USER")?[0]
        
        self.USERID = m?.value(forKey: "userID") as! String!
        
        self.TOKEN = m?.value(forKey: "token") as! String!
        
        self.CAMPAIGN_CODE = campaign_code
        
        var temp = self.TOKEN.md5().md5()
        
        temp.append(self.USERID)
        
        temp.append(self.CODE.md5())
        
        self.HASH =  temp.md5()
        
    }
    
    
    var USERID: String!
    
    var TOKEN: String!
    
    var HASH: String!
    
    var CODE: String!
    
    var TYPE: String!
    
    var MODE: String!
    
    var CAMPAIGN_CODE : String!
    
    func getParams() -> [String: Any]{
        
        return ["user": USERID , "token": TOKEN  , "hash": HASH , "code": CODE , "type": TYPE , "mode": MODE , "campaign_code": CAMPAIGN_CODE]
        
    }
    
    
}
