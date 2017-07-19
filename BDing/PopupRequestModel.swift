//
//  PopupRequestModel.swift
//  BDing
//
//  Created by MILAD on 7/17/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class PopupRequestModel{
    
    init(code : String! , lat : String? , long : String?) {
        
        self.LAT = lat
        
        self.LONG = long
        
        self.CODE = code
        
        let m = SaveAndLoadModel().load(entity: "USER")?[0]
        
        self.USERID = m?.value(forKey: "userID") as! String!
        
        self.TOKEN = m?.value(forKey: "token") as! String!
        
        var temp = self.USERID.md5()
        
        temp.append(self.TOKEN.md5())
        
        temp.append(self.CODE.md5().md5())
        
        self.HASH =  temp.md5()
        
    }
    
    
    var USERID: String!
    
    var TOKEN: String!
    
    var LAT : String?
    
    var LONG : String?
    
    var CODE : String!
    
    var HASH: String!
    
    
    func getParams() -> [String: Any]{
        
        return ["user": USERID , "token": TOKEN  , "hash": HASH , "code" : CODE , "lat" : LAT ?? "0" , "long" : LONG ?? "0"]
        
    }
    
    
    
    
    
}
