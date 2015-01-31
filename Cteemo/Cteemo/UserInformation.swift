
//
//  UserInformation.swift
//  WalkingEmpire
//
//  Created by Kedan Li on 14/11/22.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit

var UserInfo: UserInformation = UserInformation()

class UserInformation: NSObject ,RequestResultDelegate {
   
    var email: String = ""
    var name: String = ""
    var fbid: String = ""
    var accessToken: String = ""
    var lolID: String = ""
    var gender: String = ""
    var school: String = ""
    var intro: String = ""

    
    var icon: UIImage!
    
    //check if the user is logined
    func userIsLogined()->Bool{
        if email == "" || name == "" || accessToken == "" {
            return false
        }else{
            return true
        }
    }
    
    //setUp the local user data
    func setUp(){
        
        var data:[String: AnyObject] = DataManager.getUserInfo()
        setUserData(data)
        
    }
    
    //change user data and save

    func setUserData(data: [String: AnyObject]){
        
        name = data["name"] as String
        fbid = data["fbid"] as String
        accessToken = data["accessToken"] as String
        email = data["email"] as String
        lolID = data["lolID"] as String
        gender = data["gender"] as String
        school = data["school"] as String
        intro = data["intro"] as String
        
        saveUserData()
    }
    
    func packaging()->[String: AnyObject]{
        var data:[String: AnyObject] = ["name": name, "fbid": fbid, "accessToken": accessToken, "email": email, "gender": gender, "lolID": lolID, "school": school]
        return data
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
        
        var req = ARequest(prefix: "/profile", method: "GET", data: ["token": self.accessToken])
        req.delegate = self
        req.sendRequest()
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
        DataManager.saveUserInfoToLocal(packaging())
    }
    
}
