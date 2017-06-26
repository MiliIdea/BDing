//
//  TabBarController.swift
//  BDing
//
//  Created by MILAD on 4/9/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import CoreData
import UserNotifications
import UserNotificationsUI
import AudioToolbox
import Lottie

class TabBarController: UITabBarController , UITabBarControllerDelegate ,CLLocationManagerDelegate{
//
//    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
//    
//    let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "e2c56db5-dffb-48d2-b060-d0f5a71096e0")! as UUID, identifier: "Bding")
//    
    let locationManager = CLLocationManager()
    
    let myNotification = Notification.Name(rawValue:"MyNotification")
    
    let db = SaveAndLoadModel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.selectedIndex = 3
        
        MyFont().setFontForAllView(view: self.view)

//        locationManager.delegate = self
//
        locationManager.requestAlwaysAuthorization()
//
//        
//        region.notifyEntryStateOnDisplay = true
//        
//        region.notifyOnEntry = true
//        
//        region.notifyOnExit = true
//        
//        locationManager.startRangingBeacons(in: region)
//        
//        locationManager.startMonitoring(for: region)
//        
//        locationManager.distanceFilter = 10
//        
//        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        
//        locationManager.allowsBackgroundLocationUpdates = true
//        
//        locationManager.pausesLocationUpdatesAutomatically = false
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(reinstateBackgroundTask), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
//        
//        // register background task
//        registerBackgroundTask()
 
        updateBadgeVlue()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let nc = NotificationCenter.default
//        nc.post(name:myNotification,
//                object: nil,
//                userInfo:["message":"Hello there!", "date":Date()])
        
        
        if #available(iOS 10.0, *) {
            self.tabBar.items?[1].setBadgeTextAttributes([NSFontAttributeName: UIFont(name: "IRANYekanMobileFaNum", size: 14)!], for: .normal)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
//    func catchNotification(notification:Notification) -> Void {
//        print("Catch notification")
//        
//        guard let userInfo = notification.userInfo,
//            let message  = userInfo["message"] as? String,
//            let date     = userInfo["date"]    as? Date else {
//                print("No userInfo found in notification")
//                return
//        }
//        
//        let alert = UIAlertController(title: "Notification!",
//                                      message:"\(message) received at \(date)",
//            preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//        
//        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
//        self.present(alert, animated: true, completion: nil)
//    }
    
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        reinstateBackgroundTask()
//    }
    

//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        reinstateBackgroundTask()
//        let notification = UILocalNotification()
//        notification.fireDate = Date()
//        var s :String = "Beacon Detected!"
//        
//        if(region is CLBeaconRegion){
//        
//            s = String(describing: (region as! CLBeaconRegion).major)
//            
//            s.append(" - ")
//            
//            s.append(String(describing: (region as! CLBeaconRegion).minor))
//            
//            s.append(" - ")
//            
//            s.append(String(describing: (region as! CLBeaconRegion).proximityUUID))
//            
//        }
//        notification.alertBody = s
//        notification.alertAction = "ok"
//        notification.soundName = UILocalNotificationDefaultSoundName
//        UIApplication.shared.presentLocalNotificationNow(notification)
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        reinstateBackgroundTask()
//        let notification = UILocalNotification()
//        notification.fireDate = Date()
//        notification.alertBody = "az mahdudeye beacon kharej shodid!"
//        notification.alertAction = "ok"
//        notification.soundName = UILocalNotificationDefaultSoundName
//        UIApplication.shared.presentLocalNotificationNow(notification)
//    }
//    
//    func reinstateBackgroundTask() {
//        if (backgroundTask == UIBackgroundTaskInvalid) {
//            // register background task
//            registerBackgroundTask()
//        }
//    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item" , self.selectedIndex)
        
    }
    
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
    
    
//    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
//        
//        for b in beacons {
//            
//            checkDB2(beacon: b, beacon2_db: db.load(entity: "BEACON")!)
//            
//        }
//        
//        
//            
//        locationManager.stopRangingBeacons(in: region)
//            
//        
//        
//    }
    
