//
//  onChangeStatusRequestModel.swift
//  BDing
//
//  Created by MILAD on 2/14/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class OnChangeStatusRequestModel {
    
    init(date : String! , beacon : String!) {
        
        let m = SaveAndLoadModel().load(entity: "USER")?[0]
        
        self.USERNAME = m?.value(forKey: "userID") as! String!
        
        self.BEACON = beacon
        
        self.DATE = date
        
        var temp = self.USERNAME
        
        temp?.append(self.USERNAME.md5())
        
        temp?.append(self.BEACON.md5())
        
        self.HASH =  temp?.md5()
        
    }
    
    var USERNAME: String!
    
    var HASH: String!
    
    var BEACON : String!
    
    var DATE : String!
    
    func getParams() -> [String: Any]{
        
        return ["user": USERNAME, "beacon":BEACON , "date" :DATE , "hash": HASH]
        
    }
}
