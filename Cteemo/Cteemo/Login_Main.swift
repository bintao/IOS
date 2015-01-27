//
//  ViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/1/24.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

<<<<<<< HEAD:Cteemo/Cteemo/Login_MainViewController.swift
class Login_MainViewController: UIViewController, FBLoginViewDelegate, UITextFieldDelegate{
=======
class Login_Main: UIViewController, FBLoginViewDelegate{
>>>>>>> bintao:Cteemo/Cteemo/Login_Main.swift

    @IBOutlet var bg : UIImageView!

    @IBOutlet var email : UITextField!
    @IBOutlet var password : UITextField!

    @IBOutlet var login : UIButton!
    @IBOutlet var signup : UIButton!

    @IBOutlet var facebook : UIView!

    
    override func viewDidLoad(){
        super.viewDidLoad()
        //
        //Create faceook login
        var loginView: FBLoginView = FBLoginView()
        loginView.delegate = self
        loginView.frame.size = facebook.frame.size
        self.facebook.addSubview(loginView)
        
//
        //add tap gesture to board
        self.bg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "keyboardReturn:"))

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func loginWithUserAndPass(){
        if (email.text != nil && email.text.rangeOfString("@")?.isEmpty != nil) && password.text != nil{
            //login
        }else{
            //login failed
            println("invalid")
        }
    }
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        
    }
    
<<<<<<< HEAD:Cteemo/Cteemo/Login_MainViewController.swift
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

    
    // get facebook portrait
    func getPotraitFromFacebook()->UIImage{
        
        var image:UIImage!
        FBRequest.requestForMe().startWithCompletionHandler({(connection: FBRequestConnection!, user: AnyObject!, error: NSError!) -> Void in
            if((error) != nil){
                //error
            }else{
                println(user as [String: AnyObject])
                
                var userID = user["id"] as String
                var str = "http://graph.facebook.com/\(userID)/picture?type=large"
                var url = NSURL(string: str)
                println(url)
                var data: NSData = NSData(contentsOfURL: url! as NSURL, options: nil, error: nil)!
                image = UIImage(data: data)
                
            }
        })
        
        return image
        
    }
    
=======
>>>>>>> bintao:Cteemo/Cteemo/Login_Main.swift
    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
        //println(error)
    }

    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        println(user)
        
        let permissions = ["email"]
        FBSession.openActiveSessionWithReadPermissions(permissions, allowLoginUI: true, completionHandler: {
            (session: FBSession!, state: FBSessionState!, error: NSError!) -> Void in
            self.sessionStateChanged(session, state: state, error: error)
        })
        
    }
    
    // retrive information from user
    func sessionStateChanged(session: FBSession!, state: FBSessionState!, error: NSError!){
        if state == FBSessionState.Open{
            
                FBRequest.requestForMe().startWithCompletionHandler({(connection: FBRequestConnection!, user: AnyObject!, error: NSError!) -> Void in
                    if((error) != nil){
                        //error
                    }else{
                        //println((user as [String: AnyObject])["email"])
                    }
                })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

