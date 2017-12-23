//
//  URLs.swift
//  BDing
//
//  Created by MILAD on 3/12/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

class URLs {
    
//    static let server = "http://test.bding.ir/rest/"
    
    static let server = "http://www.bding.ir/rest/"
    
    static let signUpUrl = server + "register"
    
    static let checkSignUp = server + "register/check"
    
    static let signInUrl = server + "login"
    
    static let getProfile = server + "user/getprofile"
    
    static let getBeaconList = server + "beacon/getlist"
    
    static let getCategory = server + "beacon/getcategory"
    
    static let getBeacon = server + "beacon/getbeacon"
    
    static let activationCode = server + "register/active"
    
    static let getMyCoupon = server + "user/getcoupon" // coupon haye man
    
    static let getCoupons = server + "coupon" // liste couponhaye mojud
    
    static let setCoin = server + "user/setcoin"
    
    static let buyCoupon = server + "user/buycoupon" // kharide coupon
    
    static let payWithCoins = server + "user/pay" // pardakht ba seke
    
    static let paylistHistory = server + "user/paylist" //tarikhche pardakhtha
    
    static let forgotPassword = server + "register/forget"
    
    static let userUpdate = server + "user/update"
    
    static let changePassword = server + "user/pass"
    
    static let payTitle = server + "user/pay/name/"
    
    static let getPayUuids = server + "beacon/uuidpaylist"
    
    static let popup = server + "beacon/popup"
    
    static let faq = server + "faq"
    
    static let payment = server + "payment/set"
    
    static let verifyPayment = server + "payment/verify"
    
    static let lastCoupons = server + "coupon/lastcoupon"
    
    static let getDing = server + "user/getuserding"
    
}

