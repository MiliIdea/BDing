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
        MyFont().setMediumFont(view: customerCampaignTitle, mySize: 14)
        MyFont().setWebFont(view: customerName, mySize: 11)
        MyFont().setWebFont(view: customerDistanceToMe, mySize: 13)
        MyFont().setWebFont(view: customerCampaignDiscount, mySize: 14)
        MyFont().setMediumFont(view: customerCampaignCoin, mySize: 16)
        customerThumbnail.layer.zPosition = 1
        
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOpacity = 0.25
        self.contentView.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.contentView.layer.shadowRadius = 3
        
//        viewW.constant = self.frame.width
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state

    }
    
    func setFirst(screenWidth : CGFloat){
        
        self.viewH.constant = screenWidth * 8.5 / CGFloat(32.0) - 8
        
        self.viewW.constant = screenWidth - 16.0
        
        imgH.constant = viewH.constant
        imgW.constant = viewW.constant/3.5
        
        
        customerThumbnail.contentMode = UIViewContentMode.scaleAspectFill
        titleTop.constant = 5
        titleTr.constant = imgW.constant + 8
        categoryThumbnailTr.constant = titleTr.constant
        nameTr.constant = categoryThumbnailTr.constant + categoryThumbnailW.constant + 2
        
        distanceIconTr.constant = categoryThumbnailTr.constant
        distanceTr.constant = distanceIconTr.constant + distanceIconW.constant
        discountIconTr.constant = distanceTr.constant + distanceW.constant + 40
        discountTr.constant = discountIconTr.constant + discountIconW.constant
        coinIconLe.constant = 8
        coinLe.constant = coinIconLe.constant + coinIconW.constant
        categoryThumbnailB.constant = viewH.constant / 2 - distanceIconW.constant / 2
        
        
        nameCategoryBL.constant = 0
        coinsB.constant = 0
        coinDiscountB.constant = 0
        discountsB.constant = 0
        distancesB.constant = 0
        discountDistanceB.constant = 0
        customerThumbnail.frame.origin.y = 0
        
    }
    
    func setLast(screenWidth : CGFloat){
        
        print(viewW.constant)
        
        print(self.boarderView.frame.width)
        
        self.viewH.constant = screenWidth * CGFloat(0.46875) - 8
        
        self.viewW.constant = screenWidth / 2 - 16.0
        

        imgH.constant = viewH.constant / 1.8
        imgW.constant = self.frame.width
        
        customerThumbnail.contentMode = UIViewContentMode.scaleAspectFill
        titleTop.constant = imgH.constant + 8
        titleTr.constant = 10
        categoryThumbnailTr.constant = titleTr.constant
        nameTr.constant = categoryThumbnailTr.constant + categoryThumbnailW.constant + 2
        categoryThumbnailB.constant = (viewH.constant - imgH.constant) / 2 - categoryThumbnailW.constant / 2
        distanceIconTr.constant = categoryThumbnailTr.constant
        distanceTr.constant = distanceIconTr.constant + distanceIconW.constant

        discountIconTr.constant = viewW.constant / 2 - (discountIconW.constant + discountW.constant)/3

        discountTr.constant = discountIconTr.constant + discountIconW.constant
        coinIconLe.constant = 8
        coinLe.constant = coinIconLe.constant + coinIconW.constant
        
        nameCategoryBL.constant = 0
        coinsB.constant = 0
        coinDiscountB.constant = 0
        discountsB.constant = 0
        distancesB.constant = 0
        discountDistanceB.constant = 0
        
    }

}
