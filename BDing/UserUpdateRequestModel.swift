//
//  UserUpdateRequestModel.swift
//  BDing
//
//  Created by MILAD on 5/14/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation


class UserUpdateRequestModel {
    
    init(NAME : String? , FAMILY : String? ,ATTRNAME: String? , ATTRDATA: String?) {
        
        let m = SaveAndLoadModel().load(entity: "USER")?[0]
        
        self.USERID = m?.value(forKey: "userID") as! String!
        
        self.TOKEN = m?.value(forKey: "token") as! String!
        
        self.NAME = NAME
        
        self.FAMILY = FAMILY
        
        self.ATTRNAME = ATTRNAME
        
        self.ATTRDATA = ATTRDATA
        
        var temp = self.TOKEN.md5().md5()
        
        temp.append(USERID)
        
        temp.append(NAME ?? "")
        
        temp.append(FAMILY ?? "")
        
        self.HASH =  temp.md5()
        
    }
    
    var ATTRNAME: String?
    
    var ATTRDATA: String?
    
    var NAME: String?
    
    var FAMILY: String?
    
    var USERID: String!
    
    var TOKEN: String!
    
    var HASH: String!
    
    func getParams() -> [String: Any]{
        
        if(ATTRNAME != nil){
            
            return ["user": USERID , "token": TOKEN  , "hash": HASH , "name" : NAME , "family": FAMILY , ATTRNAME! : ATTRDATA ]
            
        }else{
            
            return ["user": USERID , "token": TOKEN  , "hash": HASH , "name" : NAME , "family": FAMILY]
            
        }
        
    }

    
}
