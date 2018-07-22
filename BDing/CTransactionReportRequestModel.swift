//
//  CTransactionReportRequestModel.swift
//  BDing
//
//  Created by MILAD on 3/5/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class CTransactionReportRequestModel {
    
    init(DAY : String!) {
        
        self.USERNAME = GlobalFields.cLoginResponseModel?.data?.user
        
        self.TOKEN = GlobalFields.cLoginResponseModel?.data?.token
        
        self.DAY = DAY
        
        var temp = self.USERNAME
        
        temp?.append(self.TOKEN)
        
        temp?.append(self.TOKEN.md5())
        
        self.HASH =  temp?.md5()
        
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var HASH: String!
    
    var DAY : String!
    
    func getParams() -> [String: Any]{
        
        return ["user": USERNAME,"day": DAY , "hash": HASH , "token" : TOKEN]
        
    }
    
}