//    func hoursBetween(date1: NSDate, date2: NSDate) -> Int {
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = .hour
//
//        var t = Int(formatter.string(from: date2 as Date, to: date1 as Date) ?? "0")!
//        
//        if(t < 0){
//            
//            t = -t
//            
//        }
//        
//        return t
//
//    }
//
//    
//    var lastLocation : CLLocation? = nil
//    
//    static var timeCount : Int = 0
//    
//    static var scanTimeCount : Int = 0
//    
//    func update(){
//        
//        TabBarController.timeCount += 5
//        
//        TabBarController.scanTimeCount += 5
//        
//        if(TabBarController.timeCount >= 70 ){
//            
//            TabBarController.timeCount = 0
//            
////            updateBeaconsList()
//            
//        }
//        
//        reinstateBackgroundTask()
//        
//        print(UIApplication.shared.backgroundTimeRemaining)
//        
//        if(TabBarController.scanTimeCount >= 20){
//            
//            TabBarController.scanTimeCount = 0
//            
//            locationManager.startRangingBeacons(in: region)
//            
//            locationManager.startMonitoring(for: region)
//            
//        }
//        
//    }
//    
    
    

//    
//    func updateBeaconsList(){
//        
//        if(SaveAndLoadModel().load(entity: "USER")?.count == 0){
//            
//            return
//            
//        }
//        
//        var lat: String
//        
//        var long: String
//        
//        let locManager = CLLocationManager()
//        
//        locManager.requestWhenInUseAuthorization()
//        
//        var currentLocation = CLLocation()
//        
//        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
//            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized){
//            
//            currentLocation = locManager.location!
//            
//        }
//        
//        long = String(currentLocation.coordinate.longitude)
//        
//        lat = String(currentLocation.coordinate.latitude)
//        
//        if(lat == "0" && long == "0"){
//            
//            long = String(51.4212297)
//            
//            lat = String(35.6329044)
//            
//        }
//        
//        print("lat and long")
//        print(lat)
//        print(long)
//        
//        request(URLs.getBeaconList , method: .post , parameters: BeaconListRequestModel(LAT: lat, LONG: long, REDIUS: String(GlobalFields.BEACON_RANG), SEARCH: nil, CATEGORY: nil, SUBCATEGORY: nil).getParams(), encoding: JSONEncoding.default).responseJSON { response in
//            print()
//            
//            if let JSON = response.result.value {
//                
//                print("JSON ----------BEACON----------->>>> " , JSON)
//                
//                let obj = BeaconListResponseModel.init(json: JSON as! JSON)
//                
//                if ( obj?.code == "200" ){
//                    
//                    GlobalFields.BEACON_LIST_DATAS = obj?.data
//                    
//                }
//                
//            }
//            
//        }
//
//        
//    }

    func updateBadgeVlue(){
        
        var count = 0
        
        for obj in db.load(entity: "BEACON")! {
            
            if(obj.value(forKey: "isRemoved") as! Bool == false && obj.value(forKey: "isSeen") as! Bool == false){
                
                count += 1
                
            }
            
        }
        
        self.tabBar.items?[1].badgeValue = String(count)
        
    }
    
    
