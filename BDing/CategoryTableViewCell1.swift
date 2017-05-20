//
//  CategoryTableViewCell1.swift
//  BDingTest
//
//  Created by Milad on 2/19/17.
//  Copyright © 2017 Milad. All rights reserved.
//

import UIKit

class CategoryTableViewCell1: UITableViewCell {
    
    @IBOutlet weak var imageViewCell1: UIImageView!

    @IBOutlet weak var labelViewCell1: UILabel!
    
    @IBOutlet weak var imageViewToggle: UIImageView!
    
    @IBOutlet weak var boarderView: UIView!
    
    var expanded: Bool = true
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
        MyFont().setMediumFont(view: labelViewCell1, mySize: 13)
        
        self.frame.size.height = UIScreen.main.bounds.height / 8
        
        self.boarderView.frame.size.height = self.frame.size.height - 10
        
        self.boarderView.frame.origin.y = 10
        
        self.boarderView.frame.size.width = self.frame.width - 16
        
        self.boarderView.frame.origin.x = 8
        
        self.imageViewCell1.frame.size.height = self.boarderView.frame.size.height + 0.5
        
        self.imageViewCell1.frame.size.width = self.imageViewCell1.frame.size.height + 0.5
        
        self.imageViewCell1.frame.origin.y = 0
        
        self.imageViewCell1.frame.origin.x = self.boarderView.frame.width - self.imageViewCell1.frame.width
        
        
        if (self.isSelected) {
            
            boarderView.layer.cornerRadius = 0
            
            let maskPath = UIBezierPath(roundedRect: boarderView.bounds,
                                        byRoundingCorners: [.topLeft, .topRight],
                                        cornerRadii: CGSize(width: 8.0, height: 8.0))
            
            let shape = CAShapeLayer()
            
            shape.path = maskPath.cgPath
            
            shape.borderWidth = 0
            
            boarderView.layer.mask = shape

            boarderView.backgroundColor = UIColor(hex: "#f5f7f8")
            
        }else {
            
            boarderView.layer.cornerRadius = 8
            
            imageViewCell1.layer.cornerRadius = 0
            
            let maskPath = UIBezierPath(roundedRect: boarderView.bounds,
                                        byRoundingCorners: [.bottomRight, .topRight],
                                        cornerRadii: CGSize(width: 8.0, height: 8.0))
            
            let shape = CAShapeLayer()
            
            shape.path = maskPath.cgPath
            
            shape.borderWidth = 0
            
            imageViewCell1.layer.mask = shape
            
            
        }
       
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOpacity = 0.25
        self.contentView.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.contentView.layer.shadowRadius = 3
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        self.frame.size.height = UIScreen.main.bounds.height / 8
        
        self.boarderView.frame.size.height = self.frame.size.height - 10
        
        self.boarderView.frame.origin.y = 10
        
        self.boarderView.frame.size.width = self.frame.width - 16
        
        self.boarderView.frame.origin.x = 8
        
        self.imageViewCell1.frame.size.height = self.boarderView.frame.size.height + 0.5
        
        self.imageViewCell1.frame.size.width = self.imageViewCell1.frame.size.height + 0.5
        
        self.imageViewCell1.frame.origin.y = 0
        
        self.imageViewCell1.frame.origin.x = self.boarderView.frame.width - self.imageViewCell1.frame.width
 
//        if(selected){
//            
//            self.imageViewToggle.image = UIImage(named: "ic_arrow_back.png")
//            
//            boarderView.layer.cornerRadius = 0
//            
//            let maskPath = UIBezierPath(roundedRect: boarderView.bounds, byRoundingCorners: [.topLeft, .topRight],cornerRadii: CGSize(width: 8.0, height: 8.0))
//            
//            let shape = CAShapeLayer()
//            
//            shape.path = maskPath.cgPath
//            
//            boarderView.layer.mask = shape
//            
//            boarderView.backgroundColor = UIColor(hex: "#f5f7f8")
//            
//        }else{
//            
//            self.boarderView.backgroundColor = UIColor.white
//            
//            self.imageViewToggle.image = UIImage(named: "madar")
//            
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
//                
//                self.boarderView.layer.cornerRadius = 8
//                
//            }
//            
//        }
    
    }
    
    
    
}
