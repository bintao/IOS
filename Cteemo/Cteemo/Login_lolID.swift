//
//  Login_lolID.swift
//  Cteemo
//
//  Created by bintao on 15/2/8.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

class Login_lolID: UIViewController, UIScrollViewDelegate,RequestResultDelegate{


    @IBOutlet weak var lol_icon: UIImageView!

    @IBOutlet weak var lolname: UILabel!


    @IBOutlet weak var lol_rank: UILabel!


    @IBOutlet weak var lol_level: UILabel!
    
    var clolname :String = ""
    var name :String = ""
    var school :String = ""
    var gender :String = ""
    
    override func viewDidLoad() {
       
        
        if(LolAPIGlobal.lolLevel != "" && LolAPIGlobal.lolID != "" ){
            
            self.lolname.text = LolAPIGlobal.lolName
            self.lol_level.text = "Level:" + LolAPIGlobal.lolLevel
            if LolAPIGlobal.lolRank !=  ""{
            self.lol_rank.text = LolAPIGlobal.lolRank
            }
            else {
            self.lol_rank.text = "Play more rank ~ ~ "
            }
            
            ImageLoader.sharedLoader.imageForUrl(LolAPIGlobal.lolIcon, completionHandler:{(image: UIImage?, url: String) in
                println(url)
                if image? != nil {
                    self.lol_icon.image = image?.roundCornersToCircle()
                }
                else {
                    self.lol_icon.image = UIImage(named: "error.png")!
                }})
            
            
        }

        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        
    }

    @IBAction func start(sender: UIButton) {
        
        println(self.gender)
        
        
        var par = ["username": self.name,"school": self.school ,"lolID": self.clolname ,"intro" : self.gender,"dotaID": LolAPIGlobal.lolRank, "hstoneID": LolAPIGlobal.lolID]
        
        var req = ARequest(prefix: "profile", method: requestType.POST, parameters: par)
        req.delegate = self
        req.sendRequestWithToken(UserInfoGlobal.accessToken)
        
        
        self.performSegueWithIdentifier("lollogin", sender: self)
      
        
    }
    
      func gotResult(prefix: String, result: AnyObject) {
        
        if prefix == "profile"{
            
            println(result)
            
            LolAPIGlobal.lolName = self.clolname
            
            UserInfoGlobal.gender = self.gender
            
            UserInfoGlobal.school = self.school
            
            UserInfoGlobal.name = self.name
            
            UserInfoGlobal.saveUserData()
            
            var req1 = ARequest(prefix: "upload_profile_icon", method: requestType.POST)
            req1.delegate = self
            req1.uploadPhoto("icon.png")
            
        }
        
        
    }
    
    
    
    @IBAction func changeinfo(sender: AnyObject) {
        
        LolAPIGlobal.cleanUserData()
        self.performSegueWithIdentifier("returnToSchool", sender: self)
        
    }
    
    @IBAction func gotololid(segue : UIStoryboardSegue) {
        
    }



}