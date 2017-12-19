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
    
    static var invitationDing : String? = ""
    
    static var completionDing : String? = ""
    
    static var invitationCode : String? = ""
    
    static var get_coin : String? = ""
    
    static var registered_with_invite_code : String? = ""
    
    static var maintenanceTime : String? = ""
    
    static var FAQs : [FAQData] = [FAQData]()
    
    static var goOnlinePay : Bool = false
    
    public func goErrorPage(viewController : UIViewController){
        
        let vc = (viewController.storyboard?.instantiateViewController(withIdentifier: "ErrorLoginViewController"))! as! ErrorLoginViewController
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            viewController.addChildViewController(vc)
            
            vc.view.frame = CGRect(x:0,y: 0,width: viewController.view.frame.size.width, height: viewController.view.frame.size.height)
            
            viewController.view.addSubview(vc.view)
            
            vc.didMove(toParentViewController: viewController)
            
            vc.view.alpha = 1
            
            viewController.view.alpha = 1
            
        },completion : nil)
        
    }
    
    public func goMaintenancePage(viewController : UIViewController){
        
        let vc = (viewController.storyboard?.instantiateViewController(withIdentifier: "MaintenanceViewController"))! as! MaintenanceViewController
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            viewController.addChildViewController(vc)
            
            vc.view.frame = CGRect(x:0,y: 0,width: viewController.view.frame.size.width, height: viewController.view.frame.size.height)
            
            viewController.view.addSubview(vc.view)
            
            vc.didMove(toParentViewController: viewController)
            
            vc.view.alpha = 1
            
            viewController.view.alpha = 1
            
        },completion : nil)
        
    }
    
    public func goUpdatePage(viewController : UIViewController){
        
        let vc = (viewController.storyboard?.instantiateViewController(withIdentifier: "UpdateViewController"))! as! UpdateViewController
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            viewController.addChildViewController(vc)
            
            vc.view.frame = CGRect(x:0,y: 0,width: viewController.view.frame.size.width, height: viewController.view.frame.size.height)
            
            viewController.view.addSubview(vc.view)
            
            vc.didMove(toParentViewController: viewController)
            
            vc.view.alpha = 1
            
            viewController.view.alpha = 1
            
        },completion : nil)
        
    }
    
    public func goFourceUpdatePage(viewController : UIViewController){
        
        let vc = (viewController.storyboard?.instantiateViewController(withIdentifier: "FourceUpdateViewController"))! as! FourceUpdateViewController
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            viewController.addChildViewController(vc)
            
            vc.view.frame = CGRect(x:0,y: 0,width: viewController.view.frame.size.width, height: viewController.view.frame.size.height)
            
            viewController.view.addSubview(vc.view)
            
            vc.didMove(toParentViewController: viewController)
            
            vc.view.alpha = 1
            
            viewController.view.alpha = 1
            
        },completion : nil)
        
    }
    
    struct indoorPoint {
        
        var beacon_code : String?
        
        var lat : Double?
        
        var long : Double?
        
        var x : Double
        
        var y : Double
        
        var z : Double?
        
    }

    
    static var indoorPoints : [indoorPoint] = [.init(beacon_code: "e2c56db5-dffb-48d2-b060-d0f5a71096e0-1-26", lat : nil , long : nil , x: 0, y: 0, z: 1) , .init(beacon_code: "e2c56db5-dffb-48d2-b060-d0f5a71096e0-1-40", lat : nil , long : nil , x: 2, y: 0, z: 1) , .init(beacon_code: "e2c56db5-dffb-48d2-b060-d0f5a71096e0-1-24", lat : nil , long : nil , x: 2, y: 3, z: 1)]
    
    static let mainCoordinate : CLLocationCoordinate2D = .init(latitude: 35.770669, longitude: 51.467387)
    
    
    
    /////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////
    
    public static func distanceTo(beacon : CLBeacon) -> Double{
        
        //@TODO
        
        return beacon.accuracy
        
    }
    
    public static func getCodeOf(beacon : CLBeacon) -> String{
        
        return String(describing: beacon.proximityUUID).lowercased() + "-" + String(describing: beacon.major).lowercased() + "-" + String(describing: beacon.minor).lowercased()
        
    }
    
    
    public static func intersectionOfTwoCircle(s1 : GlobalFields.indoorPoint , d1 : Double , s2 : GlobalFields.indoorPoint , d2 : Double) -> [GlobalFields.indoorPoint]?{
        
        let dS1S2 = sqrt((s1.x - s2.x) * (s1.x - s2.x) + (s1.y - s2.y) * (s1.y - s2.y))
        
        if(dS1S2 > d1 + d2){
            
            return nil
            
        }else if(dS1S2 == d1 + d2){
            
            let a = (dS1S2 * dS1S2 + d1 * d1 - d2 * d2)/(2 * dS1S2)
            
            return [GlobalFields.indoorPoint.init(beacon_code: nil,lat : nil , long : nil, x: s1.x + a * (s2.x - s1.x) / dS1S2, y: s1.y + a * (s2.y - s1.y) / dS1S2, z: nil)]
            
        }else{
            
            let a = (dS1S2 * dS1S2 + d1 * d1 - d2 * d2)/(2 * dS1S2)
            
            let h = d1 * d1 - a * a
            
            let p2 : GlobalFields.indoorPoint = GlobalFields.indoorPoint.init(beacon_code: nil,lat : nil , long : nil, x: s1.x + a * (s2.x - s1.x) / dS1S2, y: s1.y + a * (s2.y - s1.y) / dS1S2, z: nil)
            
            return [GlobalFields.indoorPoint.init(beacon_code: nil,lat : nil , long : nil, x: p2.x + h * (s2.y - s1.y) / dS1S2, y: p2.y - h * (s2.x - s1.x) / dS1S2 , z: nil) , GlobalFields.indoorPoint.init(beacon_code: nil,lat : nil , long : nil, x: p2.x - h * (s2.y - s1.y) / dS1S2, y: p2.y + h * (s2.x - s1.x) / dS1S2 , z: nil)]
            
        }
        
    }
    
    public static func distanceOf (s1 : GlobalFields.indoorPoint , s2 : GlobalFields.indoorPoint) -> Double{
        
        return sqrt((s1.x - s2.x) * (s1.x - s2.x) + (s1.y - s2.y) * (s1.y - s2.y))
        
    }
    
    public static func getCenterOfThreeCircle (s1 : GlobalFields.indoorPoint , s2 : GlobalFields.indoorPoint , s3 : GlobalFields.indoorPoint , d1 : Double , d2 : Double , d3 : Double) -> GlobalFields.indoorPoint?{
        
        var result : [GlobalFields.indoorPoint] = []
        
        let res1 = GlobalFields.intersectionOfTwoCircle(s1: s1, d1: d1, s2: s2, d2: d2)
        
        let res2 = GlobalFields.intersectionOfTwoCircle(s1: s1, d1: d1, s2: s3, d2: d3)
        
        let res3 = GlobalFields.intersectionOfTwoCircle(s1: s3, d1: d3, s2: s2, d2: d2)
        
        let centerOfThreePoint = GlobalFields.indoorPoint.init(beacon_code: nil,lat : nil , long : nil, x: (s1.x + s2.x + s3.x)/3, y: (s1.y + s2.y + s3.y)/3, z: nil)
        
        if(res1 == nil || res2 == nil || res3 == nil){
            
            return nil
            
        }
        
        if(res1?.count == 1){
            
            result.append((res1?[0])!)
            
        }else{
            
            if(GlobalFields.distanceOf(s1: (res1?[0])!, s2: centerOfThreePoint) < distanceOf(s1: (res1?[1])!, s2: centerOfThreePoint)){
                
                result.append((res1?[0])!)
                
            }else{
                
                result.append((res1?[1])!)
                
            }
            
        }
        
        
        if(res2?.count == 1){
            
            result.append((res2?[0])!)
            
        }else{
            
            if(GlobalFields.distanceOf(s1: (res2?[0])!, s2: centerOfThreePoint) < distanceOf(s1: (res2?[1])!, s2: centerOfThreePoint)){
                
                result.append((res2?[0])!)
                
            }else{
                
                result.append((res2?[1])!)
                
            }
            
        }
        
        
        if(res3?.count == 1){
            
            result.append((res3?[0])!)
            
        }else{
            
            if(GlobalFields.distanceOf(s1: (res3?[0])!, s2: centerOfThreePoint) < distanceOf(s1: (res3?[1])!, s2: centerOfThreePoint)){
                
                result.append((res3?[0])!)
                
            }else{
                
                result.append((res3?[1])!)
                
            }
            
        }
        
        // now result has theree point and should calculate average of them
        
        return GlobalFields.indoorPoint.init(beacon_code: nil,lat : nil , long : nil, x: (result[0].x + result[1].x + result[2].x) / 3, y: (result[0].y + result[1].y + result[2].y) / 3, z: nil)
        
    }
    
    public static func findCoordinate(p : GlobalFields.indoorPoint) -> CLLocationCoordinate2D {
        let distRadians = sqrt(p.x * p.x + p.y * p.y) / (6372797.6) // earth radius in meters
        
        let lat1 = GlobalFields.mainCoordinate.latitude * M_PI / 180
        let lon1 = GlobalFields.mainCoordinate.longitude * M_PI / 180
        
        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(findAzimuthInPoints(p: p)))
        let lon2 = lon1 + atan2(sin(findAzimuthInPoints(p: p)) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2 * 180 / M_PI, longitude: lon2 * 180 / M_PI)
    }
    
    
    
    public static func findAzimuthInPoints(p : GlobalFields.indoorPoint) -> Double{
        
        return atan(p.x / p.y)
        
    }
    
    
    
    
    /////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////

    
    
}










































