//
//  HomeVC.swift
//  iOutdoors
//
//  Created by Kyle on 15/8/6.
//  Copyright (c) 2015年 xiaoluuu. All rights reserved.
//

import Foundation
import UIKit


private let tableHedViewHeight : CGFloat = 120
private let bannerIdentifier : String = "bannercell"

class HomeVC : ODGroupTableVC,InfinitPageViewDelegate {
    
//    "tabbar.home" = "首页";
//    "tabbar.user" = "我";
    
    var tableHeadView : InfinitePageView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil,bundle: nibBundleOrNil)
        self.navigationController?.title = NSLocalizedString("tabbar.home",comment:"")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        tableHeadView = InfinitePageView(frame: CGRectMake(0,0,tableView.width(),tableHedViewHeight))
        tableHeadView.delegate = self
        tableView.tableHeaderView = tableHeadView
        
    }
    
    
    //MARK: InfinitPageViewDelegate
    func numberOfCellInInfinitPageView(scrollView: InfinitePageView) -> Int {
        return 2
    }
    
    func infinitPageView(scrollView: InfinitePageView, frame: CGRect, cellForRowAtIndex index: Int) -> InfinitPageViewCell {
        
        var cell : BannerCell? = scrollView.dequeueCellWithIdentifier(bannerIdentifier) as? BannerCell
        if cell==nil{
            cell = BannerCell(frame: frame, identifier: bannerIdentifier)
        }
        
        if index==0{
            cell?.imageView.sd_setImageWithURL(NSURL(string: "http://img4.duitang.com/uploads/item/201407/16/20140716155513_W5Ydc.thumb.700_0.jpeg"))
        }else if index==1{
            cell?.imageView.sd_setImageWithURL(NSURL(string: "http://cdn.duitang.com/uploads/item/201410/18/20141018085151_inMaN.thumb.700_0.png"))
        }else if index==2{
            cell?.imageView.sd_setImageWithURL(NSURL(string: "http://img4.duitang.com/uploads/item/201410/25/20141025175959_va8hy.thumb.700_0.jpeg"))
        }else if index==3{
            cell?.imageView.sd_setImageWithURL(NSURL(string: "http://cdn.duitang.com/uploads/item/201407/08/20140708213424_zHzsj.thumb.700_0.jpeg"))
        }else if index==4{
            cell?.imageView.sd_setImageWithURL(NSURL(string: "http://cdn.duitang.com/uploads/item/201407/09/20140709154655_hWXmZ.thumb.700_0.jpeg"))
        }
        
        return cell!
    }
    
    
}