
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

    //check if the user is logined
    func userIsLogined()->Bool{
        if email == "" || name == "" || id == "" || accessToken == ""{
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
   /*
    func upadateUserInfo(){
        var data:[String: AnyObject] = ["name": name, "userid": userid, "accessToken": accessToken]
        DataManager.saveUserInfoToLocal(data)
    }
    */
    //user logout, remove all local data
    func logout(){
        var data:[String: AnyObject] = ["name":"","accessToken":"","userid":""]
        DataManager.saveUserInfoToLocal(data)
    }
    
}
