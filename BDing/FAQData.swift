//
//  FAQData.swift
//  BDing
//
//  Created by MILAD on 8/15/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class FAQData : Decodable{
    
    var title : String?
    
    var text : String?
    
    required init?(json: JSON) {
        
        self.title = "title" <~~ json
        
        self.text = "text" <~~ json
        
    }
    
}
