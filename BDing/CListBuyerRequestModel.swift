//
//  CListBuyerRequestModel.swift
//  BDing
//
//  Created by MILAD on 1/24/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class CListBuyerRequestModel {
    
    init() {
        
        self.USERNAME = GlobalFields.cLoginResponseModel?.data?.user
        
        self.TOKEN = GlobalFields.cLoginResponseModel?.data?.token
        
        self.CUSTOMERID = GlobalFields.cLoginResponseModel?.data?.customer_id
        
        var temp = self.USERNAME
        
        temp?.append(self.TOKEN)
        
        temp?.append(self.TOKEN.md5())
        
        temp?.append(self.CUSTOMERID)
        
        self.HASH =  temp?.md5()
        
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var HASH: String!
    
    var CUSTOMERID : String!
    
    func getParams() -> [String: Any]{
        
        return ["user": USERNAME,"customer_id": CUSTOMERID , "hash": HASH , "token" : TOKEN]
        
    }
    
}
