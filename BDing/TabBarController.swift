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

    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "e2c56db5-dffb-48d2-b060-d0f5a71096e0")! as UUID, identifier: "Bding")
    var animationView : LOTAnimationView?
    
    let locationManager = CLLocationManager()
    
    let myNotification = Notification.Name(rawValue:"MyNotification")
    
    let db = SaveAndLoadModel()
    
    var visitTime = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.selectedIndex = 3
        
        MyFont().setFontForAllView(view: self.view)

        locationManager.delegate = self

        locationManager.requestAlwaysAuthorization()
        
        locationManager.startRangingBeacons(in: region)
        
        locationManager.distanceFilter = 1
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:myNotification, object:nil, queue:nil, using:catchNotification)
        
        registerBackgroundTask()
 
        updateBadgeVlue()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let nc = NotificationCenter.default
//        nc.post(name:myNotification,
//                object: nil,
//                userInfo:["message":"Hello there!", "date":Date()])
    }
    
    func catchNotification(notification:Notification) -> Void {
        print("Catch notification")
        
        guard let userInfo = notification.userInfo,
            let message  = userInfo["message"] as? String,
            let date     = userInfo["date"]    as? Date else {
                print("No userInfo found in notification")
                return
        }
        
        let alert = UIAlertController(title: "Notification!",
                                      message:"\(message) received at \(date)",
            preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        self.present(alert, animated: true, completion: nil)
    }
    

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
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        visitTime += 1
        
        for b in beacons {
            
            checkDB2(beacon: b, beacon2_db: db.load(entity: "BEACON")!)
            
        }
        
        if(visitTime == 2){
            
            locationManager.stopRangingBeacons(in: region)
            
            visitTime = 0
            
        }
        
    }
    
    func hoursBetween(date1: NSDate, date2: NSDate) -> Int {
        
        let calendar: NSCalendar = NSCalendar.current as NSCalendar
        
        let date1 = calendar.startOfDay(for: date1 as Date)
        let date2 = calendar.startOfDay(for: date2 as Date)
        
        let flags = NSCalendar.Unit.hour
        let components = calendar.components(flags, from: date1, to: date2, options: NSCalendar.Options.matchFirst)
        
        return components.hour!
    }

    
    var lastLocation : CLLocation? = nil
    
    static var timeCount : Int = 0
    
    static var scanTimeCount : Int = 0
    
    func update(){
        
        TabBarController.timeCount += 5
        
        TabBarController.scanTimeCount += 5
        
        if(TabBarController.timeCount >= 70 ){
            
            TabBarController.timeCount = 0
            
            updateBeaconsList()
            
        }
        
        if(TabBarController.scanTimeCount >= 20){
            
            TabBarController.scanTimeCount = 0
            
            locationManager.startRangingBeacons(in: region)
            
        }
        
    }
    

    
    func updateBeaconsList(){
        
        if(SaveAndLoadModel().load(entity: "USER")?.count == 0){
            
            return
            
        }
        
        var lat: String
        
        var long: String
        
        let locManager = CLLocationManager()
        
        locManager.requestWhenInUseAuthorization()
        
        var currentLocation = CLLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized){
            
            currentLocation = locManager.location!
            
        }
        
        long = String(currentLocation.coordinate.longitude)
        
        lat = String(currentLocation.coordinate.latitude)
        
                long = String(51.4212297)
        
                lat = String(35.6329044)
        
        print("lat and long")
        print(lat)
        print(long)
        
        request(URLs.getBeaconList , method: .post , parameters: BeaconListRequestModel(LAT: lat, LONG: long, REDIUS: String(GlobalFields.BEACON_RANG), SEARCH: nil, CATEGORY: nil, SUBCATEGORY: nil).getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------BEACON----------->>>> " , JSON)
                
                let obj = BeaconListResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                    
                    GlobalFields.BEACON_LIST_DATAS = obj?.data
                    
                }
                
            }
            
        }

        
    }
    

    func updateBadgeVlue(){
        
        var count = 0
        
        for obj in db.load(entity: "BEACON")! {
            
            if(obj.value(forKey: "isRemoved") as! Bool == false && obj.value(forKey: "isSeen") as! Bool == false){
                
                count += 1
                
            }
            
        }
        
        self.tabBar.items?[1].badgeValue = String(count)
        
    }
    
    
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
                
                if(row.value(forKey: "isSeen") as! Bool == true){
                    
                    let t1 = row.value(forKey: "seenTime") as! Date
                    
                    let t2 = date
                    
                    if(hoursBetween(date1: t2 as NSDate, date2: t1 as NSDate) > 12){
                        
                        self.db.updateSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: s, newItem: ["uuid" : uuid , "major" : major , "minor" : minor , "id" : s , "isSeen" : false , "seenTime" : nil , "beaconDataJSON" : nil , "isRemoved" : false])
                        
   
                        updateBadgeVlue()
                        
                        //notify!!!!!
                        
                        let nc = NotificationCenter.default
                        nc.post(name:myNotification,
                                object: nil,
                                userInfo:["message":"Hello beacon!", "date":Date()])
                        
                        //+++++++++++
                        
//                        let s2 = GetBeaconRequestModel(UUID: String(describing : beacon.proximityUUID), MAJOR: String(describing : beacon.major), MINOR: String(describing : beacon.minor))
//                        request(URLs.signInUrl , method: .post , parameters: s2.getParams(), encoding: JSONEncoding.default).responseJSON { response in
//                            print()
//                            
//                            if let JSON = response.result.value {
//                                
//                                print("JSON -----------SIGNIN---------->>>> " , JSON)
//                                
//                                let obj = BeaconListResponseModel.init(json: JSON as! JSON)
//                                
//                                if ( obj?.code == "200" ){
//                                    
//                                    self.db.updateSpecificItemIn(entityName: "BEACON", keyAttribute: "id", item: s, newItem: ["uuid" : uuid , "major" : major , "minor" : minor , "id" : s , "isSeen" : false , "seenTime" : Date() , "beaconDataJSON" : JSON])
//                                    
//                                    //set notification!!!!!!!!!!!!
//                                    
//                                    
//                                    
//                                    return
//                                }
//                                
//                            }
//                            
//                        }
                        
                    }
                    
                    
                }

            }
            
//            print(row.value(forKey: "uuid") ?? "nil")
            
        }
        
//        print("**********************")
        
        if(!isInDB){
            //insert into DB
            
            db.save(entityName: "BEACON", datas: ["uuid" : uuid , "major" : major , "minor" : minor , "id" : s , "isSeen" : false , "seenTime" : nil , "beaconDataJSON" : nil , "isRemoved" : false])
            
            let nc = NotificationCenter.default
            nc.post(name:myNotification,
                    object: nil,
                    userInfo:["message":"Hello beacon!", "date":Date()])
            
        }
        
        
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        
        assert(backgroundTask != UIBackgroundTaskInvalid)
        
        locationManager.startRangingBeacons(in: region)
        
    }
    
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
//
//extension TabBarController: UNUserNotificationCenterDelegate{
//    
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        
//        print("Tapped in notification")
//    }
//    
//    //This is key callback to present notification while the app is in foreground
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        
//        print("Notification being triggered")
//        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
//        //to distinguish between notifications
//        if notification.request.identifier == requestIdentifier{
//            
//            completionHandler( [.alert,.sound,.badge])
//            
//        }
//    }
//}







