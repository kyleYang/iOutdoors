//
//  InfinitescrollView.swift
//  iOutdoors
//
//  Created by Kyle on 15/8/7.
//  Copyright (c) 2015年 xiaoluuu. All rights reserved.
//

import Foundation
import UIKit


private let pageControlHeight : CGFloat = 20.0 // pagecontroller height
private let timeInterval : NSTimeInterval = 5
private let defualtIdentifier : String = "defaultidentifier"


//MARK: InfinitscrollViewDelegate
@objc protocol InfinitPageViewDelegate : NSObjectProtocol {
    
    func numberOfCellInInfinitPageView(scrollView: InfinitePageView) -> Int
    func infinitPageView(scrollView: InfinitePageView,frame:CGRect ,cellForRowAtIndex index: Int) -> InfinitPageViewCell
    
    optional func infinitPageView(scrollView: InfinitePageView, didTapIndex index:Int)
    optional func infinitPageView(scrollView: InfinitePageView, currentIndex index:Int)
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
    
    var delegate: InfinitPageViewDelegate?
    
    private(set) var scrollView: UIScrollView! = UIScrollView(frame: CGRectZero)
    private var pageControl : KYPageController!
    
    private var onScreenCells : Array<InfinitPageViewCell>! = Array()
    private var onScreenTags : Array<NSInteger>! = Array()
    private var saveCells : Dictionary<String,Array<InfinitPageViewCell>>! = [:]
    
   
    
    private var lastPage : NSInteger! = 0
    var currentPage : NSInteger! = 0
    private var total : NSInteger! = 0
    
    private var timer : NSTimer?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: public method
    
