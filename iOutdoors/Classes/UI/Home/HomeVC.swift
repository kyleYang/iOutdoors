//
//  HomeVC.swift
//  iOutdoors
//
//  Created by Kyle on 15/8/6.
//  Copyright (c) 2015年 xiaoluuu. All rights reserved.
//

import Foundation


class HomeVC : ODGroupTableVC {
    
//    "tabbar.home" = "首页";
//    "tabbar.user" = "我";

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil,bundle: nibBundleOrNil)
        self.navigationController?.title = NSLocalizedString("tabbar.home",comment:"")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        
    }
    
}