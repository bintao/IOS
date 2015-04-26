//
//  UserTeam.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/6.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//


import UIKit

var TeamInfoGlobal: UserTeam = UserTeam()

class UserTeam: NSObject{
    
    // User team
    var findplayer = false
    
    var team_isschool: String = ""
    
    var teamName: String!
    var teamID : String!
    var team_Intro : String!
    var teamicon_link : String!
    var iscaptain : String!
    var captainId : String!
    var captainName : String!
    
    var teamicon: UIImage?
    
    // all the memebers inthe team and their informations
    // get each icon as UIIMage from url and save in the array
    // save to local
    
    var memberCount = 0
    var memberIcon : [AnyObject] = [AnyObject]()
    var memberName :[AnyObject] = [AnyObject]()
    var memberId :[AnyObject] = [AnyObject]()
    

    var captainIcon : UIImage?
    var icon :UIImage?
    
    var userDefault = NSUserDefaults.standardUserDefaults()
    

    func setUp(){
      
        if userDefault.objectForKey("teamName") != nil {
            
            self.teamName = userDefault.objectForKey("teamName") as! String
            
        }
        
        if userDefault.objectForKey("teamID") != nil {
            
            self.teamID = userDefault.objectForKey("teamID") as! String
            
        }
        
        
        if userDefault.objectForKey("team_Intro") != nil {
            
            self.team_Intro = userDefault.objectForKey("team_Intro") as! String
            
        }
        
        if userDefault.objectForKey("iscaptain") != nil {
            
            self.iscaptain = userDefault.objectForKey("iscaptain") as! String
            
        }
        
        if userDefault.objectForKey("teamicon_link") != nil {
            
            self.teamicon_link = userDefault.objectForKey("teamicon_link") as! String
            
        }
        
        if userDefault.objectForKey("captainName") != nil {
            
            self.captainName = userDefault.objectForKey("captainName") as! String
            
        }
        
        
        if userDefault.objectForKey("captainId") != nil {
            
            self.captainId = userDefault.objectForKey("captainId") as! String
            
        }

        
    }
    
    //change user data and save
  
    func saveTeamIcon(){
        if teamicon != nil{
            DataManager.saveTeamIconFromLocal(self.teamicon!)
        }
    }
    
    func getIconFromLocal(){
        teamicon = DataManager.getUserIconFromLocal()
    }
    
    func getIconFromServer(){
        
        if self.teamicon_link != nil {
        ImageLoader.sharedLoader.imageForUrl(self.teamicon_link, completionHandler:{(image: UIImage?, url: String) in
            println(url)
            if image != nil {
                self.teamicon = image
                self.saveTeamIcon()
            }
            else {
                self.teamicon = UIImage(named: "error.png")!
            }})
        }
        
    }
    
    func gotResult(prefix: String, result: [String : AnyObject]) {
    
    }
    //upload user information to the server
    
    func uploadTeamInfo(){
        
        if UserInfoGlobal.accessToken != nil {
        var manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = [
            "token": UserInfoGlobal.accessToken
        ]

        var req = request(.GET, "http://54.149.235.253:5000/my_team/lol")
            .responseJSON { (_, _, JSONdata, _) in
               
                if JSONdata != nil {
                let myjson = JSON(JSONdata!)
                
                if let captainIcon = myjson["captain"][0]["profile_icon"].string{
                   
                    ImageLoader.sharedLoader.imageForUrl(captainIcon, completionHandler:{(image: UIImage?, url: String) in
                        
                        if image != nil {
                            self.captainIcon = image
                        }
                        else {
                            self.captainIcon = UIImage(named: "error.png")!
                        }})
                } else {
                    self.captainIcon = UIImage(named: "error.png")!
                }
                 if let name = myjson["captain"][0]["username"].string{
                
                    self.captainName = name
                }
                
                if let name = myjson["captain"][0]["profile_id"].string{
                    
                    self.captainId = name
                    if UserInfoGlobal.profile_ID != nil && self.captainId == UserInfoGlobal.profile_ID{
                    self.iscaptain = "yes"
                    
                    }
                    
                }
                
                
                if let name = myjson["teamName"].string{
                    
                    self.teamName = name
                    
                }else{ self.teamName = nil}
                
                if let id = myjson["id"].string{
                    
                    self.teamID = id
                    
                }else{ self.teamID = nil}
                
                if let icon = myjson["teamIcon"].string{
                    
                    self.teamicon_link = icon
                    
                }else{ self.teamicon_link = nil}
                
                
                println(self.teamName)
                println(self.teamID)
                println(self.teamicon_link)
                
                TeamInfoGlobal.saveUserData()
                self.getIconFromServer()
                
                println(myjson["members"].array)
                
                if let member = myjson["members"].array
                {
                    if member.count > 0{
                        self.memberCount = member.count
                        for i in 0...member.count-1{
                            if let iconurl = myjson["members"][i]["profile_icon"].string
                            {
                                if self.memberIcon.count < self.memberCount{
                                    self.memberIcon.append(iconurl)
                                }
                                else {
                                    self.memberIcon[i] = iconurl
                                }
                                
                            }else{
                                
                             self.memberIcon.append("")
                            
                            }
                            
                            if let name = myjson["members"][i]["username"].string{
                               
                                
                                if self.memberName.count < self.memberCount{
                                    self.memberName.append(name)
                                }
                                else {
                                    self.memberName[i] = name
                                }
                            
                            }
                            else{
                            
                             self.memberName.append("noName")
                            }
                            
                            println(self.memberName[i])
                            
                            
                            if let id = myjson["members"][i]["profile_id"].string{
                                
                                if self.memberId.count < self.memberCount{
                                    self.memberId.append(id)
                                }
                                else {
                                    self.memberId[i] = id
                                }
                                
                            }
                            else{
                                self.memberId.append("noID")
                            }

                            
                        }
                    
                    }
                    
                   
                }
                }
        }// end request
            
        }// no token

    }

