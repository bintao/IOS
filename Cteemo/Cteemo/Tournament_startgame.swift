//
//  Tournament_startgame.swift
//  Cteemo
//
//  Created by bintao on 15/3/31.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

class matchmember {
    
    var name = String()
    var heropick = Int()
    var summonerId = Int()
     var iconid = Int()
    
    
}

class Tournament_startgame: UIViewController {


    @IBOutlet var myteam: UIScrollView!
    @IBOutlet var opponent: UIScrollView!
    
    var win: Bool!
    
    var gametype = ""
    var gameStartTime = 0
    

    var blueteammember :[matchmember] = []
    var redmember :[matchmember] = []
    
    override func viewDidLoad() {
        
           
    
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let subviews = self.myteam.subviews
        
        for subview in subviews{
            subview.removeFromSuperview()
        }
       
        if blueteammember.count != 0 {
        
        self.myteam.contentSize = CGSizeMake(75 * CGFloat(blueteammember.count), 75)
        for var index = 0; index < blueteammember.count; index++ {
            
            var hero = "\(blueteammember[index].heropick)" + ".png"
            
            var but = UIButton(frame: CGRectMake(5 + 75 * CGFloat(index), 10, 65, 65))
            
            but.setImage(UIImage(named: hero)!, forState: UIControlState.Normal)
            
            myteam.addSubview(but)
            
            var lab = UILabel(frame: CGRectMake(75 * CGFloat(index), 75, 75, 20))
            lab.textAlignment = NSTextAlignment.Center
            
            lab.text = blueteammember[index].name
            myteam.addSubview(lab)
            
        }
            
            if redmember.count != 0 {
            
                self.opponent.contentSize = CGSizeMake(75 * CGFloat(redmember.count), 75)
                for var index = 0; index < redmember.count; index++ {
                    
                    var hero = "\(redmember[index].heropick)" + ".png"
                    
                    var but = UIButton(frame: CGRectMake(5 + 75 * CGFloat(index), 10, 65, 65))
                    
                    but.setImage(UIImage(named: hero)!, forState: UIControlState.Normal)
                    
                    opponent.addSubview(but)
                    
                    var lab = UILabel(frame: CGRectMake(75 * CGFloat(index), 75, 75, 20))
                    lab.textAlignment = NSTextAlignment.Center
                    
                    lab.text = redmember[index].name
                    opponent.addSubview(lab)
                }
            
            }
            
            
            
        }
    }
    

    func finishgame(){
    
        let url = "https://na.api.pvp.net/api/lol/na/v1.3/game/by-summoner/25350780/recent?api_key="+LolAPIGlobal.key
        println(url)
        Alamofire.request(.GET,url)
            .responseJSON { (_, _, JSON, _) in
                
                if JSON != nil{
                    let myjson = SwiftyJSON.JSON(JSON!)
                    var match = myjson["games"][1]
                    println(match)
                    
                    if let win = myjson["games"][0]["stats"]["win"].bool
                    {
                        self.win = win
                        println(self.win)
                    }
                    
                    if let myteamid = myjson["games"][0]["stats"]["team"].int{
                        
                      
                        println(myteamid)
                        
                    }
                    
                    if let gameType = myjson["games"][0]["gameType"].string{
                        
                        self.gametype = gameType
                        println(self.gametype)
                        
                    }
                    
                    
                }
        }
    
    
    }
    
    
    
    
    

}