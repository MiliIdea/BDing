//
//  CDetermineRequestModel.swift
//  BDing
//
//  Created by MILAD on 1/24/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class CDetermineRequestModel {
    
    init(BUYER_ID: String! , PRICE: String!) {
        
        self.BUYER_ID = BUYER_ID
        
        self.PRICE = PRICE
        
        self.USERNAME = GlobalFields.PROFILEDATA?.mobile
        
        let m = SaveAndLoadModel().load(entity: "USER")?[0]
        
        self.TOKEN = m?.value(forKey: "token") as! String!
        
        var temp = self.USERNAME
        
        temp?.append(self.TOKEN)
        
        temp?.append(self.TOKEN.md5())
        
        temp?.append(self.PRICE)
        
        self.HASH =  temp?.md5()
        
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var HASH: String!
    
    var BUYER_ID: String!
    
    var PRICE: String!
    
    func getParams() -> [String: Any]{
        
        return ["user": USERNAME, "hash": HASH , "token" : TOKEN , "buyer_id" : BUYER_ID , "price" : PRICE]
        
    }
    
}
