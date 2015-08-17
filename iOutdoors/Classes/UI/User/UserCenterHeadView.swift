//
//  UserCenterHeadView.swift
//  iOutdoors
//
//  Created by Kyle on 15/8/16.
//  Copyright (c) 2015年 xiaoluuu. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class UserCenterHeadView : UIView {
    
    var backgroundImage : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.redColor()
        
        backgroundImage = UIImageView(frame: frame)
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundImage.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.addSubview(backgroundImage)

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setImage(url : String){
        
        if url.isEmpty {
            backgroundImage.image = UIImage(named: "user_center_head_placehold")
            return
        }
        
        let options = SDWebImageOptions.RefreshCached
        backgroundImage.sd_setImageWithURL(NSURL(string: url), placeholderImage:UIImage(named: "user_center_head_placehold"), options: options)
    }
    
}