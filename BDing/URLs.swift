//
//  URLs.swift
//  BDing
//
//  Created by MILAD on 3/12/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class URLs {
    
    static let server = "http://www.bding.ir/rest/"
    
    static let signUpUrl = server + "register"
    
    static let signInUrl = server + "login"
    
    static let getProfile = server + "user/getprofile"
    
    static let getBeaconList = server + "beacon/getlist"
    
    static let getCategory = server + "beacon/getcategory"
    
    static let getBeacon = server + "beacon/getbeacon"
    
    //***REMAIN***//
    
    static let activationCode = server + "register/active"
    
    static let getMyCoupon = server + "user/getcoupon" // coupon haye man
    
    static let getCoupons = server + "coupon" // liste couponhaye mojud
    
    static let setCoin = server + "user/setcoin"
    
    static let buyCoupon = server + "user/buycoupon" // kharide coupon
    
    static let payWithToll = server + "user/pay" // pardakht ba seke
    
    static let paylistHistory = server + "user/paylist" //tarikhche pardakhtha
    
    static let forgotPassword = server + "register/forget"
    
}

