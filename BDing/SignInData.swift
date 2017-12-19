//
//  SignInData.swift
//  BDing
//
//  Created by MILAD on 12/9/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class SignInData : Decodable{

    var completing_the_profile : String?
    
    var invite_friends : String?
    
    var invite_code : String?
    
    var has_update : String?
    
    var registered_with_invite_code : String?
    
    var dif_time : String?
    
    required init(json: JSON) {
        
        self.completing_the_profile = "completing_the_profile" <~~ json
        
        self.invite_friends = "invite_friends" <~~ json
        
        self.invite_code = "invite_code" <~~ json
        
        self.has_update = "has_update" <~~ json
        
        self.registered_with_invite_code = "registered_with_invite_code" <~~ json
        
        self.dif_time = "dif_time" <~~ json
        
        GlobalFields.maintenanceTime = self.dif_time ?? ""
        
        GlobalFields.completionDing = self.completing_the_profile
        
        GlobalFields.invitationDing = self.invite_friends
        
        GlobalFields.invitationCode = self.invite_code
        
        GlobalFields.registered_with_invite_code = self.registered_with_invite_code
        
    }
    
}
