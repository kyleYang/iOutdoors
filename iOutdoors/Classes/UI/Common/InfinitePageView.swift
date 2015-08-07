//
//  InfinitePageView.swift
//  iOutdoors
//
//  Created by Kyle on 15/8/7.
//  Copyright (c) 2015年 xiaoluuu. All rights reserved.
//

import Foundation
import UIKit

//MARK: InfinitPageViewDelegate
protocol InfinitPageViewDelegate : NSObjectProtocol {
    
    func numberOfCellInInfinitPageView(pageView: InfinitePageView) -> Int
    func infinitPageView(pageView: InfinitePageView, cellForRowAtIndex index: Int) -> UITableViewCell
    
}



//MARK: InfinitPageViewCell
class InfinitPageViewCell : UIView{
    
    var cellTag : Int?
    var identifier : String! = "InfinitPageViewCell"
    
    //MARK: init method like UITableViewCell
    internal init(frame:CGRect, identifier: String){
        super.init(frame: frame);
        self.identifier = identifier
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    //MARK: ------------------
    //MARK: Method for override
    func viewWillAppear(){
    
    }
    
    func viewDidAppear(){
    }
    
    func viewWillDisappear(){
    
    }
    
    func viewDidDisappear(){
    
    }
    
    
}



//MARK: InfinitePageView
class InfinitePageView : UIView,UIScrollViewDelegate {
    
    var pageView: UIScrollView! = UIScrollView(frame: CGRectZero)
    
    var onScreenCells : NSMutableArray! = []
    var onsScreenTags : NSMutableArray! = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews(){
        
        //init pageview
        pageView.frame = self.bounds
        pageView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        pageView.delegate = self
        pageView.backgroundColor = UIColor.clearColor()
        pageView.clipsToBounds = true
        pageView.pagingEnabled = true
        pageView.scrollEnabled = true
        pageView.showsVerticalScrollIndicator = false
        pageView.showsHorizontalScrollIndicator = true
        self.addSubview(pageView)
        
        
    
    }
    
    
    
}