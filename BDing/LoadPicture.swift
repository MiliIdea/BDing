//
//  LoadPicture.swift
//  BDing
//
//  Created by MILAD on 5/3/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation
import UIKit

class LoadPicture {
    
    static var cache: NSCache<AnyObject, AnyObject> = NSCache()
    
    
    func load(picModel: PicModel) -> UIImage?{
        
        var tempCode = picModel.url
        
        tempCode?.append((picModel.code)!)
        
        let result: String? = isThereThisPicInDB(code: (tempCode?.md5())!)
        
        if(result != nil){
            
            if LoadPicture.cache.object(forKey: tempCode?.md5() as AnyObject) != nil {
                
                return UIImage(data: LoadPicture.cache.object(forKey: tempCode?.md5() as AnyObject) as! Data)!
                
            }else{
                
                let imageData = NSData(base64Encoded: result!, options: .ignoreUnknownCharacters)
                
                LoadPicture.cache.setObject(imageData!, forKey: tempCode?.md5() as AnyObject)
                
                return UIImage(data: imageData as! Data)!
                
            }
            
        }else{
            
            return nil
            
        }
        
    }
    
    func proLoad(view : UIImageView? ,picType : String = "beacon" ,picModel: PicModel , completion: @escaping (UIImage)->Void){
        
        let loading : UIActivityIndicatorView = UIActivityIndicatorView()
        
        if(view != nil){
            
            loading.frame(forAlignmentRect: (view?.frame)!)
            
            loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            view?.addSubview(loading)
            
            loading.hidesWhenStopped = true
            
            loading.frame.origin.x = (view?.frame.width)! / 2
            
            loading.frame.origin.y = (view?.frame.height)! / 2
            
            loading.startAnimating()
            
        }
        
        
        var tempCode = picModel.url
        
        tempCode?.append((picModel.code)!)
        
        let result: String? = isThereThisPicInDB(code: (tempCode?.md5())!)
        
        if(result != nil){
            
            DispatchQueue.main.async(execute: { () -> Void in
            
                if LoadPicture.cache.object(forKey: tempCode?.md5() as AnyObject) != nil {
                    if(view != nil){
                        loading.stopAnimating()
                    }
                    completion(UIImage(data: LoadPicture.cache.object(forKey: tempCode?.md5() as AnyObject) as! Data)!)
                    
                }else{
                    
                    let imageData = NSData(base64Encoded: result!, options: .ignoreUnknownCharacters)
                    
                    LoadPicture.cache.setObject(imageData!, forKey: tempCode?.md5() as AnyObject)
                    if(view != nil){
                        loading.stopAnimating()
                    }
                    completion(UIImage(data: imageData as! Data)!)
                    
                }
            
            })
            
        }else{
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                if(picType == "beacon"){
                    
                    //////
                    request("http://"+(picModel.url)! ,method: .post ,parameters: BeaconPicRequestModel(CODE: picModel.code, FILE_TYPE: picModel.file_type).getParams(), encoding : JSONEncoding.default).responseJSON { response in
                        
                        if let image = response.result.value {
                            
                            print("^^^^^^^^^^^" , image)
                            
                            let obj = PicDataModel.init(json: image as! JSON)
                            
                            if(obj?.data != nil){
                                
                                let imageData = NSData(base64Encoded: (obj?.data!)!, options: .ignoreUnknownCharacters)
                                
                                var coding: String = (picModel.url)!
                                
                                coding.append((picModel.code)!)
                                
                                SaveAndLoadModel().save(entityName: "IMAGE", datas: ["imageCode": coding.md5() , "imageData": obj?.data!])
                                
                                LoadPicture.cache.setObject(imageData!, forKey: coding.md5() as AnyObject)
                                if(view != nil){
                                    loading.stopAnimating()
                                }
                                completion(UIImage(data: imageData as! Data)!)
                                
                            }
                            
                        }
                    }
                    ///////
                    
                }else if(picType == "coupon"){
                    
                    //////
                    request("http://"+(picModel.url)! ,method: .post ,parameters: CouponRequestPicModel(CODE: picModel.code, FILE_TYPE: picModel.file_type).getParams(), encoding : JSONEncoding.default).responseJSON { response in
                        
                        if let image = response.result.value {
                            
                            print("^^^^^^^^^^^" , image)
                            
                            let obj = PicDataModel.init(json: image as! JSON)
                            
                            if(obj?.data != nil){
                                
                                let imageData = NSData(base64Encoded: (obj?.data!)!, options: .ignoreUnknownCharacters)
                                
                                var coding: String = (picModel.url)!
                                
                                coding.append((picModel.code)!)
                                
                                SaveAndLoadModel().save(entityName: "IMAGE", datas: ["imageCode": coding.md5() , "imageData": obj?.data!])
                                
                                LoadPicture.cache.setObject(imageData!, forKey: coding.md5() as AnyObject)
                                if(view != nil){
                                    loading.stopAnimating()
                                }
                                completion(UIImage(data: imageData as! Data)!)
                                
                            }
                            
                        }
                    }
                    ///////
                    
                }
                
            })
        
        }
        
    }
    
    
    
    private func isThereThisPicInDB (code: String) -> String?{
        
        for i in SaveAndLoadModel().load(entity: "IMAGE")!{
            
            if(i.value(forKey: "imageCode") as! String == code){
                
                return i.value(forKey: "imageData") as! String
                
            }
            
        }
        
        return nil
        
    }

    
}
