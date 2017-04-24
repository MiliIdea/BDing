//
//  CategoryListData.swift
//  BDing
//
//  Created by MILAD on 4/2/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class CategoryListData : Decodable{
    
    var category_code : String?
    
    var title : String?
    
    var color_code : String?
    
    var order : String?
    
    var item : [SubCategoryData]?
    
    var url_icon : PicModel?
    
    var url_icon_m : PicModel?
    
    
    required init?(json: JSON) {
        
        self.category_code = "category_code" <~~ json
        
        self.title = "title" <~~ json
        
        self.color_code = "color_code" <~~ json
            
        self.order = "order" <~~ json
            
        self.item = "item" <~~ json
        
        self.url_icon = "url_icon" <~~ json
        
        self.url_icon_m = "url_icon_m" <~~ json
        
    }
    
}
