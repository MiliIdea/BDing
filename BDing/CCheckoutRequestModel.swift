//
//  CCheckoutRequestModel.swift
//  BDing
//
//  Created by MILAD on 3/3/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class CCheckoutRequestModel {
    
    init() {
        
        self.USERNAME = GlobalFields.cLoginResponseModel?.data?.user
        
        self.TOKEN = GlobalFields.cLoginResponseModel?.data?.token
        
        self.CASHID = GlobalFields.cLastCashData?.cash_id
        
        var temp = self.USERNAME
        
        temp?.append(self.TOKEN)
        
        temp?.append(self.TOKEN.md5())
        
        temp?.append(self.CASHID)
        
        self.HASH =  temp?.md5()
        
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var HASH: String!
    
    var CASHID: String!
    
    func getParams() -> [String: Any]{
        
        return ["user": USERNAME, "hash": HASH , "cash_id": CASHID , "token" : TOKEN]
        
    }
    
}
