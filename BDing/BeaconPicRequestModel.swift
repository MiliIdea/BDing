//
//  BeaconPicRequestModel.swift
//  BDing
//
//  Created by MILAD on 3/15/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class BeaconPicRequestModel {
    
    init(CODE: String! , FILE_TYPE: String?) {
        
        self.CODE = CODE
        
        self.FILE_TYPE = FILE_TYPE
        
        let m = SaveAndLoadModel().load(entity: "USER")?[0]
        
        self.USERID = m?.value(forKey: "userID") as! String!
        
        self.TOKEN = m?.value(forKey: "token") as! String!
        
        var temp = self.CODE
        
        temp?.append(self.TOKEN)
        
        temp = temp?.md5()
        
        temp?.append(self.TOKEN)
        
        temp?.append((self.USERID).md5())
        
        if self.FILE_TYPE != nil {
            temp?.append(self.FILE_TYPE!)
        }else {
            temp?.append("png")
        }
        self.HASH =  temp?.md5()
        
    }
    
    
    var USERID: String!
    
    var TOKEN: String!
    
    var HASH: String!
    
    var CODE: String!
    
    var FILE_TYPE: String?
    
    func getParams() -> [String: Any]{
        
        return ["user": USERID , "token": TOKEN  , "hash": HASH , "code": CODE , "file_type": FILE_TYPE ?? "png"]
        
    }

    
}
