//
//  UIColor+Extension.swift
//  iOutdoors
//
//  Created by Kyle on 15/8/10.
//  Copyright (c) 2015年 xiaoluuu. All rights reserved.
//

import Foundation
import UIKit


func RGB(R r:CGFloat,G g:CGFloat,B b:CGFloat,A a:CGFloat) -> UIColor{
    
    let alpa = CGFloat(a ?? 1.0)
    return UIColor(red: r, green: g, blue: b, alpha:alpa)
    
}

func UIColorFromRGB(rgb: Int, alpha: Float!) -> UIColor {
    
    let red = CGFloat(Float(((rgb>>16) & 0xFF)) / 255.0)
    let green = CGFloat(Float(((rgb>>8) & 0xFF)) / 255.0)
    let blue = CGFloat(Float(((rgb>>0) & 0xFF)) / 255.0)
    let alpha = CGFloat(alpha)
    
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
}

func UIColorFromRGB(rgb: Int) -> UIColor {
    return UIColorFromRGB(rgb,1.0)
}


extension UIColor{
    
}
