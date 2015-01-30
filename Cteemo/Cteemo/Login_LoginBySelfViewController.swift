//
//  ViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/1/24.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

class Login_LoginBySelfViewController: UIViewController, FBLoginViewDelegate, UITextFieldDelegate, RequestResultDelegate{

    @IBOutlet var bg : UIImageView!

    @IBOutlet var email : UITextField!
    @IBOutlet var password : UITextField!

    @IBOutlet var back : UIButton!

    @IBOutlet var login : UIButton!
    @IBOutlet var forgotPass : UIView!

    @IBOutlet var loadingView : UIView!
    @IBOutlet var loading : UIActivityIndicatorView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //add tap gesture to board
        self.bg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "keyboardReturn:"))

        // Do any additional setup after loading the view, typically from a nib.
    }

    //login
    @IBAction func loginWithUserAndPass(){
        if (email.text != nil && email.text.rangeOfString("@")?.isEmpty != nil) && password.text != nil{

            var req = ARequest(prefix: "/login", method: "POST", data: ["email": email.text, "password": password.text])
            req.delegate = self
            req.sendRequest()
            
            startLoading()
        }else{
            //login failed
            println("invalid")
        }
    }

    func gotResult(prefix:String ,result: [String: AnyObject]){
        println(result)
        stopLoading()
        if result["success"] as Bool{
            // login success
            UserInfo.setUserData(email.text, name: "", accessToken: result["token"] as String, id: "")
            
            UserInfo.downloadUserInfo()
            
        }else{
            
        }
    }

    // keyboard customization
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == email{
            email.resignFirstResponder()
            password.becomeFirstResponder()
        }else if textField == password{
            password.resignFirstResponder()
            loginWithUserAndPass()
        }
        
        println(back.superview)

        return true
    }
    
    // keyboard return
    func keyboardReturn(gestureRecognizer: UITapGestureRecognizer){
        password.resignFirstResponder()
        email.resignFirstResponder()
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

