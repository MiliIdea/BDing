//
//  PayListData.swift
//  BDing
//
//  Created by MILAD on 4/29/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class PayListData : Decodable{
    
    var price : String?
    
    var date : String?
    
    var title_pay : String?
    
    
    required init?(json: JSON) {
        
        self.price = "price" <~~ json
        
        self.date = "date" <~~ json
        
        self.title_pay = "title" <~~ json
        
    }
    
}
