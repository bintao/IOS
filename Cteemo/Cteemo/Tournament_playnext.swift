//
//  Tournament_playnext.swift
//  Cteemo
//
//  Created by bintao on 15/3/30.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//
import UIKit


class Tournament_playnext:  UIViewController  {

    var url : String = ""
    var starttimetext = ""
    var myteamid = 0
    
    var matchid = 0
    
   
    var tournamentname = ""
    
    var gametype = ""
    var gameID = 0
    var gameStartTime = 0
    var player1 = 0
    var player2 = 0
    
    
    var mychampionpick = 0
    var myteam = teamdata()
    var oppteam = teamdata()
    
    var textfield : UITextField!
    var blueteammember :[matchmember] = []
    var redmember :[matchmember] = []
    
    var round = "round "
    
    
    @IBOutlet var time: UILabel!

    @IBOutlet var startmatch: UIButton!
    
        
    
    @IBOutlet var icon: UIImageView!
    
    @IBOutlet var starttime: UILabel!
    var check = false
    let globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    
     override func viewDidLoad() {
        
        super.viewDidLoad()
        
        icon.image = UIImage(named: "error.png")!
        self.starttime.text = self.starttimetext

        
    }
    
    override func viewDidAppear(animated: Bool) {
        
       self.check = false
        var par : [String: AnyObject] = ["api_key":Tournament.key,"participant_id" : myteamid]
        
        let alert = SCLAlertView()
        
        alert.showWaiting(self.parentViewController?.parentViewController, title: "Loading data", subTitle: "please wait loding....", closeButtonTitle: nil, duration: 0.0)
       
        
        var req = request(.GET, "https://api.challonge.com/v1/tournaments/"+url+"/matches.json",parameters:par)
            .responseJSON { (_, _, JSONdata, _) in
                
                alert.hideView()
                
                if JSONdata != nil  {
                let myjson = JSON(JSONdata!)
                var scoreresult = ""
                var count = myjson.count
                
                println(JSONdata)
                
                
                if count != 0  {
                    
                if let state = myjson[count - 1]["match"]["state"].string
                {
                    
                    if state != "complete" {
                        
                        if let id = myjson[count - 1]["match"]["id"].int
                        {
                            self.matchid = id
                            
                        }
                        
                        if let player = myjson[count - 1]["match"]["player1_id"].int
                        {
                            
                            self.player1 = player
                            
                        }
                        
                        if let player = myjson[count - 1]["match"]["player2_id"].int
                        {
                            
                            self.player2 = player
                            
                        }
                        
                        if let roundn = myjson[count - 1]["match"]["round"].int
                        {
                            
                            self.round = "round " + "\(roundn)"
                            
                        }
                        
                        if self.player1 == 0 || self.player2 == 0 {
                            
                            let alert1 = SCLAlertView()
                            alert1.addButton("ok"){
                                
                                self.performSegueWithIdentifier("backtojoined", sender: self)
                                
                            }
                            alert1.showWarning(self.parentViewController?.parentViewController, title: "Opponent not ready", subTitle: "Please wait him ready", closeButtonTitle: nil, duration: 0.0)
                        
                        }
                        
                        if let result = myjson[count - 1]["match"]["scores_csv"].string
                        {
                            
                            scoreresult = result
                        }
                        
                        if self.player1 == self.myteamid {
                            if scoreresult == ""{
                                self.myteam.win =  0
                                self.oppteam.win =  0
                                
                            }else{
                            self.myteam.win =  Array(scoreresult.utf8).map { Int($0) }[0]
                            self.oppteam.win =  Array(scoreresult.utf8).map { Int($0) }[2]
                            }
                            self.myteam.teamkey = 1
                            self.myteam.teamid = self.player1
                            self.oppteam.teamid = self.player2
                        }
                        else{
                            if scoreresult == ""{
                                self.myteam.win =  0
                                self.oppteam.win =  0
                            
                            }else{
                            self.myteam.win =  Array(scoreresult.utf8).map { Int($0) }[2]
                            self.oppteam.win =  Array(scoreresult.utf8).map { Int($0) }[0]
                            }
                            self.myteam.teamkey = 2
                            self.myteam.teamid = self.player2
                            self.oppteam.teamid = self.player1
                            
                        }
                       
                        
                        var time2 = dispatch_time(DISPATCH_TIME_NOW, (Int64)(800 * NSEC_PER_SEC))
                        
                        dispatch_after(time2, self.globalQueue) { () -> Void in
                            
                            if !self.check {
                                
                                self.starttournament()
                                
                            }// chekc game started
                            
                        }//wait 5 mins to start game
                        
                    }// check match complete
                    
                    else {
                    
                        let alert1 = SCLAlertView()
                        alert1.addButton("ok"){
                            
                            self.performSegueWithIdentifier("backtojoined", sender: self)
                            
                        }
                        alert1.showError(self.parentViewController?.parentViewController, title: "Your match is complete", subTitle: "Please check your score", closeButtonTitle: nil, duration: 0.0)

                    
                    }// match is complete
                    
                    
                }//state
          
                
                }//count is 0 can't find
                    
                    
                else{
                    
                    println(JSONdata)
                    let alert1 = SCLAlertView()
                    alert1.addButton("ok"){
                        
                        self.performSegueWithIdentifier("backtojoined", sender: self)
                        
                    }
                    alert1.showError(self.parentViewController?.parentViewController, title: "Tournament not Start", subTitle: "Please wait until Tournament start", closeButtonTitle: nil, duration: 0.0)
                    
                    
                    }


                }// check json
                
                println(self.matchid)
                
                
        }
      
        
        
    }
    
    
    @IBAction func getcode(sender: AnyObject) {
        if self.matchid != 0  {
        var name = self.tournamentname + "\(self.matchid)"
        var code = ""
        if Tournament.solo{
            code = Tournament.solotournamentcode(name, pass:"123")
        }
        else{
        code = Tournament.tournamentcode(name, pass: "123")
        }
            var time1 = dispatch_time(DISPATCH_TIME_NOW, (Int64)(600 * NSEC_PER_SEC))
            
            dispatch_after(time1, self.globalQueue) { () -> Void in
                
                if !self.check {
                    
                    self.starttournament()
                    
                }// chekc game started
                
            }//wait 10 mins to start game
            
            var time = dispatch_time(DISPATCH_TIME_NOW, (Int64)(1200 * NSEC_PER_SEC))
            
            dispatch_after(time, self.globalQueue) { () -> Void in
                
                if !self.check {
                    
                    self.starttournament()
                    
                }// chekc game started
                
            }//wait 20 mins to start game
            
            
        self.sentemail(code)
        
        }
        else{
        
            let alert1 = SCLAlertView()
            alert1.addButton("ok"){
                
                self.performSegueWithIdentifier("backtojoined", sender: self)
                
            }
            alert1.showError(self.parentViewController?.parentViewController, title: "Error", subTitle: "Please reEnter play next Game", closeButtonTitle: nil, duration: 0.0)
            
        }
    }


