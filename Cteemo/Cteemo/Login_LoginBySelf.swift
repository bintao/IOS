//
//  ViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/1/24.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

class Login_LoginBySelf: UIViewController, FBLoginViewDelegate, UITextFieldDelegate{

    @IBOutlet var bg : UIImageView!

    @IBOutlet var email : UITextField!
    @IBOutlet var password : UITextField!

    @IBOutlet var login : UIButton!
    @IBOutlet var forgotPass : UIView!

    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //add tap gesture to board
        self.bg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "keyboardReturn:"))

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //login
    @IBAction func loginWithUserAndPass(){
        if (email.text != nil && email.text.rangeOfString("@")?.isEmpty != nil) && password.text != nil{

            
            InteractingWithServer.login(email.text, password: password.text)
        
        }else{
            //login failed
            println("invalid")
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
        return true
    }
    
    // keyboard return
    func keyboardReturn(gestureRecognizer: UITapGestureRecognizer){
        password.resignFirstResponder()
        email.resignFirstResponder()
    }
    
    
    // retrive information from user

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

