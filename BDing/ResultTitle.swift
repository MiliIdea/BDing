//
//  ResultTitle.swift
//  BDing
//
//  Created by MILAD on 5/31/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class ResultTitle : Decodable{
    
    var title : String?
    
    
    required init?(json: JSON) {
        
        self.title = "title" <~~ json
        
    }
    
}
