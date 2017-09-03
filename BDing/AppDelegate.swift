//
//  AppDelegate.swift
//  BDing
//
//  Created by MILAD on 2/28/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import UserNotificationsUI
import CoreLocation
import CoreBluetooth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , CLLocationManagerDelegate ,CBPeripheralManagerDelegate , UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    var myBTManager : CBPeripheralManager? = nil

    let beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "e2c56db5-dffb-48d2-b060-d0f5a71096e0")! as UUID, identifier: "Bding")
    
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        locationManager.delegate = self
        
        myBTManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound , .badge]) { (granted, error) in
                // Enable or disable features based on authorization.
                self.locationManager.requestAlwaysAuthorization()
            }
        } else {
            // Fallback on earlier versions
//            locationManager.requestAlwaysAuthorization()
        }
        
//        UIApplication.shared.registerUserNotificationSettings(
//            UIUserNotificationSettings(types: .alert, categories: nil))
       
        
        beaconRegion.notifyEntryStateOnDisplay = true
        registerBackgroundTask()
        if((SaveAndLoadModel().load(entity: "USER")?.count)! > 0){
         locationManager.startRangingBeacons(in: beaconRegion)
        }
        
        
        return true
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        locationManager.delegate = self
        
        
        if((SaveAndLoadModel().load(entity: "USER")?.count)! > 0){
            
            locationManager.stopMonitoring(for: beaconRegion)
            
            locationManager.startRangingBeacons(in: beaconRegion)
            
            locationManager.startMonitoringSignificantLocationChanges()
            
            locationManager.allowsBackgroundLocationUpdates = true
            
            locationManager.pausesLocationUpdatesAutomatically = false
            
        }
        
        
        
        
    }

    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

        if((SaveAndLoadModel().load(entity: "USER")?.count)! > 0){
            locationManager.startRangingBeacons(in: beaconRegion)
        }
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
        locationManager.startMonitoringSignificantLocationChanges()
        
        locationManager.allowsBackgroundLocationUpdates = true
        
        locationManager.pausesLocationUpdatesAutomatically = false
        
        locationManager.startMonitoring(for: beaconRegion)
        
        self.saveContext()
    }
    
    
    
    
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        for b in beacons {
            
            checkDB2(beacon: b, beacon2_db: SaveAndLoadModel().load(entity: "BEACON")!)
            
        }
        
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if #available(iOS 10.0, *) {
            if(myBTManager?.state == CBManagerState.poweredOff){
                
                //check mikonam ag campaigni vojud dasht migam bluetootheto roshan kon
                
                var lat: String
                
                var long: String
                
                let locManager = CLLocationManager()
                
                locManager.requestAlwaysAuthorization()
                
                var currentLocation = CLLocation()
                
                if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways ||
                    CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
                    
                    currentLocation = locManager.location!
                    
                }
                
                long = String(currentLocation.coordinate.longitude)
                
                lat = String(currentLocation.coordinate.latitude)
                
//                if(lat == "0" && long == "0"){
//                    
//                    long = String(51.4212297)
//                    
//                    lat = String(35.6329044)
//                    
//                }
                
//                print("lat and long")
//                print(lat)
//                print(long)
//                
                print(BeaconListRequestModel(LAT: lat, LONG: long, REDIUS: String(GlobalFields.BEACON_RANG), SEARCH: nil, CATEGORY: nil, SUBCATEGORY: nil).getParams(allSearch : false))
