//
//  CouponTableViewCell.swift
//  BDing
//
//  Created by MILAD on 4/24/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit
import Macaw

class CouponTableViewCell: UITableViewCell {

    @IBOutlet weak var couponImage: UIImageView!
    
    @IBOutlet weak var discountLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var dingView: SVGView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
