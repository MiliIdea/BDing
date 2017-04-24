//
//  ProfileRequestModel.swift
//  BDing
//
//  Created by MILAD on 3/14/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation


class ProfileRequestModel {
    
    init() {
        
        let m = SaveAndLoadModel().load(entity: "USER")?[0]
        
        self.USERID = m?.value(forKey: "userID") as! String!
        
        self.TOKEN = m?.value(forKey: "token") as! String!
        
        var temp = self.TOKEN.md5()
        
        temp = temp.md5()
        
        temp.append(self.USERID)
        
        self.HASH =  temp.md5()
        
    }
    
    
    var USERID: String!
    
    var TOKEN: String!

    var HASH: String!
    
    func getParams() -> [String: Any]{
        
        print(["user": USERID , "token": TOKEN  , "hash": HASH ])
        
        return ["user": USERID , "token": TOKEN  , "hash": HASH ]
        
    }
    
}

