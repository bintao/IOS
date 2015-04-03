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
        
        let url = "https://na.api.pvp.net/observer-mode/rest/consumer/getSpectatorGameInfo/NA1/25350780?api_key="+LolAPIGlobal.key
        
        Alamofire.request(.GET,url)
            .responseJSON { (_, _, JSON, error) in
                
                if JSON != nil{
                    let myjson = SwiftyJSON.JSON(JSON!)
                    
                    
                    if let gameStartTime = myjson["gameStartTime"].int
                    {
                        self.gameStartTime = gameStartTime
                        
                    }
                    
                    if let gameType = myjson["gameType"].string
                    {
                        println(gameType)
                    }
                    
                    if let gameId = myjson["gameId"].int
                    {
                        println(gameId)
                    }
                    
                    if myjson["participants"] != nil{
                        
                        
                        var size = myjson["participants"].count
                        println(size)
                        
                        if size > 0 {
                            
                            for i in 0...size - 1
                            {
                                var teamid = 0
                                if let teamid = myjson["participants"][i]["teamId"].int{
                                    
                                    var member = matchmember()
                                    
                                    if let summonerName = myjson["participants"][i]["summonerName"].string
                                    {
                                        member.name = summonerName
                                    }
                                    
                                    if let championId = myjson["participants"][i]["championId"].int
                                    {
                                        member.heropick = championId
                                    }
                                    
                                    if let summonerId = myjson["participants"][i]["summonerId"].int
                                    {
                                        member.summonerId = summonerId
                                    }
                                    if let iconid = myjson["participants"][i]["profileIconId"].int
                                    {
                                        member.iconid = iconid
                                    }
                                    
                                    if teamid == 100{
                                        
                                        self.blueteammember.append(member)
                                    }else{
                                        self.redmember.append(member)
                                    
                                    }
                                
                                }//teamid
                              
                                
                                
                            }
                            
                            
                            
                        }
                        
                        
                    }
                    
                }//json!=nil
                  
                
        }//alamofire
    
    
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