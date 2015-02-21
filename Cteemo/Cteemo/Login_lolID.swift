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
        
        if(LolAPIGlobal.lolLevel != "" && LolAPIGlobal.lolID != "" ){
            
            self.lolname.text = LolAPIGlobal.lolName
            self.lol_level.text = "Level:" + LolAPIGlobal.lolLevel
            if LolAPIGlobal.lolRank !=  ""{
            self.lol_rank.text = LolAPIGlobal.lolRank
            }
            else {
            self.lol_rank.text = "Play more rank ~ ~ "
            }
            lol_icon.image = LolAPIGlobal.getlolIcon(LolAPIGlobal.lolpatch, id: LolAPIGlobal.lolIcon)
            
        }

        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
          }

    @IBAction func start(sender: UIButton) {
        
        self.performSegueWithIdentifier("lollogin", sender: self)
      
        
    }
    
    @IBAction func changeinfo(sender: AnyObject) {
        
        LolAPIGlobal.cleanUserData()
        self.performSegueWithIdentifier("returnToSchool", sender: self)
        
    }
    
    @IBAction func gotololid(segue : UIStoryboardSegue) {
        
    }



}