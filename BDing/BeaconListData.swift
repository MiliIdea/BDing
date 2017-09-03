//
//  BeaconListData.swift
//  BDing
//
//  Created by MILAD on 3/14/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class BeaconListData : Decodable{
    
    var category_id : String?
    
    var category_title : String?
    
    var coin : String?
    
    var customer_id : String?
    
    var customer_title : String?
    
    var discount : String?
    
    var distance : Double?
    
    var file_count : String?
    
    var lat : String?
    
    var long : String?
    
    var sub_category_id : String?
    
    var sub_category_title : String?
    
    var text : String?
    
    var title : String?
    
    var url_icon : PicModel?
    
    var url_pic : [PicModel]?
    
    var customer_work_time : String?
    
    var customer_tell : String?
    
    var customer_fax : String?
    
    var customer_address : String?
    
    var cusomer_web : String?
    
    var popular : String?
    
    var start_date : Date?
    
    var end_date : Date?
    
    var beacon_code : String?
    
    var campaign_code : String?
    
    
    required init?(json: JSON) {
        
        self.customer_work_time = "customer_work_time" <~~ json ?? ""
            
        self.customer_tell = "customer_tell" <~~ json
            
        self.customer_fax = "customer_fax" <~~ json
            
        self.customer_address = "customer_address" <~~ json
        
        self.cusomer_web = "customer_web" <~~ json
        
        self.category_id = "category_id" <~~ json
        
        self.category_title = "category_title" <~~ json
        
        self.coin = "coin" <~~ json
        
        self.customer_id = "customer_id" <~~ json
        
        self.customer_title = "customer_title" <~~ json
        
        self.discount = "discount" <~~ json
        
        self.distance = "distance" <~~ json
        
        self.file_count = "file_count" <~~ json
        
        self.lat = "lat" <~~ json
        
        self.long = "long" <~~ json
        
        self.sub_category_id = "sub_category_id" <~~ json
        
        self.sub_category_title = "sub_category_title" <~~ json
        
        self.text = "text" <~~ json
        
        self.title = "title" <~~ json
        
        self.url_icon = "url_icon" <~~ json
        
        self.url_pic = "url_pic" <~~ json
        
        self.beacon_code = "beacon_code" <~~ json
        
        self.campaign_code = "campaign_code" <~~ json
        
    }
    
}
