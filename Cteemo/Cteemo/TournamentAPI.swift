//
//  TournamentAPI.swift
//  Cteemo
//
//  Created by bintao on 15/2/21.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//


import UIKit
import Foundation


struct Tournamentdata {
    
    
    var name = String()
    var url = String()
    var id = Int()
    var gameName = String()
    var startTime = String()
    var joinedmember = Int()
    var type = String()
    var group = Int()
    var max = Int()
    
}

var Tournament: TournamentAPI = TournamentAPI()


class TournamentAPI: NSObject{
    
    
    var key = "OzVqaaqFdjiuTGPbbeQfvpgHxnIcquz6yh5LSwep"
    
    let teamkey = "OzVqaaqFdjiuTGPbbeQfvpgHxnIcquz6yh5LSwep"
    let solokey = "QTDlzXYOuaeOSP2nyPfroTg2tiyoHF4EWjnYS6fo"
    
    var soloTournaments :[Tournamentdata] = []
    var teamTournaments :[Tournamentdata] = []
    
    // for tournamen
    
    // for teams
    var teams :[AnyObject] = [AnyObject]()
    var memberid = 0
    var solo :Bool = true
    
    func gettournamentdata(solo: Bool) {
     
        var key = ""
        
        if solo {
            key = self.solokey
            
        }
        else{
        
            key = self.teamkey
            
        }
        
        
        var par : [String: AnyObject] = ["api_key": key]
        
        var req = request(.GET,"https://api.challonge.com/v1/tournaments.json",parameters:par)
            .responseJSON { (_, _, JSONdata, _) in
                if JSONdata != nil{
                    
                    println(JSONdata)
                    let myjson = JSON(JSONdata!)
                    var totaltournament = myjson.count
                    if myjson.count != 0 {
                        for i in 0...myjson.count-1{
                            
                            var tournament = Tournamentdata()
                            
                            
                            if let url = myjson[i]["tournament"]["url"].string
                            {
                                 tournament.url = url
                            }
                            
                            if let name = myjson[i]["tournament"]["name"].string{
                                
                                tournament.name = name
                            }
                            
                            if let id = myjson[i]["tournament"]["id"].int{
                                
                               tournament.id = id
                            }
                            
                            if let type = myjson[i]["tournament"]["tournament_type"].string{
                                
                              tournament.type = type
                            }
                            else{
                                 tournament.type = "noType"
                            }
                            
                            
                            if let teams = myjson[i]["tournament"]["participants_count"].int{
                                tournament.joinedmember = teams
                            }
                            
                            if let start = myjson[i]["tournament"]["start_at"].string{
                                tournament.startTime = start
                            }
                            else{
                                tournament.startTime = "noTime"
                            }
                            
                            if let game = myjson[i]["tournament"]["game_name"].string{
                                tournament.gameName = game
                            
                            }
                            else {
                                 tournament.gameName = "noGame"
                            }
                            
                            
                            if let group = myjson[i]["tournament"]["group_stages_enabled"].int{
                                 tournament.group = group
                            }
                            
                            if let max = myjson[i]["tournament"]["signup_cap"].int{
                              tournament.max = max
                                
                            }
                            else{ tournament.max = 256}
                            
                            
                            if solo {
                            
                                
                                println(tournament.name)
                                
                                if self.soloTournaments.count < myjson.count{
                                
                                    self.soloTournaments.append(tournament)
                                
                                }else{
                                
                                    self.soloTournaments[i] = tournament
                                }
                            
                            
                            }
                            else{
                                
                                println(tournament.name)
                                println("sdsdsd")
                                
                                if self.teamTournaments.count < myjson.count{
                                    
                                    self.teamTournaments.append(tournament)
                                    
                                }
                                else{
                                    
                                self.teamTournaments[i] = tournament
                                
                                }
                            
                            
                            }
                            
                            
                        }//end for
                        
                        
                    }//end myjson
                   
                }//end nil
        
        
        }//end request
        
        
    
    }
    
    
    
    func getsolodata(){
        
        gettournamentdata(true)
        
    }
    
    func getteamdata(){
        
        gettournamentdata(false)
        
    }
    
    
   /* POST https://challonge.com/api/tournaments.{json|xml}
    
    http://api.challonge.com/v1/documents/tournaments/create
    tournament[name]	Your event's name/title (Max: 60 characters)
    tournament[tournament_type]	Single elimination (default), double elimination, round robin, swiss
    
    ,"tournament[tournament_type]":type
    */
    
