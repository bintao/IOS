
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
    var email: String?
    var name: String?
    var fbid: String?
    var accessToken: String?
    var gender: String?
    var school: String?
    var intro: String?
    var profile_icon_Link: String?
    
    var profile_ID: String?
    //var iscaptain: String?
    
    
    var icon: UIImage?
    
    //check if the user is logined
    func userIsLogined()->Bool{
        
        if accessToken == "" {
            return false
        }else{
            return true
        }
    }
    
    //setUp the local user data
    func setUp(){
        
        var data:[String: AnyObject] = DataManager.getUserInfo()
        name = data["name"] as? String
        fbid = data["fbid"] as? String
        accessToken = data["accessToken"] as? String
        email = data["email"] as? String
        gender = data["gender"] as? String
        school = data["school"] as? String
        intro = data["intro"] as? String
        profile_ID = data["profile_ID"] as? String
        
        //iscaptain = data["iscpatain"] as? String
        
        profile_icon_Link = data["profile_icon_Link"] as? String

        icon = DataManager.getUserIconFromLocal()
    }
    
    //change user data and save

    
    func packaging()->[String: AnyObject?]{
        var data:[String: AnyObject?] = ["name": name, "fbid": fbid, "accessToken": accessToken, "email": email, "gender": gender, "school": school, "intro": intro,"profile_ID":profile_ID, "profile_icon_Link": profile_icon_Link]
        return data
    }
    
    func saveUserIcon(){
        if icon != nil{
            DataManager.saveUserIconFromLocal(UserInfoGlobal.icon!)
        }
    }
    
    func getIconFromLocal(){
        icon = DataManager.getUserIconFromLocal()
    }
    
    func getIconFromServer(){
        var url = NSURL(string: profile_icon_Link!)
        var data: NSData = NSData(contentsOfURL: url! as NSURL, options: nil, error: nil)!
        icon = UIImage(data: data)

    }
    
    func gotResult(prefix: String, result: [String : AnyObject]) {
        println(result)
    }
    //upload user information to the server
   
    func uploadUserInfo(){

    }
    
    //download user information from the server
    func updateUserInfo(){
        var req = ARequest(prefix: "profile", method: requestType.GET)
        req.delegate = self
        req.sendRequestWithToken(UserInfoGlobal.accessToken!)
    }
    
    func gotResult(prefix: String, result: AnyObject) {
        if prefix == "profile"{
            if result["username"]? != nil {
                UserInfoGlobal.name = result["username"] as? String
            }
            if result["id"]? != nil {
                UserInfoGlobal.profile_ID = result["id"] as? String
            }
            if result["intro"]? != nil {
                UserInfoGlobal.intro = result["intro"] as? String
            }
            if result["profile_icon"]? != nil {
                UserInfoGlobal.profile_icon_Link = result["profile_icon"] as? String
                getIconFromServer()
            }
            if result["school"]? != nil {
                UserInfoGlobal.school = result["school"] as? String
            }
            
            if result["lolID"]? != nil {
                LolAPIGlobal.lolName = result["lolID"] as? String
            }
            
            if result["LOLTeamID"]? != nil {
                TeamInfoGlobal.teamID = result["LOLTeamID"] as? String
            }
            
            if result["LOLTeam"]? != nil {
                TeamInfoGlobal.teamName = result["LOLTeam"] as? String
            }
         UserInfoGlobal.saveUserData()
        }
    }
    
    
    //Save User Data to local
    
    func saveUserData(){
        var data:[String: AnyObject?] = packaging()
        DataManager.saveUserInfoToLocal(data)
    }
    
    //user logout, remove all local data
    func cleanUserData(){
        email = ""
        name = ""
        fbid = ""
        accessToken = ""
        gender = ""
        school = ""
        intro = ""
        profile_ID = ""
        profile_icon_Link = ""
        //iscaptain = ""
        
        DataManager.saveUserInfoToLocal(packaging())
    }
    
}
