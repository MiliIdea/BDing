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
        //455a64
        if #available(iOS 10.0, *) {
            self.tabBar.items?[1].badgeColor = UIColor.init(hex: "2490FC")
            repositionBadge(tab: 2)
        } else {
            // Fallback on earlier versions
        }
        
        for i in self.tabBar.items! {
            
            i.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.init(hex: "A8A5AF") , NSFontAttributeName: UIFont(name: "IRANYekanMobileFaNum-Bold", size: CGFloat(9))!], for: .normal)
            //A8A5AF unselected color
            i.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.init(hex: "455a64") , NSFontAttributeName: UIFont(name: "IRANYekanMobileFaNum-Bold", size: CGFloat(9))!], for: .selected)
            i.image =  i.image?.imageWithColor(tintColor: UIColor.init(hex: "A8A5AF")).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            i.selectedImage = i.image?.imageWithColor(tintColor: UIColor.init(hex: "455a64")).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            i.imageInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            
            
        }
        
        updateBadgeValue()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 10.0, *) {
            self.tabBar.items?[1].setBadgeTextAttributes([NSFontAttributeName: UIFont(name: "IRANYekanMobileFaNum", size: 14)!], for: .normal)
            repositionBadge(tab: 3)
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
    
    func repositionBadge(tab: Int){
        
//        for badgeView in self.tabBar.subviews[tab].subviews {
//
//            if NSStringFromClass(badgeView.classForCoder) == "_UIBadgeView" {
//                badgeView.layer.transform = CATransform3DIdentity
//                badgeView.layer.transform = CATransform3DMakeTranslation(0.0, -12, 1.0)
//
//            }
//        }
        
    }
    
    func updateBadgeValue(){
        
        var count = 0
        
        for obj in db.load(entity: "BEACON")! {
            
            if(obj.value(forKey: "isRemoved") as! Bool == false && obj.value(forKey: "isSeen") as! Bool == false && obj.value(forKey: "beaconDataJSON") != nil ){
                
                count += 1
                
            }
            
        }
        
        self.tabBar.items?[1].badgeValue = String(count)
        
        if(count == 0){
            
            self.tabBar.items?[1].badgeValue = nil
            
        }
        
    }

}






