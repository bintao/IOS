//
//  Login_CreateViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/1/24.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

class Login_CreateViewController: UIViewController, UITextFieldDelegate, RequestResultDelegate{

    
    
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
        
        if (email.text != nil && email.text.rangeOfString("@")?.isEmpty != nil) && password.text != nil{
            
            var req = ARequest(prefix: "/create_user", method: "POST", data: ["email": email.text, "password": password.text])
            
            req.delegate = self
            req.sendRequest()
            
            
        }
        else if(email.text==nil||email.text.rangeOfString("@")?.isEmpty == nil){
            println("invalid Email")
        }
        else {
            println("invalid Password")
        }
        
        
    }
    
    
    func gotResult(prefix:String ,result: [String: AnyObject]){
        println(result)
        if (result["status"] as String == "success") {
            println("OK")
            UserInfo.setUserData(email.text, name: "", accessToken: result["token"] as String, id: "")
            
            UserInfo.downloadUserInfo()
            
        }else{
            
            
        }

        
    }
        func signUpResult(result: [String: AnyObject]){
            println(result)
            
            if (result["status"] as String == "success"){
                
                UserInfo.setUserData(email.text, name: nickname.text, accessToken: result["token"] as String, id: "")
                
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