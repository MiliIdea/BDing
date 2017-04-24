//
//  SignUpResponseModel.swift
//  BDing
//
//  Created by MILAD on 3/12/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class SignUpResponseModel : Decodable{
    
    var code : String?
    
    required init(json: JSON) {
        self.code = "code" <~~ json
    }
    
}
