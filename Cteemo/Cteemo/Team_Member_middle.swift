//
//  Team_Member_middle.swift
//  Cteemo
//
//  Created by bintao on 15/4/24.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import Foundation


class Team_Member_middle: UITableViewCell {
    
    
    
    @IBOutlet weak var games: UILabel!
    
    @IBOutlet weak var Kills: UILabel!
    
    
    @IBOutlet weak var TripleKills: UILabel!
    
    @IBOutlet weak var QuadraKills: UILabel!
    
    @IBOutlet weak var PentaKills: UILabel!
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setCell(games :String, kda: String,killspergame:String, goldpergame :String,PentaKills : String) {
       
        self.games.text = games
        self.Kills.text = kda
        self.TripleKills.text = killspergame
        self.QuadraKills.text = goldpergame
        self.PentaKills.text = PentaKills
        
    }
    
    
    
    
}
