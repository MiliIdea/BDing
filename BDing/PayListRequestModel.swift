//
//  PayListRequestmodel.swift
//  BDing
//
//  Created by MILAD on 4/26/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class PayListRequestModel {
    
    init() {
        
        let m = SaveAndLoadModel().load(entity: "USER")?[0]
        
        self.USERID = m?.value(forKey: "userID") as! String!
        
        self.TOKEN = m?.value(forKey: "token") as! String!
        
        var temp = self.TOKEN.md5().md5()
        
        var temp2 = self.TOKEN
        
        temp2?.append(self.USERID.md5())
        
        temp2 = temp2?.md5()
        
        temp.append(temp2!)
        
        self.HASH =  temp.md5()
        
    }
    
    
    var USERID: String!
    
    var TOKEN: String!
    
    var HASH: String!
    
    func getParams() -> [String: Any]{
        
        return ["user": USERID , "token": TOKEN  , "hash": HASH]
        
    }
    
    
}
