//
//  CashDeskTableViewCell.swift
//  BDing
//
//  Created by MILAD on 1/23/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit

class CashDeskTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var payButton: DCBorderedButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func pay(_ sender: Any) {
    }
    
    
    
}
