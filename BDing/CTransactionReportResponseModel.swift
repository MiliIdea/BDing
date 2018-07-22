//
//  CTransactionReportResponseModel.swift
//  BDing
//
//  Created by MILAD on 3/5/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class CTransactionReportResponseModel : Decodable{
    
    var code : String?
    
    var data : [CTransactionReportData]?
    
    required init?(json: JSON) {
        
        self.code = "code" <~~ json
        
        self.data = "data" <~~ json
        
    }
    
}
