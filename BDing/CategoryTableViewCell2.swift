//
//  CategoryTableViewCell2.swift
//  BDingTest
//
//  Created by Milad on 2/19/17.
//  Copyright © 2017 Milad. All rights reserved.
//

import UIKit

class CategoryTableViewCell2: UITableViewCell {

    @IBOutlet weak var labelViewCell2: UILabel!
    
    @IBOutlet weak var labelNumOfItemsCell2: UILabel!
    
    @IBOutlet weak var boarderView: UIView!
    
    @IBOutlet weak var iconView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        MyFont().setLightFont(view: labelViewCell2, mySize: 12)
        
        MyFont().setLightFont(view: labelNumOfItemsCell2, mySize: 12)
        
        iconView.frame.size.height = iconView.frame.width
        
//        iconView.layer.cornerRadius = iconView.frame.width / 2

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
    func setLayers(image: UIImage) {
        
        
        iconView.frame.size.height = iconView.frame.width
        
//        iconView.layer.cornerRadius = iconView.frame.width / 2
        
        iconView.image = image
        
        
    }
    
    
    
}