    @IBAction func startmatchaction(sender: AnyObject) {
        
        let url = "https://na.api.pvp.net/observer-mode/rest/consumer/getSpectatorGameInfo/NA1/"+LolAPIGlobal.lolID+"?api_key="+LolAPIGlobal.key
        
        
        request(.GET,url)
            .responseJSON { (_, _, JSONdata, error) in
                
                if JSONdata != nil && JSONdata as? [String : AnyObject]? != nil {
                    
                    let myjson = JSON(JSONdata!)
                    
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
                                        if summonerId == LolAPIGlobal.lolID.toInt() {
                                            
                                            if let championId = myjson["participants"][i]["championId"].int
                                            {
                                                self.mychampionpick = championId
                                            }
                                            
                                        }
                                    }
                                    if let iconid = myjson["participants"][i]["profileIconId"].int
                                    {
                                        member.iconid = iconid
                                    }
                                    
                                    if teamid == 100{
                                        
                                        if i < self.blueteammember.count
                                        {
                                            self.blueteammember[i] = member
                                        }
                                        else  if self.blueteammember.count < 5 {
                                            
                                            self.blueteammember.append(member)
                                        }
                                        
                                        
                                    }else{
                                        
                                        if i < self.redmember.count
                                        {
                                            self.redmember[i] = member
                                        
                                        }
                                        else  if self.redmember.count < 5 {
                                        
                                            self.redmember.append(member)

                                        }
                                        
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
    
    func starttournament(){
    
        let url = "https://na.api.pvp.net/observer-mode/rest/consumer/getSpectatorGameInfo/NA1/"+LolAPIGlobal.lolID+"?api_key="+LolAPIGlobal.key
        println("sdsdsd")
        request(.GET,url)
            .responseJSON { (_, _, JSONdata, error) in
                
                if JSONdata != nil && JSONdata as? [String : AnyObject]? != nil {
                   
                    let myjson = JSON(JSONdata!)
                    
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
                            self.check = true
                            
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
                                        if summonerId == LolAPIGlobal.lolID.toInt() {
                                            
                                            if let championId = myjson["participants"][i]["championId"].int
                                            {
                                                self.mychampionpick = championId
                                            }
                                            
                                        }
                                    }
                                    if let iconid = myjson["participants"][i]["profileIconId"].int
                                    {
                                        member.iconid = iconid
                                    }
                                    
                                    if teamid == 100{
                                        
                                        if i < self.blueteammember.count
                                        {
                                            self.blueteammember[i] = member
                                        }
                                        else if self.blueteammember.count < 5 {
                                            
                                            self.blueteammember.append(member)
                                        }
                                        
                                        
                                    }else{
                                        
                                        if i < self.redmember.count
                                        {
                                            self.redmember[i] = member
                                            
                                        }
                                        else if self.redmember.count < 5{
                                            
                                            self.redmember.append(member)
                                            
                                        }
                                        
                                    }
                                    
                                }//teamid
                                
                                
                            }//forloop
                            
                            self.performSegueWithIdentifier("gamestart", sender: self)
                            
                        }
                        
                        
                    }
                    
                }//json!=nil
                else{
                    
                  
                    
                }
                
        }//alamofire

    
    
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "gamestart"{
       
            var controller: Tournament_startgame = segue.destinationViewController as! Tournament_startgame
            controller.blueteammember = self.blueteammember
            controller.redmember = self.redmember
            controller.gameID = self.gameID
            controller.matchid = self.matchid
            controller.url = self.url
            controller.myteamdata = self.myteam
            controller.oppteam = self.oppteam
            controller.mychampion = self.mychampionpick
            
        }
    
    
    }
    
    
    func  sentemail (tournamentcode : String){

        /* curl -X POST https://api.sendgrid.com/api/mail.send.json -d api_user=bintao -dapi_key=ck80i539gz -d to=bintao@cteemo.com -d toname=bintao -d subject=chaos -dtext=chaos -d from=support@cteemo.com -d content=123123
        */
        
        if UserInfoGlobal.email != nil {
        
        var par : [String: AnyObject] = ["api_user":"bintao","api_key":"ck80i539gz","to":UserInfoGlobal.email,"toname":"bintao","subject":"Touranment Code for " + self.round,"text": tournamentcode,"from":"support@cteemo.com"]
            
        println(UserInfoGlobal.email)
        var url = "https://api.sendgrid.com/api/mail.send.json"
        var req = request(.POST, url, parameters: par)
            .responseJSON { (_, _, JSONdata, error) in
                
                let myjson = JSON(JSONdata!)
                if let message = myjson["message"].string
                {
                    if message == "success"{
                    
                        let alert1 = SCLAlertView()
                        
                         alert1.showCustom(self.parentViewController?.parentViewController, image: UIImage(named: "email2.png")!, color: UserInfoGlobal.UIColorFromRGB(0x3498DB), title: "Tournament code !", subTitle: "Please check " + UserInfoGlobal.email,closeButtonTitle: "ok", duration: 60.0)
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
            
            alert1.showCustom(self.parentViewController?.parentViewController, image: UIImage(named: "email2.png")!, color: UserInfoGlobal.UIColorFromRGB(0x3498DB), title: "Type email !", subTitle: "we can't find you email" + UserInfoGlobal.email,closeButtonTitle: nil, duration: 0.0)
        
        }
        
        
    
    }
    
    

}