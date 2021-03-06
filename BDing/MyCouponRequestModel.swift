//
//  GetCouponRequestModel.swift
//  BDing
//
//  Created by MILAD on 4/28/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class MyCouponRequestModel {
    
    init() {
        
        let m = SaveAndLoadModel().load(entity: "USER")?[0]
        
        self.USERID = m?.value(forKey: "userID") as! String!
        
        self.TOKEN = m?.value(forKey: "token") as! String!
        
        var temp = self.TOKEN.md5().md5()
        
        let temp2 = self.USERID.md5().md5()
        
        temp.append(temp2)
        
        temp.append(self.TOKEN)
        
        self.HASH =  temp.md5()
        
    }
    
    
    var USERID: String!
    
    var TOKEN: String!
    
    var HASH: String!
    
    func getParams() -> [String: Any]{
        
        return ["user": USERID , "token": TOKEN  , "hash": HASH]
        
    }
    
    
}
