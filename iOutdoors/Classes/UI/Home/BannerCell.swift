//
//  BannerCell.swift
//  iOutdoors
//
//  Created by Kyle on 15/8/10.
//  Copyright (c) 2015年 xiaoluuu. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class BannerCell : InfinitPageViewCell {
    
    var imageView : UIImageView!
    
    override init(frame: CGRect, identifier: String) {
        super.init(frame: frame, identifier: identifier)
        
        imageView = UIImageView(frame: self.bounds)
        self.addSubview(imageView)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
