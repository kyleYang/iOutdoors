//
//  UIHelper.swift
//  iOutdoors
//
//  Created by Kyle on 15/8/6.
//  Copyright (c) 2015年 xiaoluuu. All rights reserved.
//

import Foundation
import RDVTabBarController

class UIHelper : NSObject {
    
    
    static func tabbarController(Index index: Int) -> TabBarController{
     
        var tabBarController : TabBarController = TabBarController()
        
        var homeVC : HomeVC = HomeVC(nibName: nil, bundle: nil)
        var userVC : UserCenterVC = UserCenterVC(nibName: nil, bundle: nil)
        
        tabBarController.viewControllers = [homeVC,userVC]
        
        var tabBarItemImages = ["cate_home","cate_user"]
        var tabBarHightImages = ["cate_home_hilight","cate_user_hilight"]
        
        
        for var i = 0; i<tabBarController.tabBar.items.count; i++ {
            
            var item: RDVTabBarItem = tabBarController.tabBar.items[i] as! RDVTabBarItem
            item.backgroundColor = UIColor.clearColor()
            item.badgeBackgroundColor = nil;
            item.badgeTextFont = UIFont.systemFontOfSize(2.0)
            item.badgePositionAdjustment = UIOffsetMake(2, 4);
            
            var selectedimage : UIImage = UIImage(named: tabBarHightImages[i])!
            var unselectedimage : UIImage = UIImage(named: tabBarItemImages[i])!
            
            item.setFinishedSelectedImage(selectedimage, withFinishedUnselectedImage: unselectedimage)
            item.unselectedTitleAttributes = [NSFontAttributeName:UIFont.systemFontOfSize(10)]
            item.selectedTitleAttributes = [NSFontAttributeName:UIFont.boldSystemFontOfSize(10)]
            

    
            
        }
        
        

        return tabBarController
        
    }
    
    
    
}

