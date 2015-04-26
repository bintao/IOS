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
    
    @IBOutlet weak var school: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setCell( name: String,school :String,icon:  UIImage!) {
        
        self.name.text = name
        self.school.text = school
        self.icon.image = icon
        
        
    }
    
}
