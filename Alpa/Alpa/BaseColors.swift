//
//  BaseColors.swift
//  Alpa
//
//  Created by ROHAN DAVE on 19/03/17.
//  Copyright © 2017 Rohan Dave. All rights reserved.
//

import UIKit



extension UIColor {
    
    // MARK:
    // MARK: Extended Public Methods
    
    static func colorForOrangeGradientWithAlpha(alpha: CGFloat) -> UIColor! {
        
        return UIColor.init(red: 255/255, green: 126/255, blue: 26/255, alpha: alpha)
    }
    
    static func colorForMidOrangeGradientWithAlpha(alpha: CGFloat) -> UIColor! {
        
        return UIColor.init(red: 244/255, green: 157/255, blue: 34/255, alpha: alpha)
    }
    
    static func colorForYellowGradientWithAlpha(alpha: CGFloat) -> UIColor! {
        
        return UIColor.init(red: 246/255, green: 190/255, blue: 60/255, alpha: alpha)
    }
    
    
    static func colorForHappiness() -> UIColor! {
        
        return UIColor(red: 0.51, green: 0.80, blue: 0.31, alpha: 1.0)
    }
    
    static func colorForNeutral() -> UIColor! {
        
        return UIColor(red: 0.62, green: 0.86, blue: 0.91, alpha: 1.0)
    }
    
    static func colorForSurprise() -> UIColor! {
        
        return UIColor(red: 1.0, green: 0.92, blue: 0.67, alpha: 1.0)
    }
    
    static func colorForSadness() -> UIColor! {
        
        return UIColor(red: 0.16, green: 0.46, blue: 0.73, alpha: 1.0)
    }
    
    static func colorForFear() -> UIColor! {
        
        return UIColor(red: 0.89, green: 0.61, blue: 0.90, alpha: 1.0)
    }
    
    static func colorForDisgust() -> UIColor! {
        
        return UIColor(red: 0.37, green: 0.07, blue: 0.61, alpha: 1.0)
    }
    
    static func colorForContempt() -> UIColor! {
        
        return UIColor.black
    }
}
