//
//  MyCouponListData.swift
//  BDing
//
//  Created by MILAD on 4/29/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class MyCouponListData : Decodable{
    
    var coin : String?
    
    var coupon_count : String?
    
    var discount : String?
    
    var expire_date_service : String?
    
    var title : String?
    
    var url_pic : PicModel?
    
    var coupon_text : String?
    
    var count_used : String?
    
    var coupon_code : String?
    
    var address : String?
    
    var description : String?
    
    var shop_date : String?
    
    var end_date : String?
    
    var site : String?
    
    var start_date : String?
    
    var tel : String?
    
    
    
    required init?(json: JSON) {
        
        self.coin = "coin" <~~ json
        
        self.title = "title" <~~ json
        
        self.coupon_count = "coupon_count" <~~ json
        
        self.discount = "discount" <~~ json
        
        self.expire_date_service = "expire_date_service" <~~ json
        
        self.url_pic = "url_pic" <~~ json

        self.coupon_text = "coupon_text" <~~ json

        self.count_used = "count_used" <~~ json
        
        self.coupon_code = "coupon_code" <~~ json
        
        self.address = "address" <~~ json
        
        self.description = "description" <~~ json
        
        self.shop_date = "shop_date" <~~ json
        
        self.end_date = "end_date" <~~ json
        
        self.site = "site" <~~ json
        
        self.start_date = "start_date" <~~ json
        
        self.tel = "tel" <~~ json
        
    }
    
}
