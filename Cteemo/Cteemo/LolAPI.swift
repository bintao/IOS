//
//  lol_api.swift
//  Cteemo
//
//  Created by bintao on 15/2/5.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

var LolAPIGlobal: LolAPI = LolAPI()

class LolAPI: NSObject{
    
    let key = "ada8d21b-db43-414e-a8b3-fe7718de6626"
    
    var lolID :String!
    var lolRank: String!
    
    var lolName: String!
    var lolLevel : String!
    
    var lolIcon : String!
    var lolpatch : String!

    
    var userDefault = NSUserDefaults.standardUserDefaults()
   
    
    func setUp(){
        
        if userDefault.objectForKey("lolID") != nil {
            
            self.lolID = userDefault.objectForKey("lolID") as String
            
        }
        
        if userDefault.objectForKey("lolRank") != nil {
            
            self.lolRank = userDefault.objectForKey("lolRank") as String
            
        }
        
        if userDefault.objectForKey("lolName") != nil {
            
            self.lolName = userDefault.objectForKey("lolName") as String
            
        }
        
        if userDefault.objectForKey("lolLevel") != nil {
            
            self.lolLevel = userDefault.objectForKey("lolLevel") as String
            
        }
        
        if userDefault.objectForKey("lolIcon") != nil {
            
            self.lolIcon = userDefault.objectForKey("lolIcon") as String
            
        }
        
        if userDefault.objectForKey("lolpatch") != nil {
            
            self.lolpatch = userDefault.objectForKey("lolpatch") as String
            
        }
        
    
    }
    
    
    func cleanUserData(){
        
        self.lolIcon = nil
        self.lolID = nil
        self.lolName = nil
        self.lolLevel = nil
        self.lolRank = nil
        
        userDefault.removeObjectForKey("lolID")
        userDefault.removeObjectForKey("lolName")
        
        userDefault.removeObjectForKey("lolRank")
        userDefault.removeObjectForKey("lolLevel")
        
        userDefault.removeObjectForKey("lolIcon")
      
        userDefault.synchronize()

    }
    
    func saveLOLData(){
        
        
        userDefault.setValue(lolID, forKey: "lolID")
        
        userDefault.setValue(lolName, forKey: "lolName")
        userDefault.setValue(lolRank, forKey: "lolRank")
        
        userDefault.setValue(lolLevel, forKey: "lolLevel")
        userDefault.setValue(lolIcon, forKey: "lolIcon")
        
        userDefault.synchronize()
        
    }
    
    
    
    //get LOL summoner ID and level
    func getSummonerID(lolName : String, loginView: Login_SchoolAndPhoto){
        
        var req = ARequest(prefix: key, method: requestType.GET)
        req.server = "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/" + lolName + "?api_key="
        req.delegate = loginView
        req.sendRequest()
    }
    
    
    
    
    
    func uploadlolinfo(){
    
        if self.lolName != nil {
            var url = "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/"+self.lolName+"?api_key="+key
            request(.GET,url)
                .responseJSON { (_, _, JSON, _) in
                    if JSON as [String: AnyObject]? != nil{
                        var result: [String: AnyObject] = JSON as [String: AnyObject]
                        self.getIDresult(result)
                    }
            }

        
        }

    }
    
    
    
    func uploadlolid(){
    
        if self.lolName != nil {
            var url = "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/"+self.lolName+"?api_key="+key
            request(.GET,url)
                .responseJSON { (_, _, JSON, _) in
                    if JSON as [String: AnyObject]? != nil{
                        var result: [String: AnyObject] = JSON as [String: AnyObject]
                        if result["id"]? != nil{
                            
                            println(result)
                            
                            if result["id"]? != nil {
                                var idd: Int! = result["id"] as? Int!
                                self.lolID = "\(idd)"
                            }
                            else {LolAPIGlobal.lolID = nil}
                          
                            self.saveLOLData()
                        }
                    }
            }
            
            
        }

    
    
    }
    