//    func checkDB2(beacon : CLBeacon , beacon2_db : [NSManagedObject]){
//        
//        var localTimeZoneAbbreviation: String { return  NSTimeZone.local.abbreviation(for: Date())! }
//        
//        let date = Date()
//        
//        let uuid: String = String(describing: beacon.proximityUUID)
//        
//        let major: String = String(describing: beacon.major)
//        
//        let minor: String = String(describing: beacon.minor)
//        
//        var s : String = uuid
//        
//        s.append(major)
//        
//        s.append(minor)
//        
//        s = s.md5()
//        
//        var isInDB = false
//        
//        for row in beacon2_db {
//            
//            if(String(describing: row.value(forKey: "id")).contains(s)){
//                
//                isInDB = true
//                
//                if(row.value(forKey: "isSeen") as! Bool == true){
//                    
//                    let t1 = row.value(forKey: "seenTime") as! Date
//                    
//                    let t2 = date
//                    
//                    if(hoursBetween(date1: t2 as NSDate, date2: t1 as NSDate) > 12){
//                        
//                        let s2 = GetBeaconRequestModel(UUID: String(describing : beacon.proximityUUID), MAJOR: String(describing : beacon.major), MINOR: String(describing : beacon.minor))
//                        
//                        request(URLs.getBeacon , method: .post , parameters: s2.getParams(), encoding: JSONEncoding.default).responseJSON { response in
//                            print()
//                            
//                            if let JSON = response.result.value {
//                                
//                                print("JSON -----------FINDBEACON---------->>>> " , JSON)
//                                
//                                let obj = BeaconListResponseModel.init(json: JSON as! JSON)
//                                
//                                if ( obj?.code == "200" ){
//                                    
//                                    self.db.updateSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: s, newItem: ["uuid" : uuid , "major" : major , "minor" : minor , "id" : s , "isSeen" : false , "seenTime" : Date() , "beaconDataJSON" : self.jsonToString(json: JSON as AnyObject) ,"isRemoved" : false])
//                                    
//                                    
//                                    self.updateBadgeVlue()
//                                    //set notification!!!!!!!!!!!!
//                                    
////                                    if(self.hoursBetween(date1: self.db.getSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: s)?.value(forKey: "seenTime") as! NSDate, date2: Date() as! NSDate) > 1){
//                                    
//                                        let notification = UILocalNotification()
//                                        notification.fireDate = Date()
//                                        notification.alertTitle = obj?.data?[0].customer_title
//                                        notification.alertBody = obj?.data?[0].text
//                                        notification.alertAction = "ok"
//                                        notification.soundName = UILocalNotificationDefaultSoundName
//                                        UIApplication.shared.presentLocalNotificationNow(notification)
//                                        
////                                    }
//                                    
//                                    return
//                                }
//                                
//                            }
//                            
//                        }
//                        
//                    }
//                    
//                    
//                }
//
//            }
//            
////            print(row.value(forKey: "uuid") ?? "nil")
//            
//        }
//        
////        print("**********************")
//        
//        if(!isInDB){
//            //insert into DB
//            
//            self.db.save(entityName: "BEACON", datas: ["uuid" : uuid , "major" : major , "minor" : minor , "id" : s , "isSeen" : false , "seenTime" : nil , "beaconDataJSON" : nil , "isRemoved" : false])
//            
//            self.updateBadgeVlue()
//            
//            let s2 = GetBeaconRequestModel(UUID: String(describing : beacon.proximityUUID), MAJOR: String(describing : beacon.major), MINOR: String(describing : beacon.minor))
//            
//            request(URLs.getBeacon , method: .post , parameters: s2.getParams(), encoding: JSONEncoding.default).responseJSON { response in
//                print()
//                
//                if let JSON = response.result.value {
//                    
//                    print("JSON -----------FINDBEACON---------->>>> " , JSON)
//                    
//                    let obj = BeaconListResponseModel.init(json: JSON as! JSON)
//                    
//                    if ( obj?.code == "200" ){
//                        
//                        self.db.updateSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: s, newItem: ["uuid" : uuid , "major" : major , "minor" : minor , "id" : s , "isSeen" : false , "seenTime" : Date() , "beaconDataJSON" : self.jsonToString(json: JSON as AnyObject) ,"isRemoved" : false])
//                        
//                        self.updateBadgeVlue()
//                        
//                        //set notification!!!!!!!!!!!!
//                        
//                        let notification = UILocalNotification()
//                        notification.fireDate = Date()
//                        notification.alertTitle = obj?.data?[0].customer_title
//                        notification.alertBody = obj?.data?[0].text
//                        notification.alertAction = "ok"
//                        notification.soundName = UILocalNotificationDefaultSoundName
//                        UIApplication.shared.presentLocalNotificationNow(notification)
//                        
//                        
//                        return
//                    }
//                    
//                }
//                
//            }
//            
//            
//        }
//        
//        
//    }
    
//    func jsonToString(json: AnyObject) -> String? {
//        do {
//            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
//            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
//            return convertedString! // <-- here is ur string
//            
//        } catch let myJSONError {
//            print(myJSONError)
//        }
//        return nil
//    }
//    
//    func registerBackgroundTask() {
//        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
//            // end background task
////            self?.endBackgroundTask()
//            self?.reinstateBackgroundTask()
//        }
//        
//        assert(backgroundTask != UIBackgroundTaskInvalid)
//        
//        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
//        
//        locationManager.startUpdatingLocation()
//        
//        locationManager.startMonitoringSignificantLocationChanges()
//        
//        locationManager.startRangingBeacons(in: region)
//        
//        locationManager.startMonitoring(for: region)
//        
//    }
//    
//    
//    func endBackgroundTask() {
//        print("Background task ended.")
//        UIApplication.shared.endBackgroundTask(backgroundTask)
//        backgroundTask = UIBackgroundTaskInvalid
//    }
    

}






