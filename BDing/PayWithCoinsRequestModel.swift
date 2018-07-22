//
//  PayWithCoinsRequestModel.swift
//  BDing
//
//  Created by MILAD on 5/31/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation
import CoreLocation

class PayWithCoinsRequestModel {

    
    init(BEACON: CLBeacon! , PAY: String!) {
        
        self.CODE = String(describing: BEACON.proximityUUID) + "-" + String(describing: BEACON.major) + "-" + String(describing: BEACON.minor)
        
        self.PAY = PAY
        
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
    
    var PAY: String!
    
    func getParams() -> [String: Any]{
        
        return ["user": USERID , "token": TOKEN  , "hash": HASH , "code": CODE , "pay": PAY ]
        
    }
    
}
