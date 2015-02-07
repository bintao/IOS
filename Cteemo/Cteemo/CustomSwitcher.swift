//
//  CustomSwitcher.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/6.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

class CustomSwitcher: UIView {
    
    var defaultColor = UIColor.whiteColor()
    var chosenColor = UIColor.clearColor()
    
    var selections:[String]!
    
    var buttons:[UIButton]!
    var text:[UILabel]!

    init(choices:[String], frame: CGRect, colorSelected: UIColor, colorDefault:UIColor) {
        super.init(frame: frame)
        
        defaultColor = colorDefault
        chosenColor = colorSelected
        
        selections = choices
        
        buttons = [UIButton]()
        text = [UILabel]()

        for var index = 0; index < selections.count; index++ {

            var width: CGFloat = (self.frame.width - 4) / CGFloat(selections.count)
            var height: CGFloat = (self.frame.height - 4) / CGFloat(selections.count)

            var but = UIButton(frame: CGRectMake(2 + width * CGFloat(index), 2, width, height))
            but.backgroundColor = UIColor.clearColor()
            but.addTarget(self, action: "chosen:", forControlEvents: UIControlEvents.TouchUpInside)
            buttons.append(but)
            self.addSubview(but)
            
            var text = UILabel(frame: CGRectMake(2 + width * CGFloat(index), 2, width, height))
            text.backgroundColor = UIColor.clearColor()
            text.textColor = chosenColor
            text.font = UIFont(name: "AvenirNext-Medium", size: 18)
            text.textAlignment = NSTextAlignment.Center
            self.addSubview(text)
            
        }
        
    }

    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
