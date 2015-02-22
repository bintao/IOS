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
    
    */
    func createTournament(name:String,type:String,url:String,intro:String){
        
        var par : [String: AnyObject] = ["api_key":key,"tournament[name]":name,"tournament[tournament_type]":type,"tournament[url]":url,"tournament[description]":intro,"tournament[open_signup]":false]
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
                println(result)
                
                }
        }
    
    //https://api.challonge.com/v1/tournaments/{tournament}/participants.{json|xml}

    func showTournamentMember(id :String){
    
        var par : [String: AnyObject] = ["api_key":key]
        var req = Alamofire.request(.GET, "https://api.challonge.com/v1/tournaments/"+id+"/participants.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                var result: [String: AnyObject] = JSON as [String: AnyObject]
                println(result)
                
        }
    
    
    
    }


}