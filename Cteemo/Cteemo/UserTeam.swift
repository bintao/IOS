//
//  UserTeam.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/6.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//


import UIKit
import Alamofire

var TeamInfoGlobal: UserTeam = UserTeam()

class UserTeam: NSObject{
    
    // User team
    
    var teamName: String = ""
    var teamID : String = ""
    var team_isschool: String = ""
    var team_Intro : String = ""
    var teamicon_link : String = ""
    
    var iscaptain : String = ""
    var teamicon: UIImage?
    
    // all the memebers inthe team and their informations
    // get each icon as UIIMage from url and save in the array
    // save to local
    
    var memberInfo = [AnyObject]()
    
    var icon :UIImage?
    
    func setUp(){
        
        var data:[String: AnyObject] = DataManager.getUserInfo()
        setUserData(data)
        
    }
    
    //change user data and save
    
    func setUserData(data: [String: AnyObject]){
 
        // team data
        team_Intro = data["team_Intro"] as String
        teamID = data["teamID"] as String
        teamName = data["teamName"] as String
        iscaptain = data["iscaptain"] as String
        teamicon_link = data["teamicon_link"] as String
        saveUserData()
        
    }
    
    func packaging()->[String: AnyObject]{
        var data:[String: AnyObject] = ["team_Intro" : team_Intro,"teamID":teamID,"teamName" :teamName,"iscaptain": iscaptain]
        return data
    }
    
    func saveTeamIcon(){
        if teamicon != nil{
            DataManager.saveTeamIconFromLocal(self.teamicon!)
        }
    }
    
    func getIconFromLocal(){
        teamicon = DataManager.getUserIconFromLocal()
    }
    
    func getIconFromServer(){
        
        ImageLoader.sharedLoader.imageForUrl(self.teamicon_link, completionHandler:{(image: UIImage?, url: String) in
            println(url)
            if image? != nil {
                self.teamicon = image
                self.saveTeamIcon()
            }
            else {
                self.teamicon = UIImage(named: "error.png")!
            }})

        
    }
    
    func gotResult(prefix: String, result: [String : AnyObject]) {
    
    }
    //upload user information to the server
    
    func uploadTeamInfo(){
       
        var req = Alamofire.request(.GET, "http://54.149.235.253:5000/my_team/lol")
            .responseJSON { (_, _, JSON, _) in
                var result: [String: AnyObject] = JSON as [String: AnyObject]
                self.gotResult(result)
        }

    }
    
    func gotResult(result: [String: AnyObject]) {
        
            
            if result["id"]? != nil {
                TeamInfoGlobal.teamID = result["id"] as String
            }
            else {TeamInfoGlobal.teamID = ""}
            if result["teamName"]? != nil {
                TeamInfoGlobal.teamName = result["teamName"] as String
            }
           else {TeamInfoGlobal.teamName = ""}
            if result["teamIntro"]? != nil {
                TeamInfoGlobal.team_Intro = result["teamIntro"] as String
            }
              else {TeamInfoGlobal.team_Intro = ""}
        
            if result["teamIcon"]? != nil {
                
                self.teamicon_link = result["teamIcon"] as String
            }
            else {self.teamicon_link = "" }
        
            if ((result["captain"] as [AnyObject])[0] as [String: AnyObject]) ["profile_icon"]? != nil{
             var captain_icon = ((result["captain"] as [AnyObject])[0] as [String: AnyObject])  ["profile_icon"] as String
            }
        
            if result["id"]? != nil{
                var captain = (((result["captain"] as [AnyObject])[0] as [String: AnyObject])["profile_id"] as String)
        
                if(captain != UserInfoGlobal.profile_ID){
                    TeamInfoGlobal.iscaptain = "no"
                }
                else {
                    TeamInfoGlobal.iscaptain = "yes"
                }
        }
        
        TeamInfoGlobal.saveUserData()
        self.getIconFromServer()

    }
    //download user information from the server
    
    func downloadUserInfo(){
        //InteractingWithServer.getUserProfile(self.accessToken)
      
    }
    
    //Save User Data to local
    
    func saveUserData(){
        
        var data:[String: AnyObject] = packaging()
        
        DataManager.saveTeamInfoToLocal(data)
        
    }
    
    //user logout, remove all local data
    func cleanUserData(){
        
        teamName = ""
        teamID = ""
        team_Intro = ""
        iscaptain = ""
        teamicon_link = ""
        
        var data:[String: AnyObject] = packaging()
        DataManager.saveTeamInfoToLocal(data)
    }
    
}