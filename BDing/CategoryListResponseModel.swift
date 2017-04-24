//
//  CategoryListResponseModel.swift
//  BDing
//
//  Created by MILAD on 4/2/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class CategoryListResponseModel : Decodable{
    
    var code : String?
    
    var data : [CategoryListData]?
    
    
    
    required init?(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.data = "data" <~~ json
        
        
    }
    
}
