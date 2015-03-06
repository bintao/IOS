//
//  tournamentViewCell.swift
//  Cteemo
//
//  Created by bintao on 15/3/5.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import Foundation


class tournamentViewCell: UITableViewCell {
    
    
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var rewards: UILabel!
    
    @IBOutlet weak var JoinedFree: UIButton!
    
    @IBOutlet weak var time: UITextView!
    
    @IBOutlet weak var maxteams: UILabel!

    @IBOutlet weak var joinedteam: UILabel!
    
    @IBOutlet weak var tournamentRule: UITextView!
    
    @IBOutlet weak var gameicon: UIImageView!
    
    
    func setCell(gameName : String,name :String,rule:String,time:String,joined:Int,maxteam:Int) {
    
        self.name.text = name
        self.time.text = time
        self.maxteams.text = "\(maxteam)"
        self.joinedteam.text = "\(joined)"
        self.tournamentRule.text = rule
        
        if gameName == "Dota 2"{
           self.gameicon.image = UIImage(named: "Dota2.png")!
        }
        else if gameName == "League of Legends"{
            self.gameicon.image = UIImage(named: "lol.png")!
        }
        else if gameName == "Hearthstone: Heroes of Warcraft"{
            self.gameicon.image = UIImage(named: "hearthstone.png")!
        }
        
    
    }
    
}