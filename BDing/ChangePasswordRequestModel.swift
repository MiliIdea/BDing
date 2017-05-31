//
//  ChangePasswordRequestModel.swift
//  BDing
//
//  Created by MILAD on 5/29/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

/*
 
 /user/password
 {
	"user":"",
	"hash":"",
	"token":"",
	"code":"" => new pass and  length > 5
	"pass":"" => old pass
 }
 [md5(token)+user+md5(length(code))] = hash
 
 */


class ChangePasswordRequestModel {
    
    init(NEW_PASS: String! , OLD_PASS: String!) {
        
        self.CODE = NEW_PASS
        
        self.PASS = OLD_PASS
        
        let m = SaveAndLoadModel().load(entity: "USER")?[0]
        
        self.USERID = m?.value(forKey: "userID") as! String!
        
        self.TOKEN = m?.value(forKey: "token") as! String!
        
        var temp = self.TOKEN.md5()
        
        temp.append(self.USERID)
        
        temp.append(String(CODE.characters.count).md5())
        
        self.HASH =  temp.md5()
        
    }
    
    
    var USERID: String!
    
    var TOKEN: String!
    
    var HASH: String!
    
    var CODE: String!
    
    var PASS: String!
    
    func getParams() -> [String: Any]{
        
        return ["user": USERID , "token": TOKEN  , "hash": HASH , "code": CODE , "pass": PASS ]
        
    }
    
    
}