//
                print()
                
                request(URLs.getBeaconList , method: .post , parameters: BeaconListRequestModel(LAT: lat, LONG: long, REDIUS: "200", SEARCH: nil, CATEGORY: nil, SUBCATEGORY: nil).getParams(allSearch : false), encoding: JSONEncoding.default).responseJSON { response in
                    
                    if let JSON = response.result.value {
                        
                        print("JSON ----------BEACON----------->>>> " , JSON)
                        
                        let obj = BeaconListResponseModel.init(json: JSON as! JSON)
                        
                        if ( obj?.code == "200" && obj?.data != nil){
                            
                            print("JSON ----------BEACON----------->>>> " , JSON)
                            
                            if((obj?.data?.count)! > 0){
                                
                                //notify
                                
                                let notification = UILocalNotification()
                                notification.fireDate = Date()
                                notification.alertBody = obj?.msg ?? "لطفا بلوتوث خود را روشن کنید کمپینی در اطراف شما پیدا شده!"
                                notification.alertAction = "ok"
                                notification.soundName = UILocalNotificationDefaultSoundName
                                UIApplication.shared.presentLocalNotificationNow(notification)
                                
                            }
                            
                        }
                        
                    }
                    
                }

                
            }
        } else {
            // Fallback on earlier versions
        }
        
        locationManager.startMonitoring(for: beaconRegion)
        
        locationManager.startRangingBeacons(in: beaconRegion)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        reinstateBackgroundTask()
        
        if(UIApplication.shared.applicationState == UIApplicationState.inactive){
        
            let notification = UILocalNotification()
            notification.fireDate = Date()
            notification.alertBody = "برای بدست آوردن دینگ بیدینگ را باز کنید :)"
            notification.alertAction = "ok"
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.presentLocalNotificationNow(notification)
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        reinstateBackgroundTask()
    }
    
    func registerBackgroundTask() {
        
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in

            self?.reinstateBackgroundTask()

        }
        
        assert(backgroundTask != UIBackgroundTaskInvalid)
        
    }
    
    func reinstateBackgroundTask() {
        if (backgroundTask == UIBackgroundTaskInvalid) {
            // register background task
            registerBackgroundTask()
        }
    }

    func update(){
        
        print("TIMERRRRRR")
        locationManager.startRangingBeacons(in: beaconRegion)
        
    }
    
    
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        
        completionHandler([.alert,.badge])
    }
    
    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "BDing")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if #available(iOS 10.0, *) {
            let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    else {
    // Fallback on earlier versions
    }
    }
    
    //UTIL
    
    func checkDB2(beacon : CLBeacon , beacon2_db : [NSManagedObject]){
        
        var localTimeZoneAbbreviation: String { return  NSTimeZone.local.abbreviation(for: Date())! }
        
        let date = Date()
        
        let uuid: String = String(describing: beacon.proximityUUID)
        
        let major: String = String(describing: beacon.major)
        
        let minor: String = String(describing: beacon.minor)
        
        var s : String = uuid
        
        s.append(major)
        
        s.append(minor)
        
        s = s.md5()
        
        var isInDB = false
        
        for row in beacon2_db {
            
            if(String(describing: row.value(forKey: "id")).contains(s)){
                
                isInDB = true
                
                if(row.value(forKey: "seenTime") != nil){
                
                    let t1 = row.value(forKey: "seenTime") as! Date
                    
                    let t2 = date
                    
                    if(hoursBetween(date1: t2 as NSDate, date2: t1 as NSDate) > 12){
                        
                        let s2 = GetBeaconRequestModel(UUID: String(describing : beacon.proximityUUID), MAJOR: String(describing : beacon.major), MINOR: String(describing : beacon.minor))
                        
                        request(URLs.getBeacon , method: .post , parameters: s2.getParams(), encoding: JSONEncoding.default).responseJSON { response in
//                            print()
                            
                            if let JSON = response.result.value {
                                
//                                print("JSON -----------FINDBEACON---------->>>> " , JSON)
                                
                                let obj = BeaconListResponseModel.init(json: JSON as! JSON)
                                
                                if ( obj?.code == "200" ){
                                    
                                    SaveAndLoadModel().updateSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: s, newItem: ["uuid" : uuid , "major" : major , "minor" : minor , "id" : s , "isSeen" : false , "seenTime" : Date() , "beaconDataJSON" : self.jsonToString(json: JSON as AnyObject) ,"isRemoved" : false])
                                    
                                
                                    let notification = UILocalNotification()
                                    notification.fireDate = Date()
                                    notification.alertTitle = obj?.data?[0].customer_title
                                    notification.alertBody = obj?.data?[0].text
                                    notification.alertAction = "ok"
                                    notification.soundName = UILocalNotificationDefaultSoundName
                                    UIApplication.shared.presentLocalNotificationNow(notification)
                                    
                                    //                                    }
                                    
                                    return
                                }else if ( obj?.code == "204" ){
                                    
                                    let obj = SaveAndLoadModel().getSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: s)
                                    
                                    SaveAndLoadModel().updateSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: s , newItem: ["uuid" : obj?.value(forKey: "uuid") , "major" : obj?.value(forKey: "major") , "minor" : obj?.value(forKey: "minor") , "id" : obj?.value(forKey: "id") , "isSeen" : obj?.value(forKey: "isSeen") , "seenTime" : obj?.value(forKey: "seenTime") , "beaconDataJSON" : obj?.value(forKey: "beaconDataJSON") ,"isRemoved" : true])
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    
                }
            
            }
            
            //            print(row.value(forKey: "uuid") ?? "nil")
            
        }
        
        //        print("**********************")
        
        if(!isInDB){
            //insert into DB
            
            SaveAndLoadModel().save(entityName: "BEACON", datas: ["uuid" : uuid , "major" : major , "minor" : minor , "id" : s , "isSeen" : false , "seenTime" : nil , "beaconDataJSON" : nil , "isRemoved" : false])
            
            let s2 = GetBeaconRequestModel(UUID: String(describing : beacon.proximityUUID), MAJOR: String(describing : beacon.major), MINOR: String(describing : beacon.minor))
            
            request(URLs.getBeacon , method: .post , parameters: s2.getParams(), encoding: JSONEncoding.default).responseJSON { response in
//                print()
                
                if let JSON = response.result.value {
                    
//                    print("JSON -----------FINDBEACON---------->>>> " , JSON)
                    
                    let obj = BeaconListResponseModel.init(json: JSON as! JSON)
                    
                    if ( obj?.code == "200" ){
                        
                        SaveAndLoadModel().updateSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: s, newItem: ["uuid" : uuid , "major" : major , "minor" : minor , "id" : s , "isSeen" : false , "seenTime" : Date() , "beaconDataJSON" : self.jsonToString(json: JSON as AnyObject) ,"isRemoved" : false])
                        
                        
                        //set notification!!!!!!!!!!!!
                        
                        let notification = UILocalNotification()
                        notification.fireDate = Date()
                        notification.alertTitle = obj?.data?[0].customer_title
                        notification.alertBody = obj?.data?[0].text
                        notification.alertAction = "ok"
                        notification.soundName = UILocalNotificationDefaultSoundName
                        UIApplication.shared.presentLocalNotificationNow(notification)
                        
                        
                        return
                    }else if ( obj?.code == "204" ){
                        
//                        SaveAndLoadModel().deleteSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: s)
                        let obj = SaveAndLoadModel().getSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: s)
                        
                        SaveAndLoadModel().updateSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: s , newItem: ["uuid" : obj?.value(forKey: "uuid") , "major" : obj?.value(forKey: "major") , "minor" : obj?.value(forKey: "minor") , "id" : obj?.value(forKey: "id") , "isSeen" : obj?.value(forKey: "isSeen") , "seenTime" : obj?.value(forKey: "seenTime") , "beaconDataJSON" : obj?.value(forKey: "beaconDataJSON") ,"isRemoved" : true])
                        
                    }
                    
                }
                
            }
            
            
        }
        
        
    }
    
    func jsonToString(json: AnyObject) -> String? {
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            return convertedString! // <-- here is ur string
            
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }

    
    func hoursBetween(date1: NSDate, date2: NSDate) -> Int {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = .hour
        
        var t = Int(formatter.string(from: date2 as Date, to: date1 as Date) ?? "0")!
        
        if(t < 0){
            
            t = -t
            
        }
        
        return t
        
    }
    
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        myBTManager = peripheral
        
    }
    
    
    

    
    
}

