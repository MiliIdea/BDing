//
//  UserUpdateRequestModel.swift
//  BDing
//
//  Created by MILAD on 5/14/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation


class UserUpdateRequestModel {
    
    init(NAME : String? , FAMILY : String? ,EMAIL: String? , BIRTHDATE: String? , PIC : String? , GENDER : String?) {
        
        let m = SaveAndLoadModel().load(entity: "USER")?[0]
        
        self.USERID = m?.value(forKey: "userID") as! String!
        
        self.TOKEN = m?.value(forKey: "token") as! String!
        
        self.NAME = NAME
        
        self.FAMILY = FAMILY
        
        self.BIRTHDATE = BIRTHDATE
        
        self.EMAIL = EMAIL
        
        self.PIC = PIC
        
        self.GENDER = GENDER
        
        var temp = self.TOKEN.md5().md5()
        
        temp.append(USERID)
        
        temp.append(NAME ?? "")
        
        temp.append(FAMILY ?? "")
        
        self.HASH =  temp.md5()
        
    }
    
    var BIRTHDATE: String?
    
    var EMAIL: String?
    
    var NAME: String?
    
    var FAMILY: String?
    
    var PIC : String?
    
    var GENDER : String?
    
    var USERID: String!
    
    var TOKEN: String!
    
    var HASH: String!
    
    func getParams() -> [String: Any]{
        
        return ["user": USERID , "token": TOKEN  , "hash": HASH , "name" : NAME , "family": FAMILY , "email": EMAIL , "birthdate": BIRTHDATE , "pic": PIC , "gender" : GENDER]
        
    }

    
}
