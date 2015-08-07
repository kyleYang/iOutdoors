//
//  ODGroupTableVC.swift
//  iOutdoors
//
//  Created by Kyle on 15/8/6.
//  Copyright (c) 2015年 xiaoluuu. All rights reserved.
//

import Foundation
import UIKit


class ODGroupTableVC : ODBaseViewController,UITableViewDelegate,UITableViewDataSource{
    
    var tableView : UITableView! = UITableView(frame: CGRectZero, style: .Grouped)
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        

        super.init(nibName: nibNameOrNil,bundle: nibBundleOrNil)
    
    }
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // init group tableview
        tableView.frame = self.view.bounds
        tableView.frame = self.view.bounds
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.autoresizingMask = UIViewAutoresizing.FlexibleWidth|UIViewAutoresizing.FlexibleHeight
        tableView.separatorColor = UIColor.clearColor()
        tableView.scrollsToTop = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.allowsSelectionDuringEditing = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        
        
        
        
        

    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: -----------------------------------------
    // MARK: UITableViewDelegate UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell();
    }
    
    
    
}

