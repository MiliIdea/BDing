//
//  AnnotationView.swift
//  BDing
//
//  Created by MILAD on 6/28/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation
import UIKit
import HDAugmentedReality
import SwiftyGif

//1
protocol AnnotationViewDelegate {
    func didTouch(annotationView: AnnotationView)
}

//2
class AnnotationView: ARAnnotationView {
    //3
    var titleLabel: UILabel?
    var distanceLabel: UILabel?
    var imageView : UIImageView?
    var delegate: AnnotationViewDelegate?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        loadUI()
    }
    
    //4
    func loadUI() {
        titleLabel?.removeFromSuperview()
        distanceLabel?.removeFromSuperview()
        imageView?.removeFromSuperview()
        
        let label = UILabel(frame: CGRect(x: 10, y: 40, width: self.frame.size.width, height: 20))
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.backgroundColor = UIColor(white: 0.3, alpha: 0.2)
        label.textColor = UIColor.white
        label.contentMode = .center
        label.textAlignment = .center
        self.addSubview(label)
        self.titleLabel = label
        
        distanceLabel = UILabel(frame: CGRect(x: 10, y: 60, width: self.frame.size.width, height: 20))
        distanceLabel?.backgroundColor = UIColor(white: 0.3, alpha: 0.2)
        distanceLabel?.textColor = UIColor.green
        distanceLabel?.font = UIFont.systemFont(ofSize: 10)
        distanceLabel?.contentMode = .center
        distanceLabel?.textAlignment = .center
        self.addSubview(distanceLabel!)
        imageView = UIImageView.init(frame: CGRect(x: self.frame.width / 2 - 10, y: 0, width: 40, height: 40))
        
        if let annotation = annotation as? Place {
            titleLabel?.text = annotation.placeName
            distanceLabel?.text = String(format: "%.2f km", annotation.distanceFromUser / 1000)
            
            if(annotation.image == nil){
                
                let gifmanager = SwiftyGifManager(memoryLimit:20)
                imageView = UIImageView(gifImage: UIImage.init(gifName: "cartoon"), manager: gifmanager)
                
                self.addSubview(imageView!)
                
            }else{
                
                imageView?.image = annotation.image
                
                self.addSubview(imageView!)
                
            }
            
        }
    }
    
    //1
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.frame = CGRect(x: 10, y: 40, width: self.frame.size.width, height: 20)
        distanceLabel?.frame = CGRect(x: 10, y: 60, width: self.frame.size.width, height: 20)
        imageView?.frame = CGRect(x: self.frame.width / 2 - 10, y: 0, width: 40, height: 40)
        
    }
    
    //2
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didTouch(annotationView: self)
    }
}
