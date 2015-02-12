//
//  Login_lolID.swift
//  Cteemo
//
//  Created by bintao on 15/2/8.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

class Login_lolID: UIViewController, UIScrollViewDelegate{


    @IBOutlet weak var lol_icon: UIImageView!

    @IBOutlet weak var lolname: UILabel!


    @IBOutlet weak var lol_rank: UILabel!


    @IBOutlet weak var lol_level: UILabel!

    override func viewDidLoad() {
        //add tap gesture to board
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
  
        if(LolAPIGlobal.lolLevel != 0 && LolAPIGlobal.lolRank != "" ){
        self.lolname.text = LolAPIGlobal.lolName
        self.lol_level.text = "Summoner's Level" + String(LolAPIGlobal.lolLevel)
        self.lol_rank.text = LolAPIGlobal.lolRank
        
        }
    }

    @IBAction func gotololid(segue : UIStoryboardSegue) {
        
    }



}