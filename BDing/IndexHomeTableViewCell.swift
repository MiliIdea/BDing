//
//  IndexHomeTableViewCell.swift
//  BDingTest
//
//  Created by Milad on 2/18/17.
//  Copyright © 2017 Milad. All rights reserved.
//

import UIKit

class IndexHomeTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var customerThumbnail: UIImageView!
   
    @IBOutlet weak var customerCampaignTitle: UILabel!
    
    @IBOutlet weak var customerName: UILabel!
    
    @IBOutlet weak var customerCategoryThumbnail: UIImageView!
    
    @IBOutlet weak var customerDistanceToMe: UILabel!
    
    @IBOutlet weak var discountThumbnail: UIImageView!
    
    @IBOutlet weak var customerCampaignDiscount: UILabel!
    
    @IBOutlet weak var customerCampaignCoin: UILabel!
    
    @IBOutlet weak var coinThumbnail: UIImageView!
    
    @IBOutlet weak var boarderView: DCBorderedView!
    
    
    @IBOutlet weak var viewH: NSLayoutConstraint!
    @IBOutlet weak var viewW: NSLayoutConstraint!
    @IBOutlet weak var imgH: NSLayoutConstraint!
    @IBOutlet weak var imgW: NSLayoutConstraint!
    @IBOutlet weak var titleTop: NSLayoutConstraint!
    @IBOutlet weak var titleTr: NSLayoutConstraint!
    @IBOutlet weak var titleW: NSLayoutConstraint!
    @IBOutlet weak var categoryThumbnailTr: NSLayoutConstraint!
    @IBOutlet weak var categoryThumbnailW: NSLayoutConstraint!
    @IBOutlet weak var nameTr: NSLayoutConstraint!
    @IBOutlet weak var nameCategoryBL: NSLayoutConstraint!
    @IBOutlet weak var coinsB: NSLayoutConstraint!
    @IBOutlet weak var coinDiscountB: NSLayoutConstraint!
    @IBOutlet weak var discountsB: NSLayoutConstraint!
    @IBOutlet weak var discountDistanceB: NSLayoutConstraint!
    @IBOutlet weak var distancesB: NSLayoutConstraint!
    @IBOutlet weak var distanceIconTr: NSLayoutConstraint!
    @IBOutlet weak var distanceTr: NSLayoutConstraint!
    @IBOutlet weak var discountIconTr: NSLayoutConstraint!
    @IBOutlet weak var discountTr: NSLayoutConstraint!
    @IBOutlet weak var distanceIconW: NSLayoutConstraint!
    @IBOutlet weak var discountIconW: NSLayoutConstraint!
    @IBOutlet weak var discountW: NSLayoutConstraint!
    @IBOutlet weak var distanceW: NSLayoutConstraint!
    @IBOutlet weak var coinIconLe: NSLayoutConstraint!
    @IBOutlet weak var coinLe: NSLayoutConstraint!
    @IBOutlet weak var coinIconW: NSLayoutConstraint!
    @IBOutlet weak var distanceIconB: NSLayoutConstraint!
    @IBOutlet weak var categoryThumbnailB: NSLayoutConstraint!
 
    @IBOutlet weak var selectionView: UIView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async(execute: { () -> Void in
        MyFont().setMediumFont(view: self.customerCampaignTitle, mySize: 14)
        MyFont().setWebFont(view: self.customerName, mySize: 11)
        MyFont().setWebFont(view: self.customerDistanceToMe, mySize: 11)
        MyFont().setWebFont(view: self.customerCampaignDiscount, mySize: 14)
        MyFont().setMediumFont(view: self.customerCampaignCoin, mySize: 16)
        self.customerThumbnail.layer.zPosition = 1
        self.imageView?.frame.size.height = self.boarderView.frame.height
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOpacity = 0.25
        self.contentView.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.contentView.layer.shadowRadius = 3
        self.shouldIndentWhileEditing = false
        })
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = self.boarderView.backgroundColor
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        self.boarderView.backgroundColor = color
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOpacity = 0.25
        self.contentView.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.contentView.layer.shadowRadius = 3
        
    }
    
    func setFirst(screenWidth : CGFloat){
//        DispatchQueue.main.async(execute: { () -> Void in
        self.viewH.constant = screenWidth * 8.5 / CGFloat(32.0) - 8
        
        self.viewW.constant = screenWidth - 16.0
        
        self.imageView?.frame.size.height = self.viewH.constant
        self.imgH.constant = self.viewH.constant
        self.imgW.constant = self.viewW.constant/3.5
        
        self.customerThumbnail.contentMode = UIViewContentMode.scaleAspectFill
        self.titleTop.constant = 5
        self.titleTr.constant = self.imgW.constant + 8
        self.titleW.constant = self.viewW.constant - imgW.constant - 5
        self.categoryThumbnailTr.constant = self.titleTr.constant
        self.nameTr.constant = self.categoryThumbnailTr.constant + self.categoryThumbnailW.constant + 2
        
        self.distanceIconTr.constant = self.categoryThumbnailTr.constant
        self.distanceTr.constant = self.distanceIconTr.constant + self.distanceIconW.constant
        self.discountIconTr.constant = self.distanceTr.constant + self.distanceW.constant + 40
        self.discountTr.constant = self.discountIconTr.constant + self.discountIconW.constant
        self.coinIconLe.constant = 8
        self.coinLe.constant = self.coinIconLe.constant + self.coinIconW.constant
        self.categoryThumbnailB.constant = self.viewH.constant / 2 - self.distanceIconW.constant / 2
        
        
        self.nameCategoryBL.constant = 0
        self.coinsB.constant = 0
        self.coinDiscountB.constant = 0
        self.discountsB.constant = 0
        self.distancesB.constant = 0
        self.discountDistanceB.constant = 0
        self.customerThumbnail.frame.origin.y = 0
//        })
        
        if(customerCampaignDiscount.text == "0" || customerCampaignDiscount.text == "تا" || customerCampaignDiscount.text == "" || customerCampaignDiscount.text == "تا0"){
            customerCampaignDiscount.alpha = 0
            discountThumbnail.alpha = 0
        }else{
            customerCampaignDiscount.alpha = 1
            discountThumbnail.alpha = 1
        }
        
        if(customerCampaignCoin.text == "0" || customerCampaignCoin.text == ""){
            customerCampaignCoin.alpha = 0
            coinThumbnail.alpha = 0
        }else{
            customerCampaignCoin.alpha = 1
            coinThumbnail.alpha = 1
        }
        
    }
    
    func setLast(screenWidth : CGFloat){
        
        print(viewW.constant)
        
        print(self.boarderView.frame.width)
        
        self.viewH.constant = screenWidth * CGFloat(0.46875) - 8
        
        self.viewW.constant = screenWidth / 2 - 16.0
        

        imgH.constant = viewH.constant / 1.8
        imgW.constant = self.frame.width
        
        customerThumbnail.contentMode = UIViewContentMode.scaleAspectFill
        self.titleW.constant = self.viewW.constant - self.titleTr.constant - 5
        titleTop.constant = imgH.constant + 8
        titleTr.constant = 10
        self.titleW.constant = self.viewW.constant - self.titleTr.constant - 10
        categoryThumbnailTr.constant = titleTr.constant
        nameTr.constant = categoryThumbnailTr.constant + categoryThumbnailW.constant + 2
        categoryThumbnailB.constant = (viewH.constant - imgH.constant) / 2 - categoryThumbnailW.constant / 2
        distanceIconTr.constant = categoryThumbnailTr.constant
        distanceTr.constant = distanceIconTr.constant + distanceIconW.constant

        discountIconTr.constant = viewW.constant / 2 - (discountIconW.constant + discountW.constant)/3 + 15

        discountTr.constant = discountIconTr.constant + discountIconW.constant
        coinIconLe.constant = 8
        coinLe.constant = coinIconLe.constant + coinIconW.constant
        
        nameCategoryBL.constant = 0
        coinsB.constant = 0
        coinDiscountB.constant = 0
        discountsB.constant = 0
        distancesB.constant = 0
        discountDistanceB.constant = 0
        
        if(customerCampaignDiscount.text == "0" || customerCampaignDiscount.text == "تا" || customerCampaignDiscount.text == ""){
            customerCampaignDiscount.alpha = 0
            discountThumbnail.alpha = 0
        }else{
            customerCampaignDiscount.alpha = 1
            discountThumbnail.alpha = 1
        }
        
        if(customerCampaignCoin.text == "0" || customerCampaignCoin.text == ""){
            customerCampaignCoin.alpha = 0
            coinThumbnail.alpha = 0
        }else{
            customerCampaignCoin.alpha = 1
            coinThumbnail.alpha = 1
        }
        
    }
    
    
}
