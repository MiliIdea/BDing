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
    
    
    private func isThereThisPicInDB (code: String) -> String?{
        
        for i in SaveAndLoadModel().load(entity: "IMAGE")!{
            
            if(i.value(forKey: "imageCode") as! String == code){
                
                return i.value(forKey: "imageData") as! String
                
            }
            
        }
        
        return nil
        
    }

    
}
