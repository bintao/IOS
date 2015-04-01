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
    var member = 0
    
    var matchid = 0
    
    var opponentid = 0
    
    var tournamentname = ""
    
    @IBOutlet var time: UILabel!

    
    @IBOutlet var teamicon: UIImageView!
    
    @IBOutlet var members: UIScrollView!
        
    
    
    override func viewDidAppear(animated: Bool) {
        var playerid1 = 0
        var playerid2 = 0
        var par : [String: AnyObject] = ["api_key":Tournament.key,"participant_id" : member]
        
        println(self.url)
        println(self.member)
        
        var req = Alamofire.request(.GET, "https://api.challonge.com/v1/tournaments/"+url+"/matches.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                println(JSON)
                
                if JSON != nil {
                    
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
                
                if playerid1 == self.member {
                    
                    self.opponentid =  playerid2
                }
                else{
                    
                    self.opponentid =  playerid1
                    
                    }
                
                    }
                    
                }
                
                println(self.opponentid)
                
                println(self.matchid)
                
                
        }
        
        
      
        
        
    }
    
    
    @IBAction func getcode(sender: AnyObject) {
        
        ///challonge_result, method : get, parameters : tournamentId, tournamentName, matchId
        var name = self.tournamentname + "chaox vs chaos"
        Tournament.tournamentcode(name, pass:"123")
        var manager = Manager.sharedInstance
        // Specifying the Headers we need
        manager.session.configuration.HTTPAdditionalHeaders = [
            "token": UserInfoGlobal.accessToken
        ]
        
            var req = Alamofire.request(.GET, "http://54.149.235.253:5000/challonge_result",parameters: ["tournamentId": self.url,"tournamentName": self.url, "matchId" : self.matchid])
                .responseJSON { (_, _, JSON, _) in
                  
                    
            }
        
        
        
    }
    
    
    

}