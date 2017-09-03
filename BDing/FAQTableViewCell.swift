//
//  FAQTableViewCell.swift
//  BDing
//
//  Created by MILAD on 8/15/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit

class FAQTableViewCell: UITableViewCell {

    @IBOutlet weak var result: UILabel!
    
    @IBOutlet weak var question: UILabel!
    
    @IBOutlet weak var feleshIcon: UIImageView!
    
    @IBOutlet weak var questionBox: UIView!
    
    @IBOutlet weak var contentBox: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
