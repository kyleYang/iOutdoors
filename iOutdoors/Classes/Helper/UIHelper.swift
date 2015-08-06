//
//  UIHelper.swift
//  iOutdoors
//
//  Created by Kyle on 15/8/6.
//  Copyright (c) 2015年 xiaoluuu. All rights reserved.
//

import Foundation

class UIHelper : NSObject {
    
    
    static func tabbarController(Index index: Int) -> TabBarController{
     
        var tabBarController : TabBarController = TabBarController()
        
        var homeVC : HomeVC = HomeVC(nibName: nil, bundle: nil)
        var userVC : UserCenterVC = UserCenterVC(nibName: nil, bundle: nil);
        
        tabBarController.viewControllers = [homeVC,userVC]
        return tabBarController
        
    }
    
    
    
}

