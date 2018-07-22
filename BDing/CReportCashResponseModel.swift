//
//  CReportCashResponseModel.swift
//  BDing
//
//  Created by MILAD on 1/27/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class CReportCashResponseModel : Decodable{
    
    var code : String?
    
    var data : [CReportCashData]?
    
    required init?(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.data = "data" <~~ json
        
    }
    
}
