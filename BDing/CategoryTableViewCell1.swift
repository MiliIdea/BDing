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
        
        if (self.isSelected) {
            
            boarderView.layer.cornerRadius = 0
            
            let maskPath = UIBezierPath(roundedRect: boarderView.bounds,
                                        byRoundingCorners: [.topLeft, .topRight],
                                        cornerRadii: CGSize(width: 8.0, height: 8.0))
            
            let shape = CAShapeLayer()
            
            shape.path = maskPath.cgPath
            
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
            
            imageViewCell1.layer.mask = shape
            
            
        }
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
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
