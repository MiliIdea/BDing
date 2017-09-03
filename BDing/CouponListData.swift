//
//  CouponListData.swift
//  BDing
//
//  Created by MILAD on 4/28/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class CouponListData : Decodable{
    
    var coin : String?
    
    var coupon_count : String?
    
    var discount : String?
    
    var end_date : String?
    
    var expire_date_service : String?
    
    var start_date : String?
    
    var title : String?
    
    var unlimited : String?
    
    var url_pic : PicModel?
    
    var url_pic1 : PicModel?
    
    var url_pic2 : PicModel?
    
    var description : String?
    
    var site : String?
    
    var tel : String?
    
    var address : String?
    
    var color : String?
    
    
    required init?(json: JSON) {
        
        self.coin = "coin" <~~ json
        
        self.title = "title" <~~ json
        
        self.coupon_count = "coupon_count" <~~ json
        
        self.discount = "discount" <~~ json
        
        self.end_date = "end_date" <~~ json
        
        self.expire_date_service = "expire_date_service" <~~ json
        
        self.start_date = "start_date" <~~ json
        
        self.unlimited = "unlimited" <~~ json
        
        self.url_pic = "url_pic" <~~ json
        
        self.url_pic1 = "url_pic1" <~~ json
        
        self.url_pic2 = "url_pic2" <~~ json
        
        self.description = "description" <~~ json
        
        self.site = "site" <~~ json
        
        self.tel = "tel" <~~ json
        
        self.address = "address" <~~ json
        
        self.color = "color" <~~ json
        
    }
    
}
