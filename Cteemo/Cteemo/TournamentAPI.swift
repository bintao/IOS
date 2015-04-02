//
//  TournamentAPI.swift
//  Cteemo
//
//  Created by bintao on 15/2/21.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//


import UIKit
import Foundation
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
    var memberid = 0
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
                if JSON != nil{
                let myjson = SwiftyJSON.JSON(JSON!)
                self.totalnumber = "\(SwiftyJSON.JSON(JSON!).count)"
                var totaltournament = myjson.count
                
                for i in 0...myjson.count-1{
                    if let url = myjson[i]["tournament"]["url"].string
                    {
                    if self.tournamentUrl.count < totaltournament{
                       self.tournamentUrl.append(url)
                    }
                        
                    else{ self.tournamentUrl[i] = url}
                    
                }
                
                if let name = myjson[i]["tournament"]["name"].string{
                    
                    if self.tournamentName.count < totaltournament{
                    self.tournamentName.append(name)
                    }
                    else {
                        self.tournamentName[i] = name
                    }
                }
                    
                if let id = myjson[i]["tournament"]["id"].int{
                    
                    if self.tournamentID.count < totaltournament{
                        
                        self.tournamentID.append(id)
                    }
                    else {
                        self.tournamentID[i] = id
                    }
                    
                }
                    
                if let type = myjson[i]["tournament"]["tournament_type"].string{
                    
                    if self.tournamentType.count < totaltournament{
                        self.tournamentType.append(type)
                    }
                     else {
                        self.tournamentType[i] = type
                     }
                    
                }
                else{
                    self.tournamentType.append("noType")
                }
                    
                    
                if let teams = myjson[i]["tournament"]["participants_count"].int{
                    if self.totalMember.count < totaltournament{
                        self.totalMember.append(teams)
                    }
                    else{
                        
                        self.totalMember[i] = teams
                    }
                }
                    
                if let start = myjson[i]["tournament"]["start_at"].string{
                    if self.startTime.count < totaltournament{
                        self.startTime.append(start)
                    }
                    else {
                        self.startTime[i] = start
                    }
                }
                else{
                 self.startTime.append("noTime")
                }
                    
                if let game = myjson[i]["tournament"]["game_name"].string{
                    if self.gameName.count < totaltournament{
                    self.gameName.append(game)
                    }
                    else{
                    
                    self.gameName[i] = game
                    }
                }
                else {
                    self.gameName.append("noGame")
                }
                    
                    
                if let group = myjson[i]["tournament"]["group_stages_enabled"].int{
                    if self.groupstage.count < totaltournament{
                    self.groupstage.append(group)
                    }
                    else{
                        self.groupstage[i] = group
                    }
                }
                    
                if let max = myjson[i]["tournament"]["signup_cap"].int{
                    if self.maxteam.count < totaltournament{
                    self.maxteam.append(max)
                    }
                    else {
                    
                    self.maxteam[i] = max
                    }
                    
                }
                else{ self.maxteam.append(256)}
                
                    
                }
    
                
                println(self.totalnumber)
        }
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
    func JoinTournament(id: String, name : String)
    {
        var par : [String: AnyObject] = ["api_key":key,"participant[name]":name]
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
    
    
    
    
    func findMemberID(name: String,member :String) {
        var s : Int = 1
        var par : [String: AnyObject] = ["api_key":key]
        var req = Alamofire.request(.GET, "https://api.challonge.com/v1/tournaments/"+name+"/participants.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
             let myjson = SwiftyJSON.JSON(JSON!)
            if myjson.count != 0{
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
             
        }
        self.memberid = s
       
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
    
    
    
    
    func getmatches(url: String,member : Int){
    //GET https://api.challonge.com/v1/tournaments/{tournament}/matches.{json|xml}
        
        var par : [String: AnyObject] = ["api_key":key,"participant_id" : member]
        
        var req = Alamofire.request(.GET, "https://api.challonge.com/v1/tournaments/"+url+"/matches.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                
                println(JSON)
                
                
        }
        
    }
    
    
    func tournamentStart(url: String){
    //POST https://api.challonge.com/v1/tournaments/{tournament}/start.{json|xml}
        
        var par : [String: AnyObject] = ["api_key":key]
        
        var req = Alamofire.request(.POST, "https://api.challonge.com/v1/tournaments/"+url+"/start.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                
                println(JSON)
                
                
                
        }

        
 
    }
    
    
    
    func checkinabort(url: String){
        
        //POST https://challonge.com/api/tournaments/{tournament}/abort_check_in.{json|xml}
        
        var par : [String: AnyObject] = ["api_key":key]
        
        var req = Alamofire.request(.POST, "https://api.challonge.com/v1/tournaments/"+url+"/abort_check_in.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                
                println(JSON)
                
        }
    }
    
    
    func checkinfinish(url: String){
        
        //POST https://challonge.com/api/tournaments/{tournament}/process_check_ins.{json|xml}
        var par : [String: AnyObject] = ["api_key":key]
        
        var req = Alamofire.request(.POST, "https://api.challonge.com/v1/tournaments/"+url+"/process_check_ins.json",parameters:par)
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
    func tournamentcode(name:String, pass:String){
    
        var code = "pvpnet://lol/customgame/joinorcreate/map11/pick6/team5/specALL/"
        
        let url = "54.149.235.253:5000/match_report/lol"
        
        let plainString = "{\"name\":\"\(name)\",\"extra\":\"\(name)\",\"password\":\"\(pass)\",\"report\":\"\(url)\"}"
       
        println(plainString)
        
        let plainData = (plainString as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
        let base64String = plainData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        println(base64String)
        
        println(code+base64String)
    
    }
    
    
    func findmember(){
    
    
        
        
    
    }
   
    
   
    
    
}