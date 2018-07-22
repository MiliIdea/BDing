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
                autoreleasepool { () -> () in
                
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
                
                }
            
            })
            
        }else{
            
            DispatchQueue.main.asyncAfter(deadline : DispatchTime.now() + 0.2 ,execute: { () -> Void in
                
//                autoreleasepool { () -> () in
                
                    if(picType == "beacon"){
                        
                        //////
                        request("http://"+(picModel.url)! ,method: .post ,parameters: BeaconPicRequestModel(CODE: picModel.code, FILE_TYPE: picModel.file_type).getParams(), encoding : JSONEncoding.default).responseJSON { response in
                            
                            if let image = response.result.value {
                                
                                print("++++++++++++" , image)
                                
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
                            
//                            if  (response.result.value != nil) {
//                            
//                                if var image = response.data {
//                                    
//                                    if((response.data?.bytes.count)! > 0){
//                                        
//                                        var coding: String = (picModel.url)!
//                                        
//                                        coding.append((picModel.code)!)
//                                        
////                                        let image2 = self.resizeImage(image: UIImage(data : image)!, targetSize: CGSize(width : 200.0,height : 200.0))
//                                        
////                                        image = UIImagePNGRepresentation(image2)!
//                                        
//                                        SaveAndLoadModel().save(entityName: "IMAGE", datas: ["imageCode": coding.md5() , "imageData": image.base64EncodedString()])
//                                        
//                                        LoadPicture.cache.setObject(image as AnyObject, forKey: coding.md5() as AnyObject)
//                                        if(view != nil){
//                                            loading.stopAnimating()
//                                        }
//                                        completion(UIImage(data: image)!)
////                                        completion(image2)
//                                    }
//                                    
//                                }
//                            
//                            }
                        }
                        ///////
                        
                    }else if(picType == "coupon"){
                        
                        //////
                        print(CouponRequestPicModel(CODE: picModel.code, FILE_TYPE: picModel.file_type).getParams())
                        print("AAAAAAAA")
                        request("http://"+(picModel.url)! ,method: .post ,parameters: CouponRequestPicModel(CODE: picModel.code, FILE_TYPE: picModel.file_type).getParams(), encoding : JSONEncoding.default).responseJSON { response in
                            
                            if let image = response.result.value {
                                
                                print("++++++++++++" , image)
                                
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
                
//                }
            })
        
        }
        
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
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
