//
//  UserTeam.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/6.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import Foundation

var TeamInfo: UserTeam = UserTeam()

class UserTeam: NSObject{
    
    // User team
    
    var teamName: String = ""
    var teamID : String = ""
    var team_isschool: Bool!
    var team_Intro : String = ""
    var teamicon: UIImage!
    
    
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
        
        saveUserData()
    }
    
    func packaging()->[String: AnyObject]{
        var data:[String: AnyObject] = ["team_Intro" : team_Intro,"teamID":teamID,"teamName" :teamName]
        return data
    }
    
    func saveUserIcon(){
        if teamicon != nil{
            DataManager.
        }
    }
    
    func getIconFromLocal(){
        teamicon = DataManager.getUserIconFromLocal()
    }
    
    func gotResult(prefix: String, result: [String : AnyObject]) {
        println(result)
    }
    //upload user information to the server
    
    func uploadUserInfo(){
        
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
        DataManager.saveTeamInfoToLocal(data)
    }
    
}