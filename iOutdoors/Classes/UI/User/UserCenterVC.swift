//
//  UserCenterVC.swift
//  iOutdoors
//
//  Created by Kyle on 15/8/6.
//  Copyright (c) 2015年 xiaoluuu. All rights reserved.
//

import Foundation
import UIKit

private let headViewHeight : CGFloat = 150.0
private let identifier : String = "usercenter"

class UserCenterVC : ODGroupTableVC {
    
    var userHeadView : UserCenterHeadView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        userHeadView = UserCenterHeadView(frame: CGRectMake(0.0,0.0,self.view.width(),headViewHeight))
        self.tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0) //should set, otherwise, the headview will be hidden by the navigationbar
        self.tableView.setParallaxHeaderView(userHeadView, mode: KYParallaxHeaderMode.ModeTop, height: headViewHeight)
        
        userHeadView.setImage("http://img4.duitang.com/uploads/item/201407/16/20140716155513_W5Ydc.thumb.700_0.jpeg")
        
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 10
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell?  = tableView.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell
        if let temp = cell {
            
        }else {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        cell?.textLabel?.text = "section = \(indexPath.section) and row = \(indexPath.row)"
        return cell!
    }
    
    
}
