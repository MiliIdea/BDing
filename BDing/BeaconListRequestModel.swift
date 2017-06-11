//
//  BeaconListRequestModel.swift
//  BDing
//
//  Created by MILAD on 3/14/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class BeaconListRequestModel {
    
    init(LAT: String! , LONG: String! , REDIUS: String? , SEARCH: String? , CATEGORY: String? , SUBCATEGORY: String?) {
        
        let m = SaveAndLoadModel().load(entity: "USER")?[0]
        
        self.USERID = m?.value(forKey: "userID") as! String!
        
        self.TOKEN = m?.value(forKey: "token") as! String!
        
        self.LAT = LAT
        
        self.LONG = LONG
        
        self.REDIUS = REDIUS
        
        self.SEARCH = SEARCH
        
        self.CATEGORY = CATEGORY
        
        self.SUBCATEGORY = SUBCATEGORY
        
        var temp = self.USERID!
        
        temp.append(self.LAT.md5())
        
        temp.append(self.LONG)
        
        self.HASH =  temp.md5()
        
    }
    
    
    var USERID: String!
    
    var TOKEN: String!
    
    var HASH: String!
    
    var LAT: String!
    
    var LONG: String!
    
    var REDIUS: String? = ""
    
    var SEARCH: String? = ""
    
    var CATEGORY: String? = ""
    
    var SUBCATEGORY: String? = ""
    
    func getParams() -> [String: Any]{
        
        return ["user": USERID , "token": TOKEN  , "hash": HASH , "lat": LAT , "long": LONG , "redius": REDIUS , "search": SEARCH , "category": CATEGORY , "subcategory": SUBCATEGORY , "allsearch" : "true"]
        
    }
    
}
