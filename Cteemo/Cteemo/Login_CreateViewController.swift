//
//  Login_CreateViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/1/24.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

class Login_CreateViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var bg : UIImageView!
    
    @IBOutlet var email : UITextField!
    @IBOutlet var password : UITextField!
    @IBOutlet var nickname : UITextField!
    
    @IBOutlet var back : UIButton!
    
    @IBOutlet var signup : UIButton!
    
    @IBOutlet var loadingView : UIImageView!
    @IBOutlet var loading : UIActivityIndicatorView!
    
    @IBOutlet var teemoSpeaker : UIView!
    @IBOutlet var messageDisplay : UITextView!
    
    override func viewDidLoad() {
        //add tap gesture to board
        self.bg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "backGroundTapped:"))
        
    }
    
    @IBAction func signUpWithUserAndPa(sender: UIButton) {
        
        self.performSegueWithIdentifier("addSchoolAndPhoto", sender: self)
        
        /*
        if (email.text != nil && email.text.rangeOfString("@")?.isEmpty != nil) && password.text != ""&&nickname.text != ""{
            
            var req = Alamofire.request(.POST, "http://54.149.235.253:5000/create_user", parameters: ["email": email.text, "password":password.text])
                .responseJSON { (_, _, JSON, _) in
                var result: [String: AnyObject] = JSON as [String: AnyObject]
                self.gotCreateResult(result)
        }
            
        self.startLoading()
       
        }else if email.text == "" || email.text.rangeOfString("@")?.isEmpty == nil{
            displaySpeaker("Email Invalid")
        }
        else if password.text == ""{
            displaySpeaker("Password Invalid")
        }
        else if nickname.text == ""{
            displaySpeaker("Fill your Nickname please ~ ")
        }
        
    */
    }
    
    func gotCreateResult(result: [String: AnyObject]){
        
        stopLoading()
        
        println(result)
        
        
        if (((result["message"] as String).rangeOfString("Please")?.isEmpty != nil) && result["status"] as String == "success") {
            println("OK")
            
            UserInfo.email = email.text
            UserInfo.name = nickname.text
            UserInfo.saveUserData()
            
            self.performSegueWithIdentifier("addSchoolAndPhoto", sender: self)
            
        }else{
            if((result["message"] as String).rangeOfString("Validation")?.isEmpty != nil){
                displaySpeaker("Invalid Email")
            }
            
            if((result["message"] as String).rangeOfString("Tried")?.isEmpty != nil){
                displaySpeaker("Your Account Already Exist")
            }
            //login fail
            
        }
        
        
    }
    func signUpResult(result: [String: AnyObject]){
        println(result)
        
        if (result["status"] as String == "success"){
            
            UserInfo.accessToken = result["token"] as String
            UserInfo.saveUserData()
            
            UserInfo.downloadUserInfo()
            
        }
    }
    
    
    // display the speaker on teemo
    func displaySpeaker(text: String){
        
        messageDisplay.text = text
        
        if teemoSpeaker.alpha != 1{
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                self.teemoSpeaker.alpha = 1
                
                }
                , completion: {
                    (value: Bool) in
                    
            })
        }
    }
    
    // speaker on teemo disappear
    
    func disappearSpeaker(){
        if teemoSpeaker.alpha != 0{
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                self.teemoSpeaker.alpha = 0
                
                }
                , completion: {
                    (value: Bool) in
                    
            })
        }
        
    }
    
    
    // keyboard customization
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == email{
            email.resignFirstResponder()
            password.becomeFirstResponder()
        }else if textField == password{
            password.resignFirstResponder()
            nickname.becomeFirstResponder()
        }else if textField == nickname{
            nickname.resignFirstResponder()
        }
        
        return true
    }
    
    // background tapped
    func backGroundTapped(gestureRecognizer: UITapGestureRecognizer){
        password.resignFirstResponder()
        email.resignFirstResponder()
        nickname.resignFirstResponder()
        if teemoSpeaker.alpha != 0{
            disappearSpeaker()
        }
    }
    
    //loading view display while login
    func startLoading(){
        self.view.bringSubviewToFront(loadingView)
        self.loading.startAnimating()
    }
    
    //loading view hide, login finished
    func stopLoading(){
        self.view.sendSubviewToBack(loadingView)
        self.loading.stopAnimating()
    }
    
    
    
    
    
    
}