//
//  groupchat.swift
//  Cteemo
//
//  Created by bintao on 15/3/19.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import Foundation
import UIKit

class groupChatView: RCChatViewController {
    
    
    override init() {
        super.init()
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.barTintColor = UserInfoGlobal.UIColorFromRGB(0xE74C3C)
        
    }
    
    
    
}