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

    let locationManager = CLLocationManager()
    
    let myNotification = Notification.Name(rawValue:"MyNotification")
    
    let db = SaveAndLoadModel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.selectedIndex = 3
        
        MyFont().setFontForAllView(view: self.view)

        locationManager.requestAlwaysAuthorization()
 
        self.tabBar.backgroundColor = UIColor.white
        
        self.tabBar.barTintColor = UIColor.white
        
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOpacity = 0.3
        self.tabBar.layer.shadowOffset = CGSize(width: -1, height: -1)
        self.tabBar.layer.shadowRadius = 5
        self.tabBar.layer.borderWidth = 0.0
        self.tabBar.shadowImage = nil
        
        self.tabBar.tintColor = UIColor.init(hex: "455a64")
        
        if #available(iOS 10.0, *) {
            self.tabBar.items?[1].badgeColor = UIColor.init(hex: "2196f3")
        } else {
            // Fallback on earlier versions
        }
        
        for i in self.tabBar.items! {
            
            i.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.init(hex: "bdbdbd") , NSFontAttributeName: UIFont(name: "IRANYekanMobileFaNum", size: CGFloat(8))!], for: .normal)
            //bdbdbd unselected color
            i.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.init(hex: "455a64") , NSFontAttributeName: UIFont(name: "IRANYekanMobileFaNum", size: CGFloat(8))!], for: .selected)
            i.image =  i.image?.imageWithColor(tintColor: UIColor.init(hex: "bdbdbd")).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            i.selectedImage = i.image?.imageWithColor(tintColor: UIColor.init(hex: "455a64")).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            
        }
        
        updateBadgeVlue()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 10.0, *) {
            self.tabBar.items?[1].setBadgeTextAttributes([NSFontAttributeName: UIFont(name: "IRANYekanMobileFaNum", size: 14)!], for: .normal)
        } else {
            // Fallback on earlier versions
        }
        
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
    

    func updateBadgeVlue(){
        
        var count = 0
        
        for obj in db.load(entity: "BEACON")! {
            
            if(obj.value(forKey: "isRemoved") as! Bool == false && obj.value(forKey: "isSeen") as! Bool == false){
                
                count += 1
                
            }
            
        }
        
        self.tabBar.items?[1].badgeValue = String(count)
        
    }

}






