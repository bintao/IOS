//
//  Team_Member_Top.swift
//  Cteemo
//
//  Created by bintao on 15/4/22.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import Foundation


class Team_Member_Top: UITableViewCell {
    
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var winRate: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet var rank: UIImageView!
    
    @IBOutlet var level: UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setCell( name: String,win :String,icon:  UIImage!, rank : String) {
        
        self.name.text = name
        self.winRate.text = win
        self.icon.image = icon
        
        
        if rank != ""{
        
         self.level.text = "LV.30"
        
        }else{
            self.level.text = "Not 30"
        
        }//check level
        
        if UIImage(named: rank + ".png") != nil {
            
            self.rank.image = UIImage(named: rank + ".png")
            
        }

        
    }
    
}
