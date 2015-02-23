//
//  TournamentAPI.swift
//  Cteemo
//
//  Created by bintao on 15/2/21.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//


import UIKit
import Alamofire


var Tournament: TournamentAPI = TournamentAPI()

class TournamentAPI: NSObject{
    
    let key = "OzVqaaqFdjiuTGPbbeQfvpgHxnIcquz6yh5LSwep"
    
   /* POST https://challonge.com/api/tournaments.{json|xml}
    
    http://api.challonge.com/v1/documents/tournaments/create
    tournament[name]	Your event's name/title (Max: 60 characters)
    tournament[tournament_type]	Single elimination (default), double elimination, round robin, swiss
    
    ,"tournament[tournament_type]":type
    */
    
    func createTournament(name:String,intro:String){
        
        var par : [String: AnyObject] = ["api_key":key,"tournament[name]":name,"tournament[url]":name,"tournament[description]":intro,"tournament[open_signup]":false]
        var req = Alamofire.request(.POST, "https://challonge.com/api/tournaments.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                var result: [String: AnyObject] = JSON as [String: AnyObject]
                println(result)
        }
    
    }
    
    


    func showTournament(id: String){
    
        var par : [String: AnyObject] = ["api_key":key]
        var req = Alamofire.request(.GET, "https://api.challonge.com/v1/tournaments/"+id+".json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                var result: [String: AnyObject] = JSON as [String: AnyObject]
                println(JSON)
                
                }
        }
    
    //https://api.challonge.com/v1/tournaments/{tournament}/participants.{json|xml}

    func showTournamentMember(id :String){
    
        var par : [String: AnyObject] = ["api_key":key]
        var req = Alamofire.request(.GET, "https://api.challonge.com/v1/tournaments/:"+id+"/participants.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                var result: [String: AnyObject] = JSON as [String: AnyObject]
                println(result)
                
        }
    
    
    }
    
    
    func JoinTournament(id: String, name : String,email : String)
    {
    
        var par : [String: AnyObject] = ["api_key":key,"participant[name]":name,"participant[email]":email]
        var req = Alamofire.request(.POST, "https://api.challonge.com/v1/tournaments/"+id+"/participants.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                var result: [String: AnyObject] = JSON as [String: AnyObject]
                println(result)
                
        }

    
    
    }

}