
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
   
    var email: String = ""
    var name: String = ""
    var id: String = ""
    var accessToken: String = ""
    var password: String = ""
    
    //check if the user is logined
    func userIsLogined()->Bool{
        if email == "" || name == "" || id == "" || accessToken == "" {
            return false
        }else{
            return true
        }
    }
    
    //setUp the local user data
    func setUp(){
        
        var data:[String: AnyObject] = DataManager.getUserInfo()
        name = data["name"] as String
        id = data["userid"] as String
        accessToken = data["accessToken"] as String
        
    }
   
    //update user information with the server

    func upadateUserInfo(){
        var data:[String: AnyObject] = ["name": name, "id": id, "accessToken": accessToken, "email": email]
        DataManager.saveUserInfoToLocal(data)
    }
    
    
    //user Login   
    
    func setUserData(email: String, name: String, accessToken:String, id: String){
        self.email = email
        self.name = name
        self.accessToken = accessToken
        self.id = id
        
        saveUserData()
    }
    
    //Save User Data to local
    
    func saveUserData(){
        var data:[String: AnyObject] = ["name":name,"accessToken":accessToken,"id":id,"name":name]
        DataManager.saveUserInfoToLocal(data)
    }
    
    //user logout, remove all local data
    func cleanUserData(){
        var data:[String: AnyObject] = ["name":"","accessToken":"","id":"","email":""]
        DataManager.saveUserInfoToLocal(data)
    }
    
}
