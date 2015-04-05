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
    
    var textfield : UITextField!
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
        self.starttime.text = self.starttimetext
        
        
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
        var code = Tournament.tournamentcode(name, pass:"123")
        self.startmatch.alpha = 1
        self.sentemail(code)
        
    }
    
    
    @IBAction func startmatchaction(sender: AnyObject) {
        
        let url = "https://na.api.pvp.net/observer-mode/rest/consumer/getSpectatorGameInfo/NA1/"+LolAPIGlobal.lolID+"?api_key="+LolAPIGlobal.key
        
        
        Alamofire.request(.GET,url)
            .responseJSON { (_, _, JSON, error) in
                
                if JSON != nil && JSON as? [String : AnyObject]? != nil {
                    let myjson = SwiftyJSON.JSON(JSON!)
                    
                    println("sdsd")
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
       
            var controller: Tournament_startgame = segue.destinationViewController as Tournament_startgame
            
            controller.blueteammember = self.blueteammember
            controller.redmember = self.redmember
            controller.gameID = self.gameID
            
        
        }
    
    
    
    }
    
    
    func  sentemail (tournamentcode : String){



        /* curl -X POST https://api.sendgrid.com/api/mail.send.json -d api_user=bintao -dapi_key=ck80i539gz -d to=bintao@cteemo.com -d toname=bintao -d subject=chaos -dtext=chaos -d from=support@cteemo.com -d content=123123
        */
        
        if UserInfoGlobal.email != "" {
        
        var par : [String: AnyObject] = ["api_user":"bintao","api_key":"ck80i539gz","to":UserInfoGlobal.email,"toname":"bintao","subject":"Touranment Code","text": tournamentcode,"from":"support@cteemo.com"]
        println(UserInfoGlobal.email)
        var url = "https://api.sendgrid.com/api/mail.send.json"
        var req = Alamofire.request(.POST, url, parameters: par)
            .responseJSON { (_, _, JSON, error) in
                println(JSON)
                
                let myjson = SwiftyJSON.JSON(JSON!)
                if let message = myjson["message"].string
                {
                    if message == "success"{
                    
                    
                        let alert1 = SCLAlertView()
                        
                         alert1.showCustom(self.parentViewController?.parentViewController, image: UIImage(named: "email2.png")!, color: UserInfoGlobal.UIColorFromRGB(0x3498DB), title: "Tournament code !", subTitle: "Please check " + UserInfoGlobal.email,closeButtonTitle: "ok", duration: 0.0)
                    }
                    
                    
                }
        }
        
        }
        else {
            
            let alert1 = SCLAlertView()
            
            self.textfield = alert1.addTextField("email")
            alert1.addButton("ok"){
                if self.textfield.text != "" && self.textfield.text.rangeOfString("@")?.isEmpty != nil{
                    UserInfoGlobal.email = self.textfield.text
                    UserInfoGlobal.saveUserData()
                }
               
            }
            
            alert1.showCustom(self.parentViewController?.parentViewController, image: UIImage(named: "email2.png")!, color: UserInfoGlobal.UIColorFromRGB(0x3498DB), title: "Tournament code !", subTitle: "Please check " + UserInfoGlobal.email,closeButtonTitle: nil, duration: 0.0)
        
        }
        
        
    
    }
    
    

}