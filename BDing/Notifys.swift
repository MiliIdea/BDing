//
//  Notifys.swift
//  BDing
//
//  Created by MILAD on 6/5/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation
import UIKit

class Notifys {
    
    func notif(message : String! , completion: @escaping (UIAlertController)->Void){
        
        /////////
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let attributedString = NSAttributedString(string: message, attributes: [
            NSFontAttributeName : UIFont.init(name: "IRANYekanMobileFaNum", size: 12)!
            ])
        
        
        alert.setValue(attributedString, forKey: "attributedMessage")
        
        //                        let attributedString2 = NSAttributedString(string: "باشه", attributes: [
        //                            NSFontAttributeName : UIFont.init(name: "IRANYekanMobileFaNum", size: 12)!
        //                            ])
        
        let ac : UIAlertAction = UIAlertAction.init(title: "باشه", style: .cancel, handler: nil)
        
        //                        ac.setValue(attributedString2, forKey: "title")
        
        alert.addAction(ac)
        
        completion(alert)
        
        //////////
        
    }
    
}
