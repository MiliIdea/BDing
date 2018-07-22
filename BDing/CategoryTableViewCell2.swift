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
    
    @IBOutlet weak var circleView: DCCircleView!
    
    func setLayout(){
        
        self.frame.size.height = UIScreen.main.bounds.height / 8 - 10
        
        self.boarderView.frame.size.height = self.frame.size.height
        
        self.boarderView.frame.origin.y = 0
        
        self.boarderView.frame.size.width = self.frame.width - 16
        
        self.boarderView.frame.origin.x = 8
        
        circleView.frame.size.width = boarderView.frame.height / 2
        
        circleView.frame.size.height = boarderView.frame.height / 2
        
        circleView.frame.origin.y = (boarderView.frame.height - circleView.frame.size.height) / 2
        
        circleView.frame.origin.x = boarderView.frame.width - boarderView.frame.height + circleView.frame.origin.y
        
        
        
        iconView.frame.size.width = boarderView.frame.height / 2 * 1.2 / 2
        
        iconView.frame.size.height = boarderView.frame.height / 2 * 1.2 / 2
        
        iconView.frame.origin.y = (boarderView.frame.height - iconView.frame.size.height) / 2
        
        iconView.frame.origin.x = boarderView.frame.width - boarderView.frame.height + iconView.frame.origin.y

        
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setLayout()
        
        MyFont().setLightFont(view: labelViewCell2, mySize: 12)
        
        MyFont().setLightFont(view: labelNumOfItemsCell2, mySize: 12)
        
        iconView.frame.size.height = iconView.frame.width
        
//        iconView.layer.cornerRadius = iconView.frame.width / 2

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setLayout()
        // Configure the view for the selected state
    }

    
    func setLayers(image: UIImage) {
        
        setLayout()
        iconView.frame.size.height = iconView.frame.width
        
//        iconView.layer.cornerRadius = iconView.frame.width / 2
        
        iconView.image = image
        
        
    }
    
    
    
}
