//
//  CTransactionTableViewCell.swift
//  BDing
//
//  Created by MILAD on 2/25/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit

class CTransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var followUpNumber: UILabel!
    
    @IBOutlet weak var factorNumber: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
