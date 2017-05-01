//
//  FilterCollectionViewCell.swift
//  BDing
//
//  Created by MILAD on 4/30/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var circleView: DCCircleView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