    func getIDresult(result: [String: AnyObject]){
       
        if result["id"]? != nil{
          
            println(result)
            
            if result["id"]? != nil {
                var idd: Int! = result["id"] as? Int!
                self.lolID = "\(idd)"
            }
            else {LolAPIGlobal.lolID = nil}
            
            if result["name"]? != nil {
                LolAPIGlobal.lolName = result["name"] as String
            }
            else {LolAPIGlobal.lolName = nil}
            
            if result["profileIconId"]? != nil {
                var iconid: Int! = result["profileIconId"] as? Int!
                
                var str = "http://ddragon.leagueoflegends.com/cdn/"+LolAPIGlobal.lolpatch+"/img/profileicon/"+"\(iconid)"+".png"
                self.lolIcon = str
            }
            else {LolAPIGlobal.lolIcon = nil}
            
            if result["summonerLevel"]? != nil {
                var levelid: Int! = result["summonerLevel"] as Int!
                self.lolLevel = "\(levelid)"
            }
            else {LolAPIGlobal.lolLevel = nil}
        
            self.saveLOLData()
            
            if(result["summonerLevel"] as Int == 30){
            self.getSummonerLeague(lolID)
            }
            else {
            LolAPIGlobal.lolRank = nil
            
            }
        }
        
    }
    
    
    // get Summoner league data
    func getSummonerLeague(lolID :String){
        var url = "https://na.api.pvp.net/api/lol/na/v2.5/league/by-summoner/"+lolID+"/entry?api_key="+key
        request(.GET,url)
            .responseJSON { (_, _, JSON, _) in
                if JSON as [String: AnyObject]? != nil{
                var result: [String: AnyObject] = JSON as [String: AnyObject]
                self.getLeagueResult(result)
                }
        }
    }
    
    
    
    func getLeagueResult(result: [String: AnyObject]){
        
       // (result["entries"] as [String: AnyObject])["entries"]
        println (((result[LolAPIGlobal.lolID] as [AnyObject])[0] as [String: AnyObject])["tier"])
        if (((result[LolAPIGlobal.lolID] as [AnyObject])[0] as [String: AnyObject])["tier"]? != nil){
            var tier : String = (((result[LolAPIGlobal.lolID] as [AnyObject])[0] as [String: AnyObject])["tier"] as String) + " "+(((((result[LolAPIGlobal.lolID] as [AnyObject])[0] as [String: AnyObject])["entries"] as [AnyObject])[0] as [String: AnyObject])["division"] as String)
            
            println(tier)
            
            LolAPIGlobal.lolRank = tier
            LolAPIGlobal.saveLOLData()
        }
        else {
        
            LolAPIGlobal.lolRank = nil
            LolAPIGlobal.saveLOLData()
        }
      
    
    }
    
    
    func getlolvision(){
        let url = "http://ddragon.leagueoflegends.com/realms/na.json"
       request(.GET,url)
            .responseJSON { (_, _, JSON, _) in
                if JSON != nil{
                
                var result: [String: AnyObject] = (JSON as [String: AnyObject])["n"] as [String: AnyObject]
                    
                    if result["profileicon"]? != nil {
                        LolAPIGlobal.lolpatch = result["profileicon"] as String
                        LolAPIGlobal.saveLOLData()
                        println(LolAPIGlobal.lolpatch)
                    }
                }
        }
        
    }
    
      func getmatchhistory(){
    
        let url = "https://na.api.pvp.net/api/lol/na/v1.3/game/by-summoner/25350780/recent?api_key="+self.key
        println(url)
       request(.GET,url)
            .responseJSON { (_, _, JSONdata, _) in
                if JSONdata != nil{
                 println(JSON)
                    if JSONdata != nil{
                         let myjson = JSON(JSONdata!)
                        if let url = myjson["tournament"]["url"].string
                        {
                        }
                    }
                }
        }
        
    }
    
        

        
}
