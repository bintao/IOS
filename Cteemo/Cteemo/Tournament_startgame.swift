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
    var gameID = 0

    var blueteammember :[matchmember] = []
    var redmember :[matchmember] = []
    
    override func viewDidLoad() {
        
        
        println(self.gameID)
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
    
    override func viewDidAppear(animated: Bool) {
        
        
    
    
    
    }
    
    
    @IBAction func finishgame(sender: AnyObject) {
        
        
        let url = "https://na.api.pvp.net/api/lol/na/v2.2/match/"+"1765292791"+"?api_key="+LolAPIGlobal.key
        println(url)
        Alamofire.request(.GET,url)
            .responseJSON { (_, _, JSON, _) in
                var participantId = 0
                if JSON != nil{
                    let myjson = SwiftyJSON.JSON(JSON!)
                    
                    if let player = myjson["participantIdentities"].array{
                    println(player)
                    
                    println(player.count)
                    
                    if player.count != 0 {
                        
                        for i in 0...player.count - 1
                        {
                            
                            
                            if let summonerid = myjson["participantIdentities"][i]["player"]["summonerId"].int
                            {
                                
                                if LolAPIGlobal.lolID == "\(summonerid)"{
                                
                                    if let  id = myjson["participantIdentities"][i]["participantId"].int
                                    {
                                        
                                        println(summonerid)
                                    
                                        if let winner = myjson["participants"][id-1]["stats"]["winner"].bool{
                                        
                                          
                                        println(winner)
                                        
                                        }
                                        
                                    
                                    }
                                    
                                }//check id
                                
                            }
                            
                        }//end for loop
                        
                      
                        
                    }//playercount
                    
                        
                    }//player
                    
                    
                }//jsonnil
                
        }//request end

        
        
    }

    func finishgame(){
    
        //let url = "https://na.api.pvp.net/api/lol/na/v2.2/match/"+"\(self.gameID)"+"?api_key="+LolAPIGlobal.key
        
        
    
    }
    
    
    
    
    

}