//
//  PicModel.swift
//  BDing
//
//  Created by MILAD on 3/14/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class PicModel : Decodable{
    
    var code : String?
    
    var file_type : String?
    
    var url : String?
    
    
    required init?(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.file_type = "file_type" <~~ json
        
        self.url = "url" <~~ json
        
    }
    
}
