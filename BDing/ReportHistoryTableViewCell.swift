//
//  ReportHistoryTableViewCell.swift
//  BDing
//
//  Created by MILAD on 2/25/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit

class ReportHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var circleColor: DCCircleView!
    
    @IBOutlet weak var cashName: UILabel!
    
    @IBOutlet weak var dateAndTime: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var whoClosed: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
