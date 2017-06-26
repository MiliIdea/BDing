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
        
        let attributedString2 = NSAttributedString(string: "باشه", attributes: [
            NSFontAttributeName : UIFont.init(name: "IRANYekanMobileFaNum", size: 12)!
            ])
        
        let ac : UIAlertAction = UIAlertAction.init(title: "باشه", style: .cancel){(alert: UIAlertAction!) in
            guard let l = (alert.value(forKey: "__representer") as AnyObject).value(forKey: "label") as? UILabel else { return }
            l.attributedText = attributedString2
            
        }
        
        alert.addAction(ac)
        
        completion(alert)
        
        guard let label = (ac.value(forKey: "__representer") as AnyObject).value(forKey: "label") as? UILabel else { return }
        label.attributedText = attributedString2
        
        //////////
        
    }
    
}
