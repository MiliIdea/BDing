//
//  SignInResponseModel.swift
//  BDing
//
//  Created by MILAD on 3/13/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class SignInResponseModel : Decodable{
    
    var code : String?
    
    var token : String?
    
    var userID : String?
    
    var msg : String?
    
    var data : SignInData?
    
    required init(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.token = "token" <~~ json
        
        self.userID = "user" <~~ json
        
        self.msg = "msg" <~~ json
        
        self.data = "data" <~~ json
    }
    
}