    func createTournament(name:String,intro:String){
        
        var par : [String: AnyObject] = ["api_key":key,"tournament[name]":name,"tournament[url]":name,"tournament[description]":intro,"tournament[open_signup]":false]
        var req = request(.POST, "https://challonge.com/api/tournaments.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                var result: [String: AnyObject] = JSON as [String: AnyObject]
                println(result)
        }
    
    }
    
    
      //show Tournament
    func showTournament(id: String){
    
        var par : [String: AnyObject] = ["api_key":key,"include_participants":1]
        var req = request(.GET, "https://api.challonge.com/v1/tournaments/"+id+".json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                if JSON? != nil{
                var result: [String: AnyObject] = JSON as [String: AnyObject]
                println(JSON)
                
                }
                }
        }
    
    //https://api.challonge.com/v1/tournaments/{tournament}/participants.{json|xml}

       //Delete Tournament
    func deleteTournament(id:String){
        
        var par : [String: AnyObject] = ["api_key":key]
        var req = request(.DELETE, "https://api.challonge.com/v1/tournaments/"+id+".json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                print(JSON)
                
        }
    }
    
    
  
    
    //joinTournaent
    func JoinTournament(id: String, name : String)
    {
        var par : [String: AnyObject] = ["api_key":key,"participant[name]":name]
        var req = request(.POST, "https://api.challonge.com/v1/tournaments/"+id+"/participants.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                var result: [String: AnyObject] = JSON as [String: AnyObject]
                println(result)
        }

    }

    // tournament member
    func getMembers(name:String){
    
        var par : [String: AnyObject] = ["api_key":key]
        var req = request(.GET, "https://api.challonge.com/v1/tournaments/"+name+"/participants.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
               println(JSON)
                
        }

    
    }
    
    
    
    
    func findMemberID(name: String,member :String) {
        var s : Int = 1
        var par : [String: AnyObject] = ["api_key":key]
        var req = request(.GET, "https://api.challonge.com/v1/tournaments/"+name+"/participants.json",parameters:par)
            .responseJSON { (_, _, JSONdata, _) in
             let myjson = JSON(JSONdata!)
            if myjson.count != 0{
            for i in 0...myjson.count-1{
                if let k = myjson[i]["participant"]["name"].string{
                    
                    if k == member{
                        
                        if let n =  myjson[i]["participant"]["id"].int{
                            s = n
                            
                        }
                    }
                }
            }
        }
             
        }
        self.memberid = s
       
    }
    
    
    func deleteMember(name: String,id :Int){
    
        var par : [String: AnyObject] = ["api_key":key]
        var s = "\(id)"
        println(name)
        println(id)
        var req = request(.DELETE, "https://api.challonge.com/v1/tournaments/"+name+"/participants/"+s+".json" ,parameters:par)
            .responseJSON { (_, _, JSON, _) in
                println(JSON)
        }
    }

    func deleteMemberByname(name:String,member:String){
        var s : Int = 0
        var par : [String: AnyObject] = ["api_key":key]
        var req = request(.GET, "https://api.challonge.com/v1/tournaments/"+name+"/participants.json",parameters:par)
            .responseJSON { (_, _, JSONdata, _) in
                let myjson = JSON(JSONdata!)
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
    
    
    
    
    func getmatches(url: String,member : Int){
    //GET https://api.challonge.com/v1/tournaments/{tournament}/matches.{json|xml}
        
        var par : [String: AnyObject] = ["api_key":key,"participant_id" : member]
        
        var req = request(.GET, "https://api.challonge.com/v1/tournaments/"+url+"/matches.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                
                println(JSON)
                
                
        }
        
    }
    
    
    func tournamentStart(url: String){
    //POST https://api.challonge.com/v1/tournaments/{tournament}/start.{json|xml}
        
        var par : [String: AnyObject] = ["api_key":key]
        
        var req = request(.POST, "https://api.challonge.com/v1/tournaments/"+url+"/start.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                
                println(JSON)
                
                
                
        }

        
 
    }
    
    
    
    func checkinabort(url: String){
        
        //POST https://challonge.com/api/tournaments/{tournament}/abort_check_in.{json|xml}
        
        var par : [String: AnyObject] = ["api_key":key]
        
        var req = request(.POST, "https://api.challonge.com/v1/tournaments/"+url+"/abort_check_in.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                
                println(JSON)
                
        }
    }
    
    
    func checkinfinish(url: String){
        
        //POST https://challonge.com/api/tournaments/{tournament}/process_check_ins.{json|xml}
        var par : [String: AnyObject] = ["api_key":key]
        
        var req = request(.POST, "https://api.challonge.com/v1/tournaments/"+url+"/process_check_ins.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                
                println(JSON)
                
        }
    }
    
    

    
    /*


    self.map = {"The Crystal Scar":8,
    "Twisted Treeline":10,
    "Summoner's Rift":11,
    "Howling Abyss":12}
    
    
    self.pick = {"BLIND PICK":1,
    "DRAFT MODE":2,
    "ALL RANDOM":4,
    "TOURNAMENT DRAFT":6}

    
    self.spec = {'NONE':'NONE',
    'ALL':'ALL',
    'LOBBY':'LOBBYONLY'}

    */
    func tournamentcode(name:String, pass:String) -> String{
    
        var code = "pvpnet://lol/customgame/joinorcreate/map11/pick6/team5/specALL/"
        
        let plainString = "{\"name\":\"\(name)\",\"extra\":\"\(name)\",\"password\":\"\(pass)\",\"report\":\"\"}"
       
        println(plainString)
        
        let plainData = (plainString as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
        let base64String = plainData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        println(code+base64String)
        return code + base64String
    
    }
    
    
    func solotournamentcode(name:String, pass:String) -> String{
        
        var code = "pvpnet://lol/customgame/joinorcreate/map11/pick1/team5/specALL/"
        
        let plainString = "{\"name\":\"\(name)\",\"extra\":\"\(name)\",\"password\":\"\(pass)\",\"report\":\"\"}"
        
        println(plainString)
        
        let plainData = (plainString as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
        let base64String = plainData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        println(code+base64String)
        return code + base64String
        
    }

    
    
    func findmember(){
    
    
        
        
    
    }
   
    
   
    
    
}