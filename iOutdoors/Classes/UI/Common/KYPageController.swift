//
//  KYPageController.swift
//  iOutdoors
//
//  Created by Kyle on 15/8/7.
//  Copyright (c) 2015年 xiaoluuu. All rights reserved.
//

import Foundation
import UIKit

class KYPageController : UIView  {
    
    //MARK:-------------------
    //MARK: override property
    var borderColor : UIColor!{
        
        get{
            return self.borderColor ?? UIColor.clearColor()
        }
        
        set(color){
            self.borderColor = color
            self.setNeedsDisplay()
        }
    }
    var hilightColor : UIColor?{
        
        get{
            return self.hilightColor ?? UIColorFromRGB(0xee766a)
        }
        
        set(color){
            self.hilightColor = color
            self.setNeedsDisplay()
        }
        
    }
    var normalColor : UIColor?{
        
        get{
            return self.normalColor ?? UIColor.darkGrayColor()
        }
        
        set(color){
            self.normalColor = color
            self.setNeedsDisplay()
        }
        
    }
    
    
    var hilightImage : UIImage?{
        
        get{
            return self.hilightImage
        }
        
        set(image){
            self.hilightImage = image
            self.setNeedsDisplay()
        }
        
    }
    var normalImage : UIImage?{
        
        get{
            return self.normalImage
        }
        
        set(image){
            self.normalImage = image
            self.setNeedsDisplay()
        }
        
    }

    var dotWidth : CGFloat!{
        
        get{
            return self.dotWidth ?? 5.0
        }
        
        set(width){
            self.dotWidth = width
            self.setNeedsDisplay()
        }
        
    }
    
    var dotSpace : CGFloat!{
        
        get{
            return self.dotSpace ?? 5.0
        }
        
        set(space){
            self.dotSpace = space
            self.setNeedsDisplay()
        }
        
    }
    
    var current : Int? {
       
        get{
            return self.current
        }
        set(cur){
            self.current = cur
            self.setNeedsDisplay()
        }
        
    }
    var pageNumber : Int! {
    
        get{
            return self.pageNumber
        }
        set(number){
            self.pageNumber = number
            self.setNeedsDisplay()
        }
    
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   //MARK: over write the drawRect
    override func drawRect(rect: CGRect) {
        
        if (pageNumber == 0 || pageNumber == 1) { //不用轮播
            return;
        }
        
        var context : CGContext! = UIGraphicsGetCurrentContext()
        CGContextSetAllowsAntialiasing(context, true);
       
        var currentBounds : CGRect! = self.bounds
        var dotsWidth : CGFloat = CGFloat(pageNumber) * dotWidth + CGFloat(max(0,(pageNumber-1)))*dotSpace!
        var x = CGRectGetMidX(currentBounds) - CGFloat(dotsWidth/2)
        var y = CGRectGetMinY(currentBounds) - CGFloat(dotWidth/2)
        
        
        for i in 0..<pageNumber {
            
            let circleRect = CGRectMake(x, y, dotWidth, dotWidth)
            
            CGContextSetStrokeColorWithColor(context,self.borderColor.CGColor)
            let path = CGPathCreateMutable()
            CGContextSetLineWidth(context,5)
            CGPathAddArc(path,nil,x+self.dotWidth/2,x+self.dotWidth/2,self.dotWidth/2,CGFloat(radians(0)), CGFloat(radians(360)), false)
            CGContextAddPath(context,path)
            CGContextStrokePath(context)
        
            
            if i == current
            {
                if hilightImage != nil
                {
                    hilightImage?.drawInRect(circleRect)
                }else{
                    CGContextSetFillColorWithColor(context,self.hilightColor?.CGColor)
                    CGContextFillEllipseInRect(context,circleRect)
                }
                
            }else{
                
                if normalImage != nil
                {
                    normalImage?.drawInRect(circleRect)
                }else{
                    CGContextSetFillColorWithColor(context,self.normalColor?.CGColor)
                    CGContextFillEllipseInRect(context,circleRect)
                }
                
            }

            x += self.dotWidth + self.dotSpace;
            
        }
    }
    
        
    
}