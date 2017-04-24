//
//  ProfilePageViewController.swift
//  BDingTest
//
//  Created by Milad on 2/20/17.
//  Copyright © 2017 Milad. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController , UIScrollViewDelegate {
    
    @IBOutlet weak var scrollViewProfile: UIScrollView!
    
    @IBOutlet weak var viewInScrollView: UIView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var semicircularView: UIImageView!
    
    @IBOutlet weak var profilePicButton: DCBorderedButton!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var coinIcon: UIImageView!
    
    @IBOutlet weak var patternView: UIView!
    
    @IBOutlet weak var appSettingsIcon: UIImageView!
    
    
    //num of pattern images in background
    let xNum = 4
    
    var profilePicEdge: CGFloat = 0.0
    
    var profilePicOffsetY: CGFloat = 0.0
    
    var profilePicOffsetX: CGFloat = 0.0
    
    var heightOfSemiCircular: CGFloat = 0.0
    
    var offsetOfsemiCircular: CGFloat = 0.0
    
    var nameStartXY: CGPoint = CGPoint()
    
    var nameStartWH: CGPoint = CGPoint()
    
    var coinValueStartXY: CGPoint = CGPoint()
    
    var coinValueStartWH: CGPoint = CGPoint()
    
    var coinIconStartXY: CGPoint = CGPoint()
    
    var coinIconStartWH: CGPoint = CGPoint()
    
    var startNameFontSize: CGFloat = 0.0
    
    var startCoinFontSize: CGFloat = 0.0
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var coinValue: UILabel!
    
    @IBOutlet weak var reportLabel: UILabel!
    
    @IBOutlet weak var sekeButton: DCBorderedButton!
    
    @IBOutlet weak var coupon: DCBorderedButton!
    
    @IBOutlet weak var pardakhtButton: DCBorderedButton!
    
    @IBOutlet weak var myCoupon: DCBorderedButton!
    
    @IBOutlet weak var inputBoarderView: DCBorderedView!
    
    @IBOutlet weak var porseshhaButton: DCBorderedButton!
    
    @IBOutlet weak var aboutUsButton: DCBorderedButton!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        for subView in inputBoarderView.subviews {
            if (subView is UILabel){
                MyFont().setLightFont(view: subView, mySize: 13)
            }else {
                MyFont().setMediumFont(view: subView, mySize: 13)
            }
        }
        
        MyFont().setMediumFont(view: name, mySize: 14)
        MyFont().setMediumFont(view: coinValue, mySize: 13)
        MyFont().setMediumFont(view: reportLabel, mySize: 10)
        MyFont().setMediumFont(view: sekeButton, mySize: 13)
        MyFont().setMediumFont(view: coupon, mySize: 13)
        MyFont().setMediumFont(view: pardakhtButton, mySize: 13)
        MyFont().setMediumFont(view: myCoupon, mySize: 13)
        MyFont().setMediumFont(view: porseshhaButton, mySize: 13)
        MyFont().setMediumFont(view: aboutUsButton, mySize: 13)
        
        // image is 400 * 252
        let wV = patternView.frame.width
        let hV = patternView.frame.height
        let hr = (252/400)*(wV/CGFloat(xNum))
        let wr = wV/CGFloat(xNum)
        
        for i in 0...xNum - 1{
            
            for j in 0...Int(floor(Double(hV/hr))) - 1{
                
                let image = UIImageView(frame: CGRect(x: CGFloat(i)*wr, y: CGFloat(j)*hr, width: wr, height: hr))
                
                image.image = UIImage(named: "bding_pattern_white")
                
                patternView.addSubview(image)
                
            }
            
        }
        
        
        
        scrollViewProfile.delegate = self
        
        scrollViewProfile.addSubview(viewInScrollView)
        
        scrollViewProfile.contentSize = viewInScrollView.frame.size
        
        heightOfSemiCircular = semicircularView.frame.height
        
        offsetOfsemiCircular = semicircularView.frame.origin.y
        
        profilePicEdge = profilePicButton.frame.height
        
        profilePicOffsetY = profilePicButton.frame.origin.y
        
        profilePicOffsetX = profilePicButton.frame.origin.x
        
        profilePicButton.layer.zPosition = 1
        
        //---
        
        name.adjustsFontSizeToFitWidth = true
        
        nameStartXY.x = name.frame.origin.x
        
        nameStartXY.y = name.frame.origin.y
        
        nameStartWH.x = name.frame.width
        
        nameStartWH.y = name.frame.height
        
        startNameFontSize = name.font.pointSize
        
        //---
        
        coinValueStartXY.x = coinValue.frame.origin.x
        
        coinValueStartXY.y = coinValue.frame.origin.y
        
        coinValueStartWH.x = coinValue.frame.width
        
        coinValueStartWH.y = coinValue.frame.height
        
        startCoinFontSize = coinValue.font.pointSize
        
        //---
        
        coinIconStartXY.x = coinIcon.frame.origin.x
        
        coinIconStartXY.y = coinIcon.frame.origin.y
        
        coinIconStartWH.x = coinIcon.frame.width
        
        coinIconStartWH.y = coinIcon.frame.height
        
        //---
        
        reportLabel.clipsToBounds = true
        
        reportLabel.layer.cornerRadius = 8
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func myAnimateWithScroll(view: UIView , goalXY: CGPoint , startXY: CGPoint , goalWH: CGPoint , startWH: CGPoint , fontSG: CGPoint) -> Void{
        
        var YpercentageScroll = scrollViewProfile.contentOffset.y / profilePicOffsetY
        
        if(YpercentageScroll < 0){
            
            view.frame.origin.y = startXY.y - scrollViewProfile.contentOffset.y
            
            
        }else {
            
            if(YpercentageScroll > 1){
                
                YpercentageScroll = 1
                
            }
            
            view.frame.origin.x = startXY.x + (goalXY.x - startXY.x) * YpercentageScroll
            
            view.frame.origin.y = startXY.y + (goalXY.y - startXY.y) * YpercentageScroll
            
            view.frame.size.width = startWH.x + (goalWH.x - startWH.x) * YpercentageScroll
            
            view.frame.size.height = startWH.y + (goalWH.y - startWH.y) * YpercentageScroll
            
            if(view is UILabel){
                
                let l: UILabel = view as! UILabel
                
                l.font = l.font.withSize(fontSG.x - ((fontSG.x - fontSG.y) * YpercentageScroll))
                
                l.sizeToFit()
                
            }

        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // define goal of animation of views
        // profile pic
        var pgXY: CGPoint = CGPoint()
        
        var psXY: CGPoint = CGPoint()
        
        var pgWH: CGPoint = CGPoint()
        
        var psWH: CGPoint = CGPoint()
        
        pgXY.x = 0.85 * navigationBar.frame.width
        
        pgXY.y = 0.075 * navigationBar.frame.height + navigationBar.frame.origin.y
        
        psXY.x = profilePicOffsetX
        
        psXY.y = profilePicOffsetY
        
        pgWH.x = navigationBar.frame.height * 0.8
        
        pgWH.y = navigationBar.frame.height * 0.8
        
        psWH.x = profilePicEdge
        
        psWH.y = profilePicEdge
        
        myAnimateWithScroll(view: profilePicButton, goalXY: pgXY, startXY: psXY, goalWH: pgWH, startWH: psWH , fontSG: pgXY)
        
        // Name and Coin
        
        var ngXY: CGPoint = CGPoint()
        
        var ngWH: CGPoint = CGPoint()
        
        var cvgXY: CGPoint = CGPoint()
        
        var cvgWH: CGPoint = CGPoint()
        
        var cigXY: CGPoint = CGPoint()
        
        var cigWH: CGPoint = CGPoint()
        
        var fontNameSG: CGPoint = CGPoint()
        
        var fontCoinSG: CGPoint = CGPoint()
        
        ngWH.x = nameStartWH.x * 0.75
        
        ngWH.y = nameStartWH.y * 0.75
        
        cvgWH.x = coinValueStartWH.x * 0.5 + 5
        
        cvgWH.y = coinValueStartWH.y * 0.5
        
        cigWH.x = coinIconStartWH.x * 0.5
        
        cigWH.y = coinIconStartWH.y * 0.5
        
        ngXY.x = pgXY.x - ngWH.x
        
        ngXY.y = pgXY.y
        
        cvgXY.x = pgXY.x - cvgWH.x
        
        cvgXY.y = pgXY.y + ngWH.y + 4
        
        cigXY.x = cvgXY.x - cigWH.x - 3
        
        cigXY.y = cvgXY.y 
        
        fontNameSG.x = startNameFontSize
        
        fontNameSG.y = startNameFontSize / 1.3
        
        fontCoinSG.x = startCoinFontSize
        
        fontCoinSG.y = startCoinFontSize / 1.4
        
        myAnimateWithScroll(view: name, goalXY: ngXY, startXY: nameStartXY, goalWH: ngWH, startWH: nameStartWH, fontSG: fontNameSG)
        
        name.sizeToFit()
        
        myAnimateWithScroll(view: coinValue, goalXY: cvgXY, startXY: coinValueStartXY, goalWH: cvgWH, startWH: coinValueStartWH, fontSG: fontCoinSG)
        
        myAnimateWithScroll(view: coinIcon, goalXY: cigXY, startXY: coinIconStartXY, goalWH: cigWH, startWH: coinIconStartWH, fontSG: pgXY)
        
        //============//
        
        let k: CGFloat = (offsetOfsemiCircular + heightOfSemiCircular) / (offsetOfsemiCircular + heightOfSemiCircular - navigationBar.frame.height)
        
        var myPercentage = 1 - k * ( scrollViewProfile.contentOffset.y / (semicircularView.frame.origin.y + semicircularView.frame.height) )
        
        print(myPercentage)
        
        if(myPercentage < 0){
            
            myPercentage = 0
            
        }
        if(myPercentage > 1){
            
            myPercentage = 1
            
        }
        
        navigationBar.alpha = 1 - myPercentage
        
        semicircularView.frame.origin.y = offsetOfsemiCircular + (heightOfSemiCircular - (heightOfSemiCircular * (myPercentage)))
        
        semicircularView.frame.size.height = heightOfSemiCircular * (myPercentage)

        profilePicButton.layer.cornerRadius = profilePicButton.frame.height * 0.5

    
    }
    



    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
