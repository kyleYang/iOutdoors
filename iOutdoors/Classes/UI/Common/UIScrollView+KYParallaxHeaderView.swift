//
//  UIScrollView+KYParallaxHeaderView.swift
//  iOutdoors
//
//  Created by Kyle on 15/8/11.
//  Copyright (c) 2015年 xiaoluuu. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC



private var KYParallaxHeaderInsetObserverContext = 0
private var KYParallaxHeaderConentOffsetObserverContext = 1
private var KYScrollViewContentInset : String = "contentInset"
private var KYScrollViewContentOffset : String = "contentOffset"

enum KYParallaxHeaderMode : Int{
    case ModeCenter
    case ModeFill
    case ModeTop
    case ModeTopFill
}


class KYParallaxHeaderView : UIView {
    
    var mode : KYParallaxHeaderMode! = .ModeCenter
    var scrollView : UIScrollView!
    
    private var _contentView : UIView?
    var contentView : UIView?{
        
        get{
            return _contentView
        }
        
        set{
            
            if let temp = _contentView {
                
                temp.removeFromSuperview()
            }
            
            newValue?.setTranslatesAutoresizingMaskIntoConstraints(false)
            containerView.addSubview(newValue!)
            _contentView = newValue!
            self.setupContentViewMode()
            
        }
    }
    var containerView : UIView!
    
    var originalTopInset : CGFloat!
    var originalHeight : CGFloat!
    var headerHeight : CGFloat!
    
    var isInsideTableView : Bool = false
    
    var insetAwarePositionConstraint : NSLayoutConstraint?
    var insetAwareSizeConstraint : NSLayoutConstraint?
    
    var progress : CGFloat?

    init(scrollview: UIScrollView,contentView uivew:UIView, modeValue:KYParallaxHeaderMode, height:CGFloat) {
        super.init(frame: CGRectMake(0, 0, scrollview.width(), height))
        
        mode = modeValue
        scrollView = scrollview
        
        
        originalHeight = height
        originalTopInset = scrollView.contentInset.top
        
        containerView = UIView(frame: self.bounds)
        containerView.clipsToBounds = true
        
        if !isInsideTableView{
            containerView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
            self.autoresizingMask = .FlexibleWidth
        }
        
        self.addSubview(containerView)
        
        self.contentView = uivew
        
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupContentViewMode(){
        
        if let mode = mode{
            switch(mode){
            case .ModeCenter:
    
                self.addContentViewModeCenterConstraints()
                
            case .ModeFill:
                
                self.addContentViewModeFillConstraints()
                
            case .ModeTop:
                
                self.addContentViewModeTopFillConstraints()
                
            case .ModeTopFill:
                
                self.addContentViewModeTopFillConstraints()
                
            default:
                
                self.addContentViewModeCenterConstraints()
            }

        
        }
    }
    
    
    //MARK: 
    private func addContentViewModeFillConstraints(){
        
        var views : Dictionary = ["containerView":containerView,"contentView":_contentView]
        
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[contentView]|", options:NSLayoutFormatOptions(0), metrics:nil, views:views))
        
        insetAwarePositionConstraint = NSLayoutConstraint(item: _contentView!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem:containerView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: originalTopInset/2)
       containerView.addConstraint(insetAwarePositionConstraint!)
        
        var constraint = NSLayoutConstraint(item: _contentView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem:nil, attribute: NSLayoutAttribute.Height, multiplier: 0.0, constant:originalHeight)
        constraint.priority = 1000
        containerView.addConstraint(constraint)
        
        insetAwareSizeConstraint = NSLayoutConstraint(item:_contentView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: containerView, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: -originalTopInset)
        insetAwareSizeConstraint?.priority = 750
        containerView.addConstraint(insetAwareSizeConstraint!)
        
    }
    
    private func addContentViewModeTopConstraints(){
        
        
        insetAwarePositionConstraint = NSLayoutConstraint(item: _contentView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: originalTopInset)
        containerView.addConstraint(insetAwarePositionConstraint!)
        
        var views : Dictionary = ["containerView":containerView,"contentView":_contentView]
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[contentView]|", options:NSLayoutFormatOptions(0), metrics:nil, views:views))
    
        containerView.addConstraint(NSLayoutConstraint(item:_contentView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 0.0, constant: originalHeight))
        
        
    }
    
    private func addContentViewModeTopFillConstraints(){
     
        insetAwarePositionConstraint = NSLayoutConstraint(item: _contentView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: originalTopInset)
        containerView.addConstraint(insetAwarePositionConstraint!)
        
        var views : Dictionary = ["containerView":containerView,"contentView":_contentView]
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[contentView]|", options:NSLayoutFormatOptions(0), metrics:nil, views:views))
        
        var constraint = NSLayoutConstraint(item: _contentView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem:nil, attribute: NSLayoutAttribute.Height, multiplier: 0.0, constant:originalHeight)
        constraint.priority = 1000
        containerView.addConstraint(constraint)

        insetAwareSizeConstraint = NSLayoutConstraint(item:_contentView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: containerView, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: -originalTopInset)
        containerView.addConstraint(insetAwareSizeConstraint!)
        insetAwareSizeConstraint?.priority = 750;

        
    }
    
    private func addContentViewModeCenterConstraints(){
        
        var views : Dictionary = ["containerView":containerView,"contentView":_contentView]
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[contentView]|", options:NSLayoutFormatOptions(0), metrics:nil, views:views))
        
        var constraint = NSLayoutConstraint(item: _contentView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem:nil, attribute: NSLayoutAttribute.Height, multiplier: 0.0, constant:originalHeight)
        constraint.priority = 1000
        containerView.addConstraint(constraint)
        
        
        insetAwarePositionConstraint = NSLayoutConstraint(item: _contentView!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem:containerView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: originalTopInset/2)
        containerView.addConstraint(insetAwarePositionConstraint!)
    }
   
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
        if keyPath == KYScrollViewContentInset && context == &KYParallaxHeaderInsetObserverContext {
            
            var edgeInsets : UIEdgeInsets = (change[NSKeyValueChangeNewKey] as! NSValue).UIEdgeInsetsValue()
            
            self.originalTopInset = edgeInsets.top - ((!self.isInsideTableView) ? self.originalHeight : 0);
            
            if let mode = mode{
                switch(mode){
                case .ModeCenter:
                    
                    insetAwarePositionConstraint?.constant = originalTopInset/2
                    
                case .ModeFill:
                    
                    insetAwarePositionConstraint?.constant = originalTopInset/2
                    insetAwareSizeConstraint?.constant = -originalTopInset
                    
                case .ModeTop:
                    
                    insetAwarePositionConstraint?.constant = originalTopInset
                    
                case .ModeTopFill:
                    
                    insetAwarePositionConstraint?.constant = originalTopInset
                    insetAwareSizeConstraint?.constant = -originalTopInset
                    
                default:
                    
                    insetAwarePositionConstraint?.constant = originalTopInset/2
                }
                
                
            }
            
            
            if !isInsideTableView{
                self.scrollView.contentOffset = CGPointMake(0, -scrollView.contentInset.top)
            }
    
            
            // Refresh Sticky View Constraints
            self.updateStickyViewConstraints()

        }
    }
    
    
    
