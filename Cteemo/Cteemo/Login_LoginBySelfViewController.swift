//
//  ViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/1/24.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

class Login_LoginBySelfViewController: UIViewController, FBLoginViewDelegate, UITextFieldDelegate, RequestResultDelegate{

    @IBOutlet var bg : UIImageView!

    @IBOutlet var email : UITextField!
    @IBOutlet var password : UITextField!

    @IBOutlet var back : UIButton!

    @IBOutlet var login : UIButton!
    @IBOutlet var forgotPass : UIView!

    @IBOutlet var loadingView : UIImageView!
    @IBOutlet var loading : UIActivityIndicatorView!
    
    @IBOutlet var teemoSpeaker : UIView!
    @IBOutlet var messageDisplay : UITextView!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //add tap gesture to board
        self.bg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "backGroundTapped:"))

        // Do any additional setup after loading the view, typically from a nib.
    }

    //login
    @IBAction func loginWithUserAndPass(){
        if  (password.text != nil) && email.text != nil && email.text.rangeOfString("@")?.isEmpty != nil {
            /*
            var req = ARequest(prefix: "/login", method: "POST", data: ["email": email.text, "password": password.text])
            req.delegate = self
            req.sendRequest()
            */
            var req = Alamofire.request(.POST, "http://54.149.235.253:5000/login", parameters: ["email": email.text, "password":password.text ])
                .responseJSON { (_, _, JSON, _) in
                    println(JSON)
            }
            startLoading()
        }else{
            //login failed
            if password.text == ""{
                displaySpeaker("password is empty")
            }else if email.text.rangeOfString("@")?.isEmpty != nil{
                displaySpeaker("email is invalid")
            }else if email.text != nil{
                displaySpeaker("email is empty")
            }
        
        }
    }

    func gotResult(prefix:String ,result: [String: AnyObject]){

        stopLoading()
        if result["success"] as Bool{
            
            // login success
            
            UserInfo.accessToken = result["token"] as String
            UserInfo.saveUserData()

            UserInfo.downloadUserInfo()
            
        }else{
            
            //login error
            
            displaySpeaker("email and password not match")
            
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
        }
        
        println(back.superview)

        return true
    }
    
    // background tapped
    func backGroundTapped(gestureRecognizer: UITapGestureRecognizer){
        password.resignFirstResponder()
        email.resignFirstResponder()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

