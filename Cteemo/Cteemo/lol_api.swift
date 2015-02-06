//
//  lol_api.swift
//  Cteemo
//
//  Created by bintao on 15/2/5.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

var lolapi: lol_api = lol_api()

class lol_api: NSObject{
    
    let key = "dbb5810d-9b30-4d9d-85d0-1f58aadb8ec6"
    
    //get summoner ID and level
    func getSummonerID(lolName : String){
        var url = "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/"+lolName + "?api_key="+key
        
        Alamofire.request(.GET,url)
            .responseJSON { (_, _, JSON, _) in
                
                self.getIDresult((JSON as [String: AnyObject])[lolName] as [String: AnyObject])
                
        }
    }
    
    func getIDresult(result: [String: AnyObject]){
        if result["id"] != nil{
            var idd: Int = result["id"] as Int
            UserInfo.lolID = "\(idd)"
            UserInfo.saveUserData()
            println(UserInfo.lolID)
            self.getSummonerLeague(UserInfo.lolID)
            
        }
        
    }
    
    // get Summoner league data
    func getSummonerLeague(lolID :String){
        var url = "https://na.api.pvp.net/api/lol/na/v2.5/league/by-summoner/"+lolID+"/entry?api_key="+key
        Alamofire.request(.GET,url)
            .responseJSON { (_, _, JSON, _) in
                println((JSON as [String: AnyObject])[lolID])
        }
    }
    
    
    
    
    
}