    private func updateStickyViewConstraints(){
        
    }

    
}




private var HeaderViewIdentifier : UInt8 = 0

extension UIScrollView {
    
    var headerView : KYParallaxHeaderView {
    
        get{
            return (objc_getAssociatedObject(self, &HeaderViewIdentifier) as? KYParallaxHeaderView)!
        }
        set{
            
            if  self.subviews.count > 0 {
                
                for (index, value) in enumerate(self.subviews){
                    
                    if value.isMemberOfClass(KYParallaxHeaderView){
                        value.removeFromSuperview()
                    }
                }
                
            }
            
            newValue.isInsideTableView = self.isKindOfClass(UITableView)
            if newValue.isInsideTableView {
                var tableView : UITableView = self as! UITableView
                tableView.tableHeaderView = newValue
            }else{
                self.addSubview(newValue)
            }
            
            objc_setAssociatedObject(self, &HeaderViewIdentifier, newValue, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
        
    }
    
    /**
    
    category for UIScrollView to set a ParallaxHeaderView
    
    :param: view
    :param: mode
    :param: height
    */
    func setParallaxHeaderView(view : UIView,mode:KYParallaxHeaderMode, height:CGFloat){
        
        self.headerView = KYParallaxHeaderView(scrollview: self, contentView: view, modeValue: mode, height: height)
        self.headerView.headerHeight = height
        
        self.shouldPositionParallaxHeader()
        
        
        
        if !self.headerView.isInsideTableView {
            var selfContentInset : UIEdgeInsets = self.contentInset
            selfContentInset.top += height
            
            self.contentInset = selfContentInset;
            self.contentOffset = CGPointMake(0, -selfContentInset.top);

        }
        
       self.addObserver(self.headerView, forKeyPath:KYScrollViewContentInset, options: .New, context: &KYParallaxHeaderInsetObserverContext)
       self.addObserver(self, forKeyPath:KYScrollViewContentOffset, options: .New, context: &KYParallaxHeaderConentOffsetObserverContext)
        
    }
    
    
    private func shouldPositionParallaxHeader(){
        
        if self.headerView.isInsideTableView {
            self.positionTableViewParallaxHeader()
        }else {
            self.positionScrollViewParallaxHeader()
        }
        
    }
    
    
    
    private func positionTableViewParallaxHeader(){
        
        var scaleProgress = fmaxf(Float(0), Float((1 - ((self.contentOffset.y + self.headerView.originalTopInset) / self.headerView.originalHeight))))
        self.headerView.progress = CGFloat(scaleProgress)
        
        if self.contentOffset.y < self.headerView.originalHeight {
            
            var height = self.contentOffset.y * -1 + self.headerView.originalHeight
            
            if self.headerView.mode == .ModeCenter {
                height = round(height)
            }
            
            self.headerView.containerView.frame = CGRectMake(0, self.contentOffset.y, CGRectGetWidth(self.frame), height);
        }
        
    }
    
    
    private func positionScrollViewParallaxHeader(){
        
        var height = self.contentOffset.y * -1
        
        var scaleProgress = CGFloat(fmaxf(Float(0), Float(height / (self.headerView.originalHeight + self.headerView.originalTopInset))))
        self.headerView.progress = scaleProgress;
        
        if (self.contentOffset.y < 0) {
            // This is where the magic is happening
            self.headerView.frame = CGRectMake(0, self.contentOffset.y, CGRectGetWidth(self.frame), height);
        }

        
    }
    
    
    public override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
        if keyPath == KYScrollViewContentOffset && context == &KYParallaxHeaderConentOffsetObserverContext {
            
            self.shouldPositionParallaxHeader()
        }
        
    }
    
    
}