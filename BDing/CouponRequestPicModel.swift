//
//  CouponRequestModel.swift
//  BDing
//
//  Created by MILAD on 5/23/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class CouponRequestPicModel {
    
    init(CODE: String! , FILE_TYPE: String?) {
        
        self.CODE = CODE
        
        self.FILE_TYPE = FILE_TYPE
        
        let m = SaveAndLoadModel().load(entity: "USER")?[0]
        
        self.USERID = m?.value(forKey: "userID") as! String!
        
        self.TOKEN = m?.value(forKey: "token") as! String!
        
        var temp = self.TOKEN.md5().md5()
        
        temp.append(self.USERID)

        self.HASH =  temp.md5()
        
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