    func deletemember(index: Int){
    
        self.memberName.removeAtIndex(index)
        self.memberId.removeAtIndex(index)
        self.memberIcon.removeAtIndex(index)
        self.memberCount = self.memberCount - 1
    
    }
    
    func gotResult(result: [String: AnyObject]) {
        
            if result["id"] as? String != nil {
                TeamInfoGlobal.teamID = result["id"] as! String
            }
            
            else {TeamInfoGlobal.teamID = nil}
        
            if result["teamName"] as? String != nil {
                TeamInfoGlobal.teamName = result["teamName"] as! String
            }
                
            else {TeamInfoGlobal.teamName = nil}
        
            if result["teamIntro"] as? String != nil {
                TeamInfoGlobal.team_Intro = result["teamIntro"] as! String
            }
                
            else {TeamInfoGlobal.team_Intro = nil}
        
            if result["teamIcon"] as? String != nil {
                
                self.teamicon_link = result["teamIcon"] as! String
            }
                
            else {self.teamicon_link  = nil}
        
            if result["id"] as? String != nil{
                
                var captain = (((result["captain"] as! [AnyObject])[0] as! [String: AnyObject])["profile_id"] as! String)
                
                if(captain == UserInfoGlobal.profile_ID){
                    TeamInfoGlobal.iscaptain = "yes"
                }else{
                 TeamInfoGlobal.iscaptain = nil
                
                }
            }
        
        TeamInfoGlobal.saveUserData()
        self.getIconFromServer()

    }
    
    
    
    //Save User Data to local
    
    func saveUserData(){
        
        
        userDefault.setValue(teamName, forKey: "teamName")
        userDefault.setValue(teamID, forKey: "teamID")
        userDefault.setValue(team_Intro, forKey: "team_Intro")
        userDefault.setValue(iscaptain, forKey: "iscaptain")
        userDefault.setValue(teamicon_link, forKey: "teamicon_link")
        userDefault.setValue(captainName, forKey: "captainName")
        userDefault.setValue(captainId, forKey: "captainId")
        
        userDefault.synchronize()
        
    }
    
    //user logout, remove all local data
    func cleanUserData(){
        
        
        
        self.teamName = nil
        self.teamID = nil
        self.team_Intro = nil
        self.iscaptain = nil
        self.teamicon_link = nil
        self.captainName = nil
        self.captainId = nil
        self.teamicon = nil
        
        userDefault.removeObjectForKey("teamName")
        userDefault.removeObjectForKey("teamID")
        userDefault.removeObjectForKey("team_Intro")
        userDefault.removeObjectForKey("iscaptain")
        userDefault.removeObjectForKey("teamicon_link")
         userDefault.removeObjectForKey("captainName")
        userDefault.removeObjectForKey("captainId")
        userDefault.synchronize()
       
        self.memberCount = 0
        self.memberIcon.removeAll()
        self.memberId.removeAll()
        self.memberName.removeAll()

        
    }
    
}