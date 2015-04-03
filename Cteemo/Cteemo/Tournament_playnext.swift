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
    var myteamid = 0
    
    var matchid = 0
    
    var opponentid = 0
    
    var tournamentname = ""
    
    @IBOutlet var time: UILabel!

    
    @IBOutlet var teamicon: UIImageView!
    
    @IBOutlet var members: UIScrollView!
        
    
    
    override func viewDidAppear(animated: Bool) {
        var playerid1 = 0
        var playerid2 = 0
        var par : [String: AnyObject] = ["api_key":Tournament.key,"participant_id" : myteamid]
        
        println(self.url)
        println(self.myteamid)
        
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
                    
                   playerid1 = player1
                    
                }
                
                if let player2 = myjson[count - 1]["match"]["player2_id"].int
                {
                    
                    playerid2 = player2
                    
                }
                
                if playerid1 == self.myteamid {
                    
                    self.opponentid =  playerid2
                }
                else{
                    
                    self.opponentid =  playerid1
                    
                    }
                
                    }
                    
                }
                else{
                
                    
                let alert1 = SCLAlertView()
                    alert1.addButton("ok"){
                    
                        self.performSegueWithIdentifier("backtojoined", sender: self)
                    
                    }
                alert1.showError(self.parentViewController?.parentViewController, title: "Tournament not Start", subTitle: "Please wait until Tournament start", closeButtonTitle: nil, duration: 0.0)
                println("sdsdd")
                
                
                }
                
                println(self.opponentid)
                
                println(self.matchid)
                
                
        }
       
        
        
      
        
        
    }
    
    
    @IBAction func getcode(sender: AnyObject) {
        
        ///challonge_result, method : get, parameters : tournamentId, tournamentName, matchId
        var name = self.tournamentname + ""
        Tournament.tournamentcode(name, pass:"123")
        
        
        
    }
    
    
    
    func  sentemail (){



        /*curl -s --user 'api:key-1c2afaf797833a0b50c0507c2131ec1'

        https://api.mailgun.net/v3/www.cteemolol.com/messages

        -F from='Excited User <mailgun@www.cteemolol.com>'

        -F to=bintao@cteemo.com

        -F subject='Hello'

        -F text='Testing some Mailgun awesomness!'
        */
        
        var manager = Manager.sharedInstance
        // Specifying the Headers we need
        manager.session.configuration.HTTPAdditionalHeaders = [
            "api": "key-1c2afaf797833a0b50c0507c2131ec1"
        ]
        
        var par : [String: AnyObject] = ["from":"Excited User <mailgun@www.cteemolol.com>","to" : "bintao@cteemo.com","subject":"Hello","text":"Testing some Mailgun awesomness!"]
        
        var req = Alamofire.request(.POST, "https://api.mailgun.net/v3/www.cteemolol.com/messages",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                println(JSON)

        }
    
    }

}