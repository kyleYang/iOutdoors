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
    var borderColor : UIColor! = UIColor.clearColor(){
        
        didSet{
            self.setNeedsDisplay()
        }
    }
    var hilightColor : UIColor? = UIColorFromRGB(0xee766a){
        
        didSet{
            self.setNeedsDisplay()
        }
        
    }
    var normalColor : UIColor? = UIColor.darkGrayColor(){

        didSet(color){
            self.setNeedsDisplay()
        }
        
    }
    
    
    var hilightImage : UIImage?{
        
        didSet{
            self.setNeedsDisplay()
        }
        
    }
    var normalImage : UIImage?{
        
        didSet{

            self.setNeedsDisplay()
        }
        
    }

    var dotWidth : CGFloat! = 5.0{
        
        didSet{
            self.setNeedsDisplay()
        }
        
    }
    
    var dotSpace : CGFloat! = 5.0{
        
        didSet{
            self.setNeedsDisplay()
        }
        
    }
    
    var current : Int? {
    
        didSet(cur){
            self.setNeedsDisplay()
        }
        
    }
    var pageNumber : Int! = 0{

        didSet{
            self.setNeedsDisplay()
        }
    
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
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
        var y = CGRectGetHeight(currentBounds)/2 - CGFloat(dotWidth/2)
        
        
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