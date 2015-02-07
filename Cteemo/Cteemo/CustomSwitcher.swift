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
    
    var chosenBox = 0

    
    func setup(choices:[String], frame: CGRect, colorSelected: UIColor, colorDefault:UIColor){
        self.backgroundColor = UIColor.blackColor()
        defaultColor = colorDefault
        chosenColor = colorSelected
        
        selections = choices
        
        buttons = [UIButton]()
        text = [UILabel]()
        
        for var index = 0; index < selections.count; index++ {
            
            var width: CGFloat = (self.frame.width - 4) / CGFloat(selections.count)
            var height: CGFloat = (self.frame.height - 4) / CGFloat(selections.count)
            
            var but = UIButton(frame: CGRectMake(2 + width * CGFloat(index), 2, width, height))
            but.backgroundColor = defaultColor
            but.addTarget(self, action: "chosen:", forControlEvents: UIControlEvents.TouchUpInside)
            buttons.append(but)
            self.addSubview(but)
            
            var label = UILabel(frame: CGRectMake(2 + width * CGFloat(index), 2, width, height))
            label.backgroundColor = UIColor.clearColor()
            label.textColor = chosenColor
            label.text = selections[index]
            label.font = UIFont(name: "AvenirNext-Medium", size: 22)
            label.textAlignment = NSTextAlignment.Center
            self.addSubview(label)
            text.append(label)
            
        }
        buttons[0].backgroundColor = chosenColor
        text[0].backgroundColor = defaultColor
    }
    
    func chosen(sender: UIButton){
        
        
        buttons[chosenBox].backgroundColor = defaultColor
        text[chosenBox].backgroundColor = chosenColor
        
        chosenBox = Int(find(buttons, sender)!)
        
        print(chosenBox)

        buttons[chosenBox].backgroundColor = chosenColor
        text[chosenBox].backgroundColor = defaultColor
    }

}
