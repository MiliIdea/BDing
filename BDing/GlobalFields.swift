//
//  GlobalFields.swift
//  BDing
//
//  Created by MILAD on 3/15/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation
import CoreLocation


class GlobalFields {
    
    static var BEACON_LIST_DATAS: [BeaconListData]? = nil
    
    static var CATEGORIES_LIST_DATAS: [CategoryListData]? = nil
    
    static var PROFILEDATA : ProfileData? = nil
    
    static var PAY_UUIDS: [String]? = nil
    
    static var BEACON_RANG : Int = 2000
    
    static var FAQs : [FAQData] = [FAQData]()
    
    struct indoorPoint {
        
        var x : Double
        
        var y : Double
        
        var z : Double
        
    }
    
    static var indoorPoints : [indoorPoint] = [indoorPoint]()
    
    static var indoorCoordinates : [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    
    static let mainCoordinate : CLLocationCoordinate2D = .init(latitude: 35.770669, longitude: 51.467387)
    
}
