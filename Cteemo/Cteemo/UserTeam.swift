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
    var memberCount = 0
    var memberIcon : [AnyObject] = [AnyObject]()
    var memberName :[AnyObject] = [AnyObject]()
    var memberId :[AnyObject] = [AnyObject]()

    var captainId : String = ""
    var captainName : String = ""
    
    
    var captainIcon : UIImage?
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
        
        captainName  = data["captainName"] as String
        captainId = data["captainId"] as String
        
        saveUserData()
        
    }
    
    func packaging()->[String: AnyObject]{
        var data:[String: AnyObject] = ["team_Intro" : team_Intro,"teamID":teamID,"teamName" :teamName,"iscaptain": iscaptain, "captainName" : captainName ,"captainId" : captainId]
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
       
        var req = request(.GET, "http://54.149.235.253:5000/my_team/lol")
            .responseJSON { (_, _, JSONdata, _) in
               
                let myjson = JSON(JSONdata!)
                
                if let captainIcon = myjson["captain"][0]["profile_icon"].string{
                   
                    ImageLoader.sharedLoader.imageForUrl(captainIcon, completionHandler:{(image: UIImage?, url: String) in
                        
                        if image? != nil {
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
                    if self.captainId == UserInfoGlobal.profile_ID{
                    
                    self.iscaptain = "yes"
                    
                    }
                    else{
                    self.iscaptain = "no"
                    }
                    
                }
                
                println(self.captainName)
                println(self.captainId)
                
                if let name = myjson["teamName"].string{
                    
                    self.teamName = name
                    
                }else{ self.teamName = ""}
                
                if let id = myjson["id"].string{
                    
                    self.teamID = id
                    
                }else{ self.teamID = ""}
                
                if let icon = myjson["teamIcon"].string{
                    
                    self.teamicon_link = icon
                    
                }else{ self.teamicon_link = ""}
                
                
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

    }

    func deletemember(index: Int){
    
        self.memberName.removeAtIndex(index)
        self.memberId.removeAtIndex(index)
        self.memberIcon.removeAtIndex(index)
        self.memberCount = self.memberCount - 1
    
    }
    
    func gotResult(result: [String: AnyObject]) {
        
            TeamInfoGlobal.iscaptain = "no"
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
        
            if result["id"]? != nil{
                var captain = (((result["captain"] as [AnyObject])[0] as [String: AnyObject])["profile_id"] as String)
        
                if(captain == UserInfoGlobal.profile_ID){
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
        captainName = ""
        captainId = ""
        var data:[String: AnyObject] = packaging()
        DataManager.saveTeamInfoToLocal(data)
        self.memberCount = 0
        self.memberIcon.removeAll()
        self.memberId.removeAll()
        self.memberName.removeAll()

        
    }
    
}