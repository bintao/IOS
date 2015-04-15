//
//  Tournament_startgame.swift
//  Cteemo
//
//  Created by bintao on 15/3/31.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//


import UIKit

class matchmember {
    
    var name = String()
    var heropick = Int()
    var summonerId = Int()
     var iconid = Int()
    
    
}

struct teamdata {
    
    
    var win = Int()
    var teamkey = Int()
    var teamid = Int()
    
    init() {
    
    win = 0
    }
    

}

class Tournament_startgame: UIViewController {

    @IBOutlet var finishbu: UIButton!
    
    var myteamdata = teamdata()
    var oppteam = teamdata()
    @IBOutlet var myteam: UIScrollView!
    @IBOutlet var opponent: UIScrollView!
    
    var win: Bool!
    
    var mychampion = 0
    var gametype = ""
    var gameStartTime = 0
    var gameID = 0
    var matchid = 0
    
    var url :String = ""

    var blueteammember :[matchmember] = []
    var redmember :[matchmember] = []
    
    override func viewDidLoad() {
        
        
        if Tournament.solo {
        
            
            self.finishbu.setTitle("Finish solo", forState: UIControlState.Normal)
        
        }
        else{
        
            self.finishbu.setTitle("Game Finish", forState: UIControlState.Normal)
            
        }
        
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
        if Tournament.solo {
        
            self.soloTournament()
        
        }
        
        else{
        
        let url = "https://na.api.pvp.net/api/lol/na/v2.2/match/"+"\(self.gameID)"+"?api_key="+LolAPIGlobal.key
        request(.GET,url)
            .responseJSON { (_, _, JSONdata, _) in
                var participantId = 0
                if JSONdata != nil{
                    let myjson = JSON(JSONdata!)
                    
                    if let player = myjson["participants"].array{
                    
                    if player.count != 0 {
                        
                        for i in 0...player.count - 1
                        {
                            
                            if let champion = myjson["participants"][i]["championId"].int
                            {
                                
                                if self.mychampion == champion {
                                    
                                        if let winner = myjson["participants"][i]["stats"]["winner"].bool{
                                            
                                            println(winner)
                                            
                                            if winner {
                                            
                                            self.finishgame()
                                            
                                            
                                            }
                                            else{
                                            
                                                let alert1 = SCLAlertView()
                                                alert1.addButton("ok"){
                                                
                                                 self.performSegueWithIdentifier("backjoinedgame", sender: self)
                                                
                                                }
                                                
                                                alert1.showNotice(self.parentViewController?.parentViewController, title: "Loss", subTitle: "Don't give up! You can win next time!", closeButtonTitle: nil, duration: 0.0)
                                            
                                            
                                            }
                                            
                                          
                                    }
                                    
                                }//check id
                                
                            }
                            
                        }//end for loop
                        
                      
                        
                    }//playercount
                    
                        
                    }//player
                    
                    
                }//jsonnil
                
                else{
                    
                    let alert1 = SCLAlertView()
                    
                    alert1.showWarning(self.parentViewController?.parentViewController, title: "Game not finished", subTitle: "Please finish game first", closeButtonTitle: "ok", duration: 0.0)
                    
                }
                
        }//request end
        
        }
    }

    
    
    func soloTournament(){
    
        
        let alert1 = SCLAlertView()
        
        
        alert1.addButton("Win & report photo"){
            
            self.performSegueWithIdentifier("winnerReport", sender: self)
            
        }
        
        alert1.addButton("Loss & play next time"){
           
        self.performSegueWithIdentifier("backjoinedgame", sender: self)
            
        }
        
        
         alert1.showCustom(self.parentViewController?.parentViewController, image: UIImage(named: "error.png")!, color: UserInfoGlobal.UIColorFromRGB(0x333333), title: "Log out CTeemo", subTitle: "Play tournament next time~ ",closeButtonTitle: "Cancel", duration: 0.0)
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "winnerReport"{
            
            var controller: Tournament_WinnerPhoto = segue.destinationViewController as Tournament_WinnerPhoto
            
            controller.url = self.url
            controller.myteamdata = self.myteamdata
            controller.oppteam = self.oppteam
            controller.matchid = self.matchid

        }
    }
    
    
    
    func finishgame(){
        
        var score = ""
        var win = myteamdata.win + 1
        var par : [String: AnyObject]
        if myteamdata.teamkey == 1 {
            score = "\(win)" + "-" + "\(oppteam.win)"
            
        }
        else{
            score = "\(oppteam.win)" + "-" + "\(win)"
            
        }
        
        println(score)
        
        if win < 2 {
            
        par  = ["api_key":Tournament.key,"match[scores_csv]":score,"match[winner_id]": myteamdata.teamid]
        }
        else{
            
        par  = ["api_key":Tournament.key,"match[scores_csv]":score,"match[winner_id]": myteamdata.teamid]
            
        }
        
        println(par)
        
        let url = "https://api.challonge.com/v1/tournaments/"+self.url+"/matches/"+"\(self.matchid)"+".json"
        
        request(.PUT,url, parameters: par)
            .responseJSON { (_, _, JSON, _) in
                
                if JSON != nil{
                    
                    let alert1 = SCLAlertView()
                    alert1.addButton("ok"){
                        
                        self.performSegueWithIdentifier("backjoinedgame", sender: self)
                        
                    }
                    alert1.showSuccess(self.parentViewController?.parentViewController, title: "WIN", subTitle: "Cong! Summoner you just won a game!", closeButtonTitle: nil, duration: 0.0)

                    
                }
        }
            
        
        
        
    }
    
    
    
    
    
    

}