    func reloadData(){
        
        self.cancelTimer()
        self.resumeTimer()
        
        for cell in self.onScreenCells{
            
            cell.viewWillDisappear()
            cell.removeFromSuperview()
            cell.viewDidDisappear()
            
            self.queueContentCell(cell)
            
        }
        self.onScreenCells.removeAll(keepCapacity: true)
        
        total = 0
        currentPage = 0
        
        total =  delegate?.numberOfCellInInfinitPageView(self)
        
        pageControl.pageNumber = total
        pageControl.current = currentPage
        
        
        if total==0 {
            return
        }else if total==1{
            self.scrollView.contentOffset = CGPointMake(0, 0)
            self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame)*2, CGRectGetHeight(self.scrollView.frame))
            self.loadSingleView()
            
        }else{
            self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0)
            self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame)*3, CGRectGetHeight(self.scrollView.frame))
            self.loadViews()
        }
        
        self.resumeTimer()
        
    }
    
    func dequeueCellWithIdentifier(identifier:String) ->InfinitPageViewCell?{
        
        if !self.saveCells.isEmpty {
            var array : Array<InfinitPageViewCell> = self.saveCells[identifier]!
            if array.isEmpty {
                var cell : InfinitPageViewCell = array.last!
                array.removeLast()
                return cell
            }
        }
        return nil

    }
    
    
    func queueContentCell(cell : InfinitPageViewCell){
        
        var identifier : String = cell.identifier;
        var array : Array<InfinitPageViewCell> = self.saveCells[identifier]!
        if !array.isEmpty {
            array.append(cell)
        }else{
            array = []
            array.append(cell)
            self.saveCells[identifier] = array
            
        }
        
    }
    
    
    private func setupViews(){
        
        //init scrollView
        scrollView.frame = self.bounds
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.clipsToBounds = true
        scrollView.pagingEnabled = true
        scrollView.scrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = true
        self.addSubview(scrollView)
        
        pageControl = KYPageController(frame: CGRectMake(0, CGRectGetHeight(pageControl.frame)-pageControlHeight, CGRectGetWidth(pageControl.frame), pageControlHeight))
        pageControl.normalImage = UIImage(named: "recom_off")
        pageControl.hilightImage = UIImage(named: "recom_on")
        pageControl.dotWidth = 8
        self.addSubview(pageControl)
    
    }
    
    //The total pages == 1
    private func loadSingleView(){
        
        var frame = CGRectMake(0,0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        
        var cell : InfinitPageViewCell? = delegate?.infinitPageView(self, frame: frame, cellForRowAtIndex: 0)
        if cell == nil{
            cell = InfinitPageViewCell(frame: frame, identifier: defualtIdentifier)
        }
        cell?.frame = frame
        cell?.tag = 0
        
        
        if let gestures = cell?.gestureRecognizers{
            for gesture in gestures{
                cell?.removeGestureRecognizer(gesture as! UIGestureRecognizer)
            }
        }
        
        var singleTap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        cell?.addGestureRecognizer(singleTap)
            
        cell?.viewWillAppear()
        self.scrollView.addSubview(cell!)
        cell?.viewDidAppear()

        self.onScreenCells.append(cell!)

        
    }
    
    private func loadViews(){
        
        self.getDisplayImagesWithPage(currentPage)//移掉划出屏幕外的图片 保存3个
        
    
        var readyRemove : Array<InfinitPageViewCell>! = Array()
        
    
        for cell in self.onScreenCells{
            
            var onScreen:Bool = false
            
            for subtag in self.onScreenTags{
                if subtag == cell.cellTag {
                    onScreen = true
                    break
                }

            }
            
            if !onScreen {
                readyRemove.append(cell)
            }
            
        }
        
    
        for cell in readyRemove {
            
            self.queueContentCell(cell)
            cell.viewWillDisappear()
            self.onScreenCells.removeObject(cell)
            cell.viewWillDisappear()
            
        }
        
    

        //遍历图片数组
        for i in self.onScreenTags{
            
            var onscreen : Bool = true
            var onTag = self.onScreenTags[i]
            
            if onscreen {
                
                var hasOneScreen : Bool = false
                for vi in self.onScreenCells {
                    
                    if onTag == vi.cellTag {
                        
                        hasOneScreen = true
                        vi.setX(CGRectGetWidth(self.scrollView.frame)*CGFloat(i))
                    }
                }
                
                if !hasOneScreen {
                    
                    var frame: CGRect = CGRectMake(CGRectGetWidth(self.scrollView.frame)*CGFloat(i),0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
                    var cell : InfinitPageViewCell?
                    if total==2{
                        if onTag == -1{
                            cell = delegate?.infinitPageView(self, frame: frame, cellForRowAtIndex: 1)
                        }else if onTag == 2{
                            cell = delegate?.infinitPageView(self, frame: frame, cellForRowAtIndex: 0)
                        }else{
                            cell = delegate?.infinitPageView(self, frame: frame, cellForRowAtIndex: onTag)
                        }
                    }else{
                        cell = delegate?.infinitPageView(self, frame: frame, cellForRowAtIndex: onTag)
                    }
                    
                    if cell == nil{
                        cell = InfinitPageViewCell(frame: frame, identifier: defualtIdentifier)
                    }
                    
                    cell?.frame = frame
                    cell?.cellTag = onTag
                    
                    
                    if let gestures = cell?.gestureRecognizers{
                        for gesture in gestures{
                            cell?.removeGestureRecognizer(gesture as! UIGestureRecognizer)
                        }
                    }
                    
                    var singleTap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
                    cell?.addGestureRecognizer(singleTap)
                    
                    cell?.viewWillAppear()
                    self.scrollView.addSubview(cell!)
                    cell?.viewDidAppear()
                    
                    self.onScreenCells.append(cell!)

                }
                
            }
            
        }
        
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0)
        
    }
    
    
    
    private func cancelTimer(){
        
        if (self.timer == nil) {
            return;
        }
        
        NSRunLoop.mainRunLoop().cancelPerformSelector(Selector("doAutoLoop"), target: self, argument: nil)
        self.timer?.invalidate()
        self.timer = nil
    }
    
    private func resumeTimer(){
        
        if total<2 {
            return
        }
        if self.timer == nil{
            return
        }
        self.timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: Selector("doAutoLoop"), userInfo: nil, repeats: true)
        var runloop : NSRunLoop = NSRunLoop.mainRunLoop()
        runloop.addTimer(self.timer!, forMode:NSDefaultRunLoopMode);
    }

    
    @objc private func doAutoLoop(){
        
        self.scrollView.setContentOffset(CGPointMake(CGRectGetWidth(self.scrollView.frame)*2, 0), animated: true)
    }
    
    
    
    private func validCurrPageValue(value : NSInteger) ->NSInteger
    {
        if value <= -1 {
            return total - 1
        }else if value >= total{
            return 0
        }
        return value
        
    }
    
    private func validPageValue(value: NSInteger) ->NSInteger{
        
        var valueNew : NSInteger! = 0
        
        if value == -1 {
            if total == 2 {
                valueNew = -1
            }else {
                valueNew = total - 1
            }
        }else if value < -1 { // value＝0为第一张，value = -1为前面一张
            
            valueNew = total - 1;
            
        }else if value == total {
            if total == 2 {
                valueNew = 2;
            }else{
                valueNew = 0;
            }
        }else if value > total{
            valueNew = 0;
        }
        
        return valueNew;
    }
    
    private func getDisplayImagesWithPage(page:NSInteger) -> Array<NSInteger>{
        
        var pre = self.validCurrPageValue(page-1)
        var last = self.validCurrPageValue(page+1)
        
        if self.onScreenTags.count != 0{
            self.onScreenTags.removeAll(keepCapacity: true)
        }
    
        self.onScreenTags.append(pre)
        self.onScreenTags.append(page)
        self.onScreenTags.append(last)
        return self.onScreenTags

    }
    
   
    
    
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        
        if x >= 2*CGRectGetWidth(scrollView.frame){
            currentPage = self.validCurrPageValue(currentPage+1)
            self.loadViews()
        }else if(x <= 0) {
            currentPage = self.validCurrPageValue(currentPage-1);
            self.loadViews();
        }
        self.pageControl.current = currentPage;
    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.cancelTimer()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        self.pageControl.current = currentPage
        scrollView.setContentOffset(CGPointMake(CGRectGetWidth(scrollView.frame), 0), animated: true)
        
        delegate?.infinitPageView?(self, currentIndex: currentPage)
        
        self.resumeTimer()
        
    }
    
    
    //MARK: hand tap gesture
    
    private func handleTap(gestureRecognizer : UIGestureRecognizer){
        
        delegate?.infinitPageView?(self, didTapIndex: currentPage)
    }



}