//
//  SubCategoryData.swift
//  BDing
//
//  Created by MILAD on 4/2/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class SubCategoryData : Decodable{
    
    var category_code : String?
    
    var title : String?
    
    var color_code : String?
    
    var order : String?
    
    var sub_code : String?
    
    var count : String?
    
    var url_icon : PicModel?
    
    var url_icon_m : PicModel?
    
    var all_track : String?
    
    
    required init?(json: JSON) {
        
        self.category_code = "category_code" <~~ json
        
        self.title = "title" <~~ json
        
        self.color_code = "color_code" <~~ json
        
        self.order = "order" <~~ json
        
        self.sub_code = "sub_code" <~~ json
        
        self.url_icon = "url_icon" <~~ json
        
        self.url_icon_m = "url_icon_m" <~~ json
        
        self.count = "count" <~~ json
        
        self.all_track = "all_track" <~~ json
        
    }
    
}
