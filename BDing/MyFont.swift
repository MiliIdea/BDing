//
//  MyFont.swift
//  BDingTest
//
//  Created by Milad on 2/28/17.
//  Copyright © 2017 Milad. All rights reserved.
//

import Foundation

import UIKit

class MyFont: NSObject {
    

    func setWebFont(view: UIView , mySize: Float){
        
        if(view is UILabel){
            (view as! UILabel).font = UIFont(name: "IRANSansWeb", size: CGFloat(mySize))
        }else if(view is UITextView){
            (view as! UITextView).font = UIFont(name: "IRANSansWeb", size: CGFloat(mySize))
        }else if(view is UITextField){
            (view as! UITextField).font = UIFont(name: "IRANSansWeb", size: CGFloat(mySize))

        }
        
    }
    
    func setWebFont(view: UIView , mySize: Float , mycolor: String){
        
        if(view is UILabel){
            (view as! UILabel).font = UIFont(name: "IRANSansWeb", size: CGFloat(mySize))
            
            (view as! UILabel).textColor = UIColor(hex: mycolor)
            
        }else if(view is UITextView){
            (view as! UITextView).font = UIFont(name: "IRANSansWeb", size: CGFloat(mySize))
            
            (view as! UITextView).textColor = UIColor(hex: mycolor)
        }else if(view is UITextField){
            (view as! UITextField).font = UIFont(name: "IRANSansWeb", size: CGFloat(mySize))
            
            (view as! UITextField).textColor = UIColor(hex: mycolor)
            
        }
        
    }
    
    func setBoldFont(view: UIView , mySize: Float){
        
        if(view is UILabel){
            (view as! UILabel).font = UIFont(name: "IRANYekanMobile-Bold", size: CGFloat(mySize))
        }else if(view is UITextView){
            (view as! UITextView).font = UIFont(name: "IRANYekanMobile-Bold", size: CGFloat(mySize))
        }else if(view is UITextField){
            (view as! UITextField).font = UIFont(name: "IRANYekanMobile-Bold", size: CGFloat(mySize))
        }
    }
    
    func setBoldFont(view: UIView , mySize: Float , mycolor: String){
        
        if(view is UILabel){
            (view as! UILabel).font = UIFont(name: "IRANYekanMobile-Bold", size: CGFloat(mySize))
            
            (view as! UILabel).textColor = UIColor(hex: mycolor)
            
        }else if(view is UITextView){
            (view as! UITextView).font = UIFont(name: "IRANYekanMobile-Bold", size: CGFloat(mySize))
            
            (view as! UITextView).textColor = UIColor(hex: mycolor)
        }else if(view is UITextField){
            (view as! UITextField).font = UIFont(name: "IRANYekanMobile-Bold", size: CGFloat(mySize))
            
            (view as! UITextField).textColor = UIColor(hex: mycolor)
            
        }
    }
    //IRANSansWeb-Bold
    
    func setLightFont(view: UIView , mySize: Float){
        
        if(view is UILabel){
            (view as! UILabel).font = UIFont(name: "IRANYekanMobile", size: CGFloat(mySize))
        }else if(view is UITextView){
            (view as! UITextView).font = UIFont(name: "IRANYekanMobile", size: CGFloat(mySize))
        }else if(view is UITextField){
            (view as! UITextField).font = UIFont(name: "IRANYekanMobile", size: CGFloat(mySize))
        }
    }
    
    func setLightFont(view: UIView , mySize: Float , mycolor: String){
        
        if(view is UILabel){
            (view as! UILabel).font = UIFont(name: "IRANYekanMobile", size: CGFloat(mySize))
            
            (view as! UILabel).textColor = UIColor(hex: mycolor)
            
        }else if(view is UITextView){
            (view as! UITextView).font = UIFont(name: "IRANYekanMobile", size: CGFloat(mySize))
            
            (view as! UITextView).textColor = UIColor(hex: mycolor)
        }else if(view is UITextField){
            (view as! UITextField).font = UIFont(name: "IRANYekanMobile", size: CGFloat(mySize))
            
            (view as! UITextField).textColor = UIColor(hex: mycolor)
            
        }
        
    }

    //IRANSansWeb-Light
    
    func setMediumFont(view: UIView , mySize: Float){
        
        if(view is UILabel){
            (view as! UILabel).font = UIFont(name: "IRANYekanMobile", size: CGFloat(mySize))
        }else if(view is UITextView){
            (view as! UITextView).font = UIFont(name: "IRANYekanMobile", size: CGFloat(mySize))
        }else if(view is UITextField){
            (view as! UITextField).font = UIFont(name: "IRANYekanMobile", size: CGFloat(mySize))
        }else if(view is UIButton){
            (view as! UIButton).titleLabel?.font = UIFont(name: "IRANYekanMobile", size: CGFloat(mySize))!
        }
    }
    
    func setMediumFont(view: UIView , mySize: Float , mycolor: String){
        
        if(view is UILabel){
            (view as! UILabel).font = UIFont(name: "IRANYekanMobile", size: CGFloat(mySize))
            
            (view as! UILabel).textColor = UIColor(hex: mycolor)
            
        }else if(view is UITextView){
            (view as! UITextView).font = UIFont(name: "IRANYekanMobile", size: CGFloat(mySize))
            
            (view as! UITextView).textColor = UIColor(hex: mycolor)
        }else if(view is UITextField){
            (view as! UITextField).font = UIFont(name: "IRANYekanMobile", size: CGFloat(mySize))
            
            (view as! UITextField).textColor = UIColor(hex: mycolor)
            
        }else if(view is UIButton){
            
//            for name in UIFont.familyNames {
//                print(name)
//                if let nameString = name as? String
//                {
//                    print(UIFont.fontNames(forFamilyName: nameString))
//                }
//            }
            
            (view as! UIButton).titleLabel?.font = UIFont(name: "IRANYekanMobile", size: CGFloat(mySize))!
            
            (view as! UIButton).titleLabel?.textColor = UIColor(hex: mycolor)
        }
        
    }
    //IRANYekanMobile-Bold", "IRANYekanMobile", "IRANYekanMobile-Light
    //IRANSansWeb-Medium
    
    func setUltraLightFont(view: UIView , mySize: Float){
        
        if(view is UILabel){
            (view as! UILabel).font = UIFont(name: "IRANYekanMobile-Light", size: CGFloat(mySize))
        }else if(view is UITextView){
            (view as! UITextView).font = UIFont(name: "IRANYekanMobile-Light", size: CGFloat(mySize))
        }else if(view is UITextField){
            (view as! UITextField).font = UIFont(name: "IRANYekanMobile-Light", size: CGFloat(mySize))
        }
    }
    
    func setUltraLightFont(view: UIView , mySize: Float , mycolor: String){
        
        if(view is UILabel){
            (view as! UILabel).font = UIFont(name: "IRANYekanMobile-Light", size: CGFloat(mySize))
            
            (view as! UILabel).textColor = UIColor(hex: mycolor)
            
        }else if(view is UITextView){
            (view as! UITextView).font = UIFont(name: "IRANYekanMobile-Light", size: CGFloat(mySize))
            
            (view as! UITextView).textColor = UIColor(hex: mycolor)
        }else if(view is UITextField){
            (view as! UITextField).font = UIFont(name: "IRANYekanMobile-Light", size: CGFloat(mySize))
            
            (view as! UITextField).textColor = UIColor(hex: mycolor)
            
        }
        
    }
    //IRANSansWeb-UltraLight
    
    
}
