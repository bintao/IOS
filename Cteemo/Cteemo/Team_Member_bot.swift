//
//  Team_Member_bot.swift
//  Cteemo
//
//  Created by bintao on 15/4/24.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import Foundation


class Team_Member_bot: UITableViewCell {
    
    @IBOutlet weak var game: UILabel!
    
    @IBOutlet weak var win: UILabel!
    
    @IBOutlet weak var kda: UILabel!
    
    @IBOutlet var icon: UIImageView!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setCell( game: String , win :String , kda :String , icon : String ) {
      
        self.game.text = game
        
        self.win.text = win
        
        self.kda.text = kda
        
        if icon != ""
        {
        
        self.icon.image = UIImage(named: icon + ".png")!
            
        }
        
    }
    
}
