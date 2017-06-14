//
//  CustomerHomeTableCell.swift
//  BDingTest
//
//  Created by Milad on 2/18/17.
//  Copyright © 2017 Milad. All rights reserved.
//

import UIKit

class CustomerHomeTableCell: NSObject {
    
    var customerImage: PicModel?
    
    var customerBigImages : [PicModel]?
    
    var customerCampaignTitle: String
    
    var customerName: String
    
    var customerCategoryIcon: UIImage?
    
    var customerDistanceToMe: String
    
    var customerCoinValue: String
    
    var customerCoinIcon: UIImage
    
    var customerDiscountValue: String
    
    var customerDiscountIcon: UIImage
    
    var preCustomerImage: UIImage?
    
    
    
    /////
    
    var tell : String?
    
    var address : String?
    
    var text : String?
    
    var workTime : String?
    
    var website : String?
    
    var uuidMajorMinorMD5 : String?

    
    init(uuidMajorMinorMD5 : String? ,preCustomerImage : UIImage?,customerImage : PicModel?,customerCampaignTitle : String,customerName : String,customerCategoryIcon : UIImage?,customerDistanceToMe : String,customerCoinValue : String,customerCoinIcon : UIImage,customerDiscountValue : String,customerDiscountIcon : UIImage ,tell : String , address : String , text : String , workTime : String , website : String , customerBigImages : [PicModel]?){
        
        self.preCustomerImage = preCustomerImage
        
        self.customerImage = customerImage
        
        self.customerBigImages = customerBigImages
        
        self.customerName = customerName
        
        self.customerCoinIcon = UIImage(named: "ding 18")!
        
        self.customerCoinValue = customerCoinValue
        
        self.customerCategoryIcon = customerCategoryIcon
        
        self.customerDiscountIcon = UIImage(named: "sale 18")!
        
        self.customerDistanceToMe = customerDistanceToMe
        
        self.customerCampaignTitle = customerCampaignTitle
        
        self.customerDiscountValue = customerDiscountValue
        
        self.tell = tell
        
        self.address = address
        
        self.text = text
        
        self.workTime = workTime
        
        self.website = website
        
        self.uuidMajorMinorMD5 = uuidMajorMinorMD5
        
    }
    
}
