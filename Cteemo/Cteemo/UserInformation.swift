
//
//  UserInformation.swift
//  WalkingEmpire
//
//  Created by Kedan Li on 14/11/22.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit

var UserInfo: UserInformation = UserInformation()

class UserInformation: NSObject {
   
    // User profile
    var email: String = ""
    var name: String = ""
    var fbid: String = ""
    var accessToken: String = ""
    var gender: String = ""
    var school: String = ""
    var intro: String = ""
    var lolID :String = ""
    var lolRank: String = ""
    var lolName: String = ""
    var profile_ID: String = ""
    var lolLevel : Int = 0
    var lolIcon : String = ""
    var icon: UIImage!
    
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
        name = data["name"] as String
        fbid = data["fbid"] as String
        accessToken = data["accessToken"] as String
        
        email = data["email"] as String
        lolID = data["lolID"] as String
        gender = data["gender"] as String
        school = data["school"] as String
        intro = data["intro"] as String
        
        lolLevel = data["lolLevel"] as Int
        lolRank = data["lolRank"] as String
        lolName = data["lolName"] as String
        profile_ID = data["profile_ID"] as String
        lolIcon = data["lolIcon"] as String
        
        icon = DataManager.getUserIconFromLocal()
    }
    
    //change user data and save

    
    func packaging()->[String: AnyObject]{
        var data:[String: AnyObject] = ["name": name, "fbid": fbid, "accessToken": accessToken, "email": email, "gender": gender, "lolID": lolID, "school": school, "intro": intro,"lolName":lolName,"lolRank":lolRank,"profile_ID":profile_ID,"lolLevel": lolLevel,"lolIcon":lolIcon]
        return data
    }
    
    func saveUserIcon(){
        if icon != nil{
            DataManager.saveUserIconFromLocal(UserInfo.icon)
        }
    }
    
    func getIconFromLocal(){
        icon = DataManager.getUserIconFromLocal()
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
        
       /* var req = ARequest(prefix: "/profile", method: "GET", data: ["token": self.accessToken])
        req.delegate = self
        req.sendRequest()*/
    }
    
    //Save User Data to local
    
    func saveUserData(){
        var data:[String: AnyObject] = packaging()
        DataManager.saveUserInfoToLocal(data)
    }
    
    //user logout, remove all local data
    func cleanUserData(){
        email = ""
        name = ""
        fbid = ""
        accessToken = ""
        lolID = ""
        gender = ""
        school = ""
        intro = ""
        lolName = ""
        lolRank = ""
        profile_ID = ""
        lolLevel = 0
        lolIcon = ""
        DataManager.saveUserInfoToLocal(packaging())
    }
    
}
