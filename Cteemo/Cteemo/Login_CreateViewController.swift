//
//  Login_CreateViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/1/24.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

class Login_CreateViewController: UIViewController {
    
    
    @IBOutlet var email: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet weak var back: UIButton!
    
    @IBOutlet weak var bg: UIImageView!
    
    
    @IBOutlet weak var signUp: UIButton!
    
    
    
    @IBAction func signUpWithUserAndPa(sender: UIButton) {
        
        if (email.text != nil && email.text.rangeOfString("@")?.isEmpty != nil) && password.text != nil{
            
            InteractingWithServer.signUp(email.text, password: password.text, returnView: self)
            
        }
        else if(email.text==nil||email.text.rangeOfString("@")?.isEmpty == nil){
                println("invalid Email")
            }
        else {
            println("invalid Password")
        }
        
        
    }
        func signUpResult(result: [String: AnyObject]){
            println(result)
            
            if result["success"] as Bool{
                
                UserInfo.setUserData(email.text, name: "", accessToken: result["token"] as String, id: "")
                
                UserInfo.downloadUserInfo()
                
            }
        }

  

    
    
    
}