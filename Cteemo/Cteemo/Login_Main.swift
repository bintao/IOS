//
//  ViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/1/24.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

class Login_Main: UIViewController, FBLoginViewDelegate{

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
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        
    }
    
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

