//
//  lol_api.swift
//  Cteemo
//
//  Created by bintao on 15/2/5.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

var LolAPIGlobal: LolAPI = LolAPI()

class LolAPI: NSObject{
    
    let key = "dbb5810d-9b30-4d9d-85d0-1f58aadb8ec6"
    
    var lolID :String?
    var lolRank: String?
    var lolName: String?
    var lolLevel : String?
    var lolIcon : String?
    var lolpatch : String?
    
    func setUp(){
        
        var data:[String: AnyObject] = DataManager.getLOLInfo()
        lolID = data["lolID"] as? String
        lolLevel = data["lolLevel"] as? String
        lolRank = data["lolRank"] as? String
        lolName = data["lolName"] as? String
        lolIcon = data["lolIcon"] as? String
        lolpatch = data["lolpatch"] as? String
    }
    
    func packaging()->[String: AnyObject?]{
        var data:[String: AnyObject?] = ["lolID": lolID,"lolName":lolName,"lolRank":lolRank,"lolLevel": lolLevel,"lolIcon":lolIcon,"lolpatch":lolpatch]
        return data
    }

    func cleanUserData(){
        lolID = ""
        lolName = ""
        lolRank = ""
        lolLevel = ""
        lolIcon = ""
        lolpatch = ""
        DataManager.saveUserInfoToLocal(packaging())
    }
    
    func saveLOLData(){
        
        var data:[String: AnyObject?] = packaging()
        
        DataManager.saveLOLInfoToLocal(data)
        
    }
    //get LOL summoner ID and level
    func getSummonerID(lolName : String, loginView: Login_SchoolAndPhoto){
        
        var req = ARequest(prefix: key, method: requestType.GET)
        req.server = "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/" + lolName + "?api_key="
        req.delegate = loginView
        req.sendRequest()
    }

    
    func getIDresult(result: [String: AnyObject]){
        if result["id"] != nil{
          
            
            println(result)
            
            if result["id"]? != nil {
                var idd: Int! = result["id"] as? Int!
                self.lolID = "\(idd)"
            }
            
            if result["name"]? != nil {
                LolAPIGlobal.lolName = result["name"] as? String
            }
            
            if result["profileIconId"]? != nil {
                LolAPIGlobal.lolIcon = result["profileIconId"] as? String
            }
            
            if result["summonerLevel"]? != nil {
                var idd: Int! = result["summonerLevel"] as? Int!
                self.lolLevel = "\(idd)"
            }
        
            self.saveLOLData()
            
            if(result["summonerLevel"] as Int == 30){
            self.getSummonerLeague(lolID!)
            }
        }
        
    }
    
    // get Summoner league data
    func getSummonerLeague(lolID :String){
        var url = "https://na.api.pvp.net/api/lol/na/v2.5/league/by-summoner/"+lolID+"/entry?api_key="+key
        Alamofire.request(.GET,url)
            .responseJSON { (_, _, JSON, _) in
                var result: [String: AnyObject] = JSON as [String: AnyObject]
                self.getLeagueResult(result)
        }
    }
    
    func getLeagueResult(result: [String: AnyObject]){
        
       // (result["entries"] as [String: AnyObject])["entries"]
        println(result[LolAPIGlobal.lolID!])
        println (((result[LolAPIGlobal.lolID!] as [AnyObject])[0] as [String: AnyObject])["tier"])
        
        var tier : String = (((result[LolAPIGlobal.lolID!] as [AnyObject])[0] as [String: AnyObject])["tier"] as String) + " "+(((((result[LolAPIGlobal.lolID!] as [AnyObject])[0] as [String: AnyObject])["entries"] as [AnyObject])[0] as [String: AnyObject])["division"] as String)
        
        print(tier)
        
        LolAPIGlobal.lolRank = tier
        UserInfoGlobal.saveUserData()
    
    }
    
    
    func getlolvision(){
        let url = "http://ddragon.leagueoflegends.com/realms/na.json"
        Alamofire.request(.GET,url)
            .responseJSON { (_, _, JSON, _) in
                var result: [String: AnyObject] = (JSON as [String: AnyObject])["n"] as [String: AnyObject]
                if result["profileicon"]? != nil {
                    
                    LolAPIGlobal.lolpatch = result["profileicon"] as? String
                    UserInfoGlobal.saveUserData()
                }
        }
        
    }
    
    
    func getlolIcon(vision : String , id :String)->UIImage{
        
        var image:UIImage!
        var str = "http://ddragon.leagueoflegends.com/cdn/"+vision+"/img/profileicon/"+id+".png"
        var url = NSURL(string: str)
        var data: NSData = NSData(contentsOfURL: url! as NSURL, options: nil, error: nil)!
        image = UIImage(data: data)
        image = image.roundCornersToCircle()
        return image
        
    }
    
    
    
}
