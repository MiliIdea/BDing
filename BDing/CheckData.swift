//
//  CheckData.swift
//  BDing
//
//  Created by MILAD on 12/5/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class CheckData : Decodable{
    
    var completing_the_profile : String?

    var invite_friends : String?
    
    var registered_with_invite_code : String?
    
    
    required init?(json: JSON) {
        
        self.completing_the_profile = "completing_the_profile" <~~ json
        
        self.invite_friends = "invite_friends" <~~ json
        
        self.registered_with_invite_code = "registered_with_invite_code" <~~ json
        
        GlobalFields.registered_with_invite_code = self.registered_with_invite_code
        
    }
    
}
