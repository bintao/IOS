
//
//  UserInformation.swift
//  WalkingEmpire
//
//  Created by Kedan Li on 14/11/22.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit

var UserInfoGlobal: UserInformation = UserInformation()

class UserInformation: NSObject, RequestResultDelegate{
   
    // User profile
    var email: String!
    var name: String!
    var fbid: String!
    var accessToken: String!
    var gender: String!
    var school: String!
    var intro: String!
    var profile_icon_Link: String!
    var tokenVaild : String!
    var profile_ID: String!
    
    var rongToken: String!
    //var iscaptain: String?
    
    var userDefault = NSUserDefaults.standardUserDefaults()
    
    var icon: UIImage?
    
    //check if the user is logined
    func userIsLogined()->Bool{
        
        if accessToken == nil {
            return false
        }else{
            return true
        }
    }
    
    //setUp the local user data
    func setUp(){
        
        if userDefault.objectForKey("name") != nil {
        
        self.name = userDefault.objectForKey("name") as String
        
        }
        
        if userDefault.objectForKey("fbid") != nil {
            
            self.fbid = userDefault.objectForKey("fbid") as String
            
        }
        
        if userDefault.objectForKey("accessToken") != nil {
            
            self.accessToken = userDefault.objectForKey("accessToken") as String
            
        }
        
        if userDefault.objectForKey("email") != nil {
            
            self.email = userDefault.objectForKey("email") as String
            
        }
        
        if userDefault.objectForKey("gender") != nil {
            
            self.gender = userDefault.objectForKey("gender") as String
            
        }
        
        if userDefault.objectForKey("school") != nil {
            
            self.school = userDefault.objectForKey("school") as String
            
        }
        
        if userDefault.objectForKey("intro") != nil {
            
            self.intro = userDefault.objectForKey("intro") as String
            
        }
        
        if userDefault.objectForKey("profile_ID") != nil {
            
            self.profile_ID = userDefault.objectForKey("profile_ID") as String
            
        }
        
        if userDefault.objectForKey("profile_icon_Link") != nil {
            
            self.profile_icon_Link = userDefault.objectForKey("profile_icon_Link") as String
            
        }
        
        if userDefault.objectForKey("rongToken") != nil {
            
            self.rongToken = userDefault.objectForKey("rongToken") as String
            
        }
        
        if userDefault.objectForKey("tokenVaild") != nil {
            
            self.tokenVaild = userDefault.objectForKey("tokenVaild") as String
            
        }
        
        icon = DataManager.getUserIconFromLocal()
        
    }
    
    //change user data and save

    
    func uploadUserIcon(){
        if icon != nil{
            var req = ARequest(prefix: "upload_profile_icon", method: requestType.POST)
            req.delegate = self
            req.uploadPhoto("icon.png")
        }
    }
    
    func saveUserIcon(){
        "http://54.149.235.253:5000/upload_profile_icon"

        if icon != nil{
            DataManager.saveUserIconFromLocal(UserInfoGlobal.icon!)
        }
    }
    
    func getIconFromLocal(){
        icon = DataManager.getUserIconFromLocal()
    }
    
    func getIconFromServer(){
        
        if profile_icon_Link != nil {
        ImageLoader.sharedLoader.imageForUrl(profile_icon_Link, completionHandler:{(image: UIImage?, url: String) in
            println(url)
            if image? != nil {
                self.icon = image
                self.saveUserIcon()
            }
            else {
                self.icon = UIImage(named: "error.png")!
            }})
        }
    }
    
    func gotResult(prefix: String, result: [String : AnyObject]) {
        
    }
    //upload user information to the server
    
    //download user information from the server
    func updateUserInfo(){
        var req = ARequest(prefix: "profile", method: requestType.GET)
        req.delegate = self
        req.sendRequestWithToken(UserInfoGlobal.accessToken)

    }
    
