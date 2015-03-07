//
//  TournamentAPI.swift
//  Cteemo
//
//  Created by bintao on 15/2/21.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON


var Tournament: TournamentAPI = TournamentAPI()

class TournamentAPI: NSObject{
    
    
    let key = "OzVqaaqFdjiuTGPbbeQfvpgHxnIcquz6yh5LSwep"
    // for tournament
    var totalnumber :String = ""
    var tournamentName: [AnyObject] = [AnyObject]()
    var tournamentUrl: [AnyObject] = [AnyObject]()
    var tournamentID: [AnyObject] = [AnyObject]()
    var gameName : [AnyObject] = [AnyObject]()
    var startTime : [AnyObject] = [AnyObject]()
    var totalMember : [AnyObject] = [AnyObject]()
    var tournamentType : [AnyObject] = [AnyObject]()
    var groupstage: [AnyObject] = [AnyObject]()
    var maxteam :[AnyObject] = [AnyObject]()
    
    // for teams
    var teams :[AnyObject] = [AnyObject]()
    
    func getArray(){
        
    }
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
    func resetdata(){
        
        self.tournamentName.removeAll()
        self.tournamentName.removeAll()
        self.tournamentUrl.removeAll()
        self.tournamentID .removeAll()
        self.gameName.removeAll()
        self.startTime.removeAll()
        self.totalMember.removeAll()
        self.tournamentType.removeAll()
        self.groupstage.removeAll()
        self.maxteam.removeAll()
    
    
    }
    //show Tournament
    func showTournament(id: String){
    
        var par : [String: AnyObject] = ["api_key":key,"include_participants":1]
        var req = Alamofire.request(.GET, "https://api.challonge.com/v1/tournaments/"+id+".json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                if JSON? != nil{
                var result: [String: AnyObject] = JSON as [String: AnyObject]
                println(JSON)
                
                }
                }
        }
    
    //https://api.challonge.com/v1/tournaments/{tournament}/participants.{json|xml}

    func getTournamentList(){
        
        var par : [String: AnyObject] = ["api_key":Tournament.key]
        var req = Alamofire.request(.GET,"https://api.challonge.com/v1/tournaments.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                
                let myjson = SwiftyJSON.JSON(JSON!)
                self.totalnumber = "\(SwiftyJSON.JSON(JSON!).count)"
                for i in 0...myjson.count-1{
                if let url = myjson[i]["tournament"]["url"].string{
                self.tournamentUrl.append(url)
                }
                if let name = myjson[i]["tournament"]["name"].string{
                self.tournamentName.append(name)
                }
                if let id = myjson[i]["tournament"]["id"].int{
                    self.tournamentID.append(id)
                }
                if let type = myjson[i]["tournament"]["tournament_type"].string{
                    self.tournamentType.append(type)
                }
                else{
                    self.tournamentType.append("noType")
                }
                if let teams = myjson[i]["tournament"]["participants_count"].int{
                    self.totalMember.append(teams)
                }
                if let start = myjson[i]["tournament"]["start_at"].string{
                    self.startTime.append(start)
                }
                else{
                 self.startTime.append("noTime")
                }
                if let game = myjson[i]["tournament"]["game_name"].string{
                    self.gameName.append(game)
                }
                else {
                    self.gameName.append("noGame")
                }
                if let group = myjson[i]["tournament"]["group_stages_enabled"].int{
                        self.groupstage.append(group)
                }
                if let max = myjson[i]["tournament"]["signup_cap"].int{
                    self.maxteam.append(max)
                }
                else{ self.maxteam.append(256)}
                
                    
                }
    
                
                println(self.totalnumber)
        }
    }
    
    //Delete Tournament
    func deleteTournament(id:String){
        
        var par : [String: AnyObject] = ["api_key":key]
        var req = Alamofire.request(.DELETE, "https://api.challonge.com/v1/tournaments/"+id+".json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                print(JSON)
                
        }
    }
    
    //joinTournaent
    func JoinTournament(id: String, name : String,email : String)
    {
    
        var par : [String: AnyObject] = ["api_key":key,"participant[name]":name,"participant[email]":email]
        var req = Alamofire.request(.POST, "https://api.challonge.com/v1/tournaments/"+id+"/participants.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                var result: [String: AnyObject] = JSON as [String: AnyObject]
                println(result)
                
        }

    }

    // tournament member
    func getMembers(name:String){
    
        var par : [String: AnyObject] = ["api_key":key]
        var req = Alamofire.request(.GET, "https://api.challonge.com/v1/tournaments/"+name+"/participants.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
               println(JSON)
                
        }

    
    }
    
    func findMemberID(name: String,member :String) -> Int{
        var s : Int = 1
        var par : [String: AnyObject] = ["api_key":key]
        var req = Alamofire.request(.GET, "https://api.challonge.com/v1/tournaments/"+name+"/participants.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
             let myjson = SwiftyJSON.JSON(JSON!)
            for i in 0...myjson.count-1{
                if let k = myjson[i]["participant"]["name"].string{
                    
                    if k == member{
                        println(k)
                        if let n =  myjson[i]["participant"]["id"].int{
                            s = n
                        println(s)
                        }
                    }
                }
            }
            
        }
          return s
        
    }
    
    
    func deleteMember(name: String,id :Int){
    
        var par : [String: AnyObject] = ["api_key":key]
        var s = "\(id)"
        println(name)
        println(id)
        var req = Alamofire.request(.DELETE, "https://api.challonge.com/v1/tournaments/"+name+"/participants/"+s+".json" ,parameters:par)
            .responseJSON { (_, _, JSON, _) in
                println(JSON)
        }
    }

    func deleteMemberByname(name:String,member:String){
        var s : Int = 0
        var par : [String: AnyObject] = ["api_key":key]
        var req = Alamofire.request(.GET, "https://api.challonge.com/v1/tournaments/"+name+"/participants.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                let myjson = SwiftyJSON.JSON(JSON!)
                for i in 0...myjson.count-1{
                    if let k = myjson[i]["participant"]["name"].string{
                        if k == member{
                            println(k)
                            if let n =  myjson[i]["participant"]["id"].int{
                                s = n
                                println(n)
                                
                               self.deleteMember(name, id: n)
                            }
                        }
                    }
                }
        }
        
        if s == 0 { println("no team find") }
    }
    
}