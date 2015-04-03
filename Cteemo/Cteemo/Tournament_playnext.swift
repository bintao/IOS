//
//  Tournament_playnext.swift
//  Cteemo
//
//  Created by bintao on 15/3/30.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON

class Tournament_playnext:  UIViewController  {

    var url : String = ""
    var starttimetext = ""
    var myteamid = 0
    
    var matchid = 0
    
    var opponentid = 0
    
    var player1 = 0
    var player2 = 0
    
    var tournamentname = ""
    
    
    var gametype = ""
    var gameID = 0
    var gameStartTime = 0
    
    
    var blueteammember :[matchmember] = []
    var redmember :[matchmember] = []
    
    
    @IBOutlet var time: UILabel!

    @IBOutlet var startmatch: UIButton!
    
        
    
    @IBOutlet var icon: UIImageView!
    
    @IBOutlet var starttime: UILabel!
    
    
     override func viewDidLoad() {
        
        super.viewDidLoad()
        
        icon.image = UIImage(named: "error.png")!
        self.startmatch.alpha = 0
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
     
        
      
        
        var par : [String: AnyObject] = ["api_key":Tournament.key,"participant_id" : myteamid]
        
        
        var req = Alamofire.request(.GET, "https://api.challonge.com/v1/tournaments/"+url+"/matches.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                println(JSON)
                
                if JSON != nil && JSON as? [String: AnyObject]? != nil {
                    
                let myjson = SwiftyJSON.JSON(JSON!)
                    
                var count = myjson.count
                    
                if count != 0 {
                if let id = myjson[count - 1]["match"]["id"].int
                {
                    self.matchid = id
                    
                }
                if let player1 = myjson[count - 1]["match"]["player1_id"].int
                {
                    
                   self.player1 = player1
                    
                }
                
                if let player2 = myjson[count - 1]["match"]["player2_id"].int
                {
                    
                    self.player2 = player2
                    
                }
                
                if self.player1 == self.myteamid {
                    
                    self.opponentid =  self.player2
                }
                else{
                    
                    self.opponentid =  self.player1
                    
                    }
                
                    }
                    
                }
                else{
                /*
                let alert1 = SCLAlertView()
                    alert1.addButton("ok"){
                    
                        self.performSegueWithIdentifier("backtojoined", sender: self)
                    
                    }
                alert1.showError(self.parentViewController?.parentViewController, title: "Tournament not Start", subTitle: "Please wait until Tournament start", closeButtonTitle: nil, duration: 0.0)
                println("sdsdd")
                */
                
                }
                
                println(self.opponentid)
                
                println(self.matchid)
                
                
        }
       
        
        
      
        
        
    }
    
    
    @IBAction func getcode(sender: AnyObject) {
        
        var name = self.tournamentname + "\(self.player1)" + " vs " + "\(self.player2)"
        Tournament.tournamentcode(name, pass:"123")
        self.startmatch.alpha = 1
        self.sentemail()
        
    }
    
    
    @IBAction func startmatchaction(sender: AnyObject) {
        
        let url = "https://na.api.pvp.net/observer-mode/rest/consumer/getSpectatorGameInfo/NA1/"+LolAPIGlobal.lolID+"?api_key="+LolAPIGlobal.key
        
        
        Alamofire.request(.GET,url)
            .responseJSON { (_, _, JSON, error) in
                
                if JSON != nil && JSON as? [String : AnyObject]? != nil {
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
                        self.gameID = gameId
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
                                
                                
                                
                            }//forloop
                            
                            self.performSegueWithIdentifier("gamestart", sender: self)
                            
                        }
                        
                        
                    }
                    
                }//json!=nil
                else{
                
                    let alert1 = SCLAlertView()
                    
                    alert1.showError(self.parentViewController?.parentViewController, title: "You must start game", subTitle: "Please start game before click", closeButtonTitle: "ok", duration: 0.0)
                    
                
                }
                
        }//alamofire

        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "gamestart"{
       
        
            
        
        }
    
    
    
    }
    
    
    func  sentemail (){



        /*curl -s https://api:key-1c2afaf797833a0b50c0507fc2131ec1@api.mailgun.net/v3/www.cteemolol.com/messages
        -F from='Excited User <mailgun@www.cteemolol.com>'
        -F to=bintao@cteemo.com
        -F subject='Hello'
        -F text='Testing some Mailgun awesomness!'
        */
        
        
        var par  = ["from":"Excited User <mailgun@www.cteemolol.com>","to" : "bintao@cteemo.com","subject":"Hello","text":"Testing some Mailgun awesomness!"]
        
        var url = "https://api:key-1c2afaf797833a0b50c0507fc2131ec1@api.mailgun.net/v3/www.cteemolol.com/messages"
        var req = Alamofire.request(.POST, url, parameters: par)
            .responseJSON { (_, _, JSON, error) in
                println(JSON)
                println(error)

        }
        
    
        
       
    
    
    }

}