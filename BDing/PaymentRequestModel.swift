//
//  PaymentRequestModel.swift
//  BDing
//
//  Created by MILAD on 10/14/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation
import CoreLocation

class PaymentRequestModel {
    
    
    init(BEACON: CLBeacon! , MONEY: String!) {
        
        self.CODE = String(describing: BEACON.proximityUUID) + "-" + String(describing: BEACON.major) + "-" + String(describing: BEACON.minor)
        
        self.MONEY = MONEY
        
        let m = SaveAndLoadModel().load(entity: "USER")?[0]
        
        self.USERID = m?.value(forKey: "userID") as! String!
        
        self.TOKEN = m?.value(forKey: "token") as! String!
        
        var temp = (self.CODE + self.TOKEN).md5()
        
        temp.append((self.TOKEN + self.USERID.md5()).md5())
        
        self.HASH =  temp.md5()
        
    }
    
    
    var USERID: String!
    
    var TOKEN: String!
    
    var HASH: String!
    
    var CODE: String!
    
    var MONEY: String!
    
    func getParams() -> [String: Any]{
        
        return ["user": USERID , "token": TOKEN  , "hash": HASH , "code": CODE , "money": MONEY ,"device" : "iphone"]
        
    }
    
}
