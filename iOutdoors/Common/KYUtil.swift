//
//  KYUtil.swift
//  iOutdoors
//
//  Created by Kyle on 15/8/8.
//  Copyright (c) 2015年 xiaoluuu. All rights reserved.
//

import Foundation
import UIKit


//MARK: UIColor Method

func UIColorFromRGB(rgbValue: UInt) -> UIColor {

    return UIColorFromRGB(rgbValue,1.0)
    
}

func UIColorFromRGB(rgbValue: UInt,alpha: CGFloat) -> UIColor{
    
    let red : CGFloat =  CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
    let green : CGFloat =  CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
    let blue : CGFloat =  CGFloat(rgbValue & 0x0000FF) / 255.0
    let alpah : CGFloat = alpha ?? 1.0
    
    return UIColor(red: red, green: green, blue: blue, alpha: alpah)
    
}



//MARK: math method

func radians(degree : Double) ->Double {
    
    return degree * M_PI / 180.0
}