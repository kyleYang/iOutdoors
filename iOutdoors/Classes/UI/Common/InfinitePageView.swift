//
//  InfinitePageView.swift
//  iOutdoors
//
//  Created by Kyle on 15/8/7.
//  Copyright (c) 2015年 xiaoluuu. All rights reserved.
//

import Foundation
import UIKit


private let pageControlHeight : CGFloat = 20.0 // pagecontroller height
private let timeInterval : NSTimeInterval = 5


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
    
    var delegate: InfinitPageViewDelegate?
    
    private(set) var pageView: UIScrollView! = UIScrollView(frame: CGRectZero)
    private var pageControl : KYPageController!
    
    private var onScreenCells : Array<InfinitPageViewCell>! = Array()
    private var onScreenTags : Array<NSInteger>! = Array()
    private var saveCells : Dictionary<NSString,Array<InfinitPageViewCell>>! = [:]
    
   
    
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
            self.pageView.contentOffset = CGPointMake(0, 0)
            self.pageView.contentSize = CGSizeMake(CGRectGetWidth(self.pageView.frame)*2, CGRectGetHeight(self.pageView.frame))
        }else{
            self.pageView.contentOffset = CGPointMake(CGRectGetWidth(self.pageView.frame), 0)
            self.pageView.contentSize = CGSizeMake(CGRectGetWidth(self.pageView.frame)*3, CGRectGetHeight(self.pageView.frame))
        }
        
        self.loadViews()
        self.resumeTimer()
        
    }
    
    func dequeueCellWithIdentifier(identifier:NSString) ->InfinitPageViewCell?{
        
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
        
        var identifier : NSString = cell.identifier;
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
        
        pageControl = KYPageController(frame: CGRectMake(0, CGRectGetHeight(pageControl.frame)-pageControlHeight, CGRectGetWidth(pageControl.frame), pageControlHeight))
        pageControl.normalImage = UIImage(named: "recom_off")
        pageControl.hilightImage = UIImage(named: "recom_on")
        pageControl.dotWidth = 8
        self.addSubview(pageControl)
    
    }
    
    private func loadViews(){
        
        
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
        
        self.pageView.setContentOffset(CGPointMake(CGRectGetWidth(self.pageView.frame)*2, 0), animated: true)
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
    
    private func getDisplayImagesWith(Page page:NSInteger) -> Array<NSInteger>{
        
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
        
        
    }
    
    
//    - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    
//    //    BqsLog(@"MptContentScrollView current index : %d",_curPage);
//    self.pageControl.currentPage = _curPage;
//    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
//    
//    if (_dataSource && [_dataSource respondsToSelector:@selector(recommenView:curIndex:)]) {
//    [_dataSource recommenView:self curIndex:_curPage];
//    }
//    [self resumeTimer];
//    
//    
//    }
//    
//    
//    - (void)handleTap:(UITapGestureRecognizer *)tap {
//    DDLogVerbose(@"handleTap curpage :%lu", _curPage);
//    if ([_delegate respondsToSelector:@selector(recommenView:didSelectIndex:)]) {
//    [_delegate recommenView:self didSelectIndex:_curPage];
//    }
//    }
//
    



}