    func gotResult(prefix: String, result: AnyObject) {
        
        if prefix == "profile"{
        
            
            if ((result as? [String: AnyObject])?["message"] as? String)?.rangeOfString("Unauthorized")?.isEmpty != nil {
            UserInfoGlobal.tokenVaild = "false"
            }
            else {UserInfoGlobal.tokenVaild = "true"}
            if result["username"]? != nil {
                UserInfoGlobal.name = result["username"] as String
            }
            else{ UserInfoGlobal.name = nil}
            if result["id"]? != nil {
                UserInfoGlobal.profile_ID = result["id"] as String
            }
             else{ UserInfoGlobal.profile_ID = nil}
            if result["intro"]? != nil {
                UserInfoGlobal.intro = result["intro"] as String
            }
            else{ UserInfoGlobal.intro = nil}
            if result["profile_icon"]? != nil {
                UserInfoGlobal.profile_icon_Link = result["profile_icon"] as String
                getIconFromServer()
            }
            if result["school"]? != nil {
                UserInfoGlobal.school = result["school"] as String
            }
            else{ UserInfoGlobal.school = nil}
            
            if result["lolID"]? != nil {
                LolAPIGlobal.lolName = result["lolID"] as String
            }
            
            if result["LOLTeamID"]? != nil {
                TeamInfoGlobal.teamID = result["LOLTeamID"] as String
            }
            else{ TeamInfoGlobal.teamID  = nil}
            
            if result["LOLTeam"]? != nil {
                TeamInfoGlobal.teamName = result["LOLTeam"] as String
            }
            else { TeamInfoGlobal.teamName = nil}
            if result["dotaID"]? != nil{
            LolAPIGlobal.lolRank = result["dotaID"] as String
            }
            else{
                
                LolAPIGlobal.lolRank = nil
           
            }
            if result["hstoneID"]? != nil{
                
                  LolAPIGlobal.lolID = result["hstoneID"] as String
            }
            else{
            
            LolAPIGlobal.lolID = nil
            
            }
            
            UserInfoGlobal.saveUserData()
            TeamInfoGlobal.saveUserData()
            LolAPIGlobal.saveLOLData()
            
            
        }
    }
    
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    //Save User Data to local
    
    func saveUserData(){
        
        userDefault.setValue(email, forKey: "email")

        userDefault.setValue(name, forKey: "name")
        
        userDefault.setValue(fbid, forKey: "fbid")
        
        userDefault.setValue(accessToken, forKey: "accessToken")
        
        userDefault.setValue(gender, forKey: "gender")
        
        userDefault.setValue(school, forKey: "school")
        
        userDefault.setValue(intro, forKey: "intro")
        
        userDefault.setValue(profile_ID, forKey: "profile_ID")
        
        userDefault.setValue(profile_icon_Link, forKey: "profile_icon_Link")
        
        userDefault.setValue(tokenVaild, forKey: "tokenVaild")
        
        userDefault.setValue(rongToken, forKey: "rongToken")
        

        userDefault.synchronize()

    }
    
    //user logout, remove all local data
    func cleanUserData(){
        
        
        self.email = nil
        self.name = nil
        self.fbid = nil
        self.accessToken = nil
        self.gender = nil
        self.school = nil
        self.intro = nil
        self.profile_ID = nil
        self.profile_icon_Link = nil
        self.rongToken = nil
        self.tokenVaild = nil
        self.icon = nil
        
        userDefault.removeObjectForKey("email")
        userDefault.removeObjectForKey("name")
        userDefault.removeObjectForKey("fbid")
        userDefault.removeObjectForKey("accessToken")
        userDefault.removeObjectForKey("gender")
        userDefault.removeObjectForKey("school")
        userDefault.removeObjectForKey("intro")
        userDefault.removeObjectForKey("profile_ID")
        userDefault.removeObjectForKey("profile_icon_Link")
        userDefault.removeObjectForKey("tokenVaild")
        userDefault.removeObjectForKey("rongToken")
        
        
        userDefault.synchronize()
        
        
        DataManager.deleFileInLocal("icon.png")
        DataManager.deleFileInLocal("lolicon.png")
        DataManager.deleFileInLocal("teamicon.png")
    }
    
   

}
