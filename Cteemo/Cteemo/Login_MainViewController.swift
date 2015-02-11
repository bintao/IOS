//
//  ViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/1/24.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

class Login_MainViewController: UIViewController, FBLoginViewDelegate, RequestResultDelegate{

    @IBOutlet var bg : UIImageView!

    @IBOutlet var login : UIButton!
    @IBOutlet var signup : UIButton!
    
    @IBOutlet var facebook : UIView!

    @IBOutlet var loadingView : UIImageView!
    @IBOutlet var loading : UIActivityIndicatorView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
                    
            var loginView: FBLoginView = FBLoginView()
            loginView.delegate = self
            loginView.frame.size = self.facebook.frame.size
            self.facebook.addSubview(loginView)
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
        
    }
    
    //save and update user data

    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!)
    {
        
        // avoid running multiple time
        if UserInfo.fbid!.isEmpty || UserInfo.gender!.isEmpty||UserInfo.name!.isEmpty{
            
            UserInfo.gender = user.objectForKey("gender") as? String
            UserInfo.name = user.name
            UserInfo.fbid = user.objectForKey("id") as? String
            if user.objectForKey("email") != nil{
                UserInfo.email = user.objectForKey("email") as? String
            }
            UserInfo.saveUserData()
            
        }

        
        
    }
    
    
    //facebook logedin
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        
        startLoading()
        
        FBRequestConnection.startForMeWithCompletionHandler({connection, result, error in
            if !(error != nil)
            {
                println(result)
                //get facebook token
                var myToken = FBSession.activeSession().accessTokenData.accessToken

                // get token from the server
                var req = ARequest(prefix: "fb_login", method: requestType.POST, parameters: ["fbtoken": myToken, "fbid": UserInfo.fbid!,"fbemail":UserInfo.fbid!+"@cteemo.com"])
                req.delegate = self
                req.sendRequest()
                
            }
            else
            {
                println("Error")
            }
        })
        
        
    }
    
    func gotResult(prefix: String, result: AnyObject) {
        
        if prefix == "fb_login"{
        
            println(result)
            
            //save token
            if result["token"]? != nil
            {
                UserInfo.accessToken = result["token"] as? String
                UserInfo.saveUserData()
                //get profile from the user
                getProfileFromServer()
                
            }else{
                stopLoading()
                //facebook login failed
            }
            
        }else if prefix == "profile" {
            
            if result["username"]? != nil {
                //old User
                
                UserInfo.profile_ID = result["id"] as? String
                UserInfo.saveUserData()
                stopLoading()
                self.performSegueWithIdentifier("exitToMain", sender: self)
                
            }else {
                
                //new user
                var facebookIcon: UIImage? = self.getPotraitFromFacebook() as UIImage
                
                if facebookIcon != nil{
                    UserInfo.icon = facebookIcon
                    UserInfo.saveUserIcon()
                    
                }
                stopLoading()
                self.performSegueWithIdentifier("getSchoolAfterFacebook", sender: self)
                
            }

            
        }
        
    }
    
    
    //get user profile from server
    
    func getProfileFromServer(){
        
        var req = ARequest(prefix: "profile", method: requestType.POST)
        req.delegate = self
        req.sendRequestWithToken(UserInfo.accessToken!)
        
    }
    
    
    func getFriends(){
        FBRequestConnection.startForMyFriendsWithCompletionHandler({ (connection, result, error: NSError!) -> Void in
            if error == nil {
                var friendObjects = result["data"] as [NSDictionary]
                for friendObject in friendObjects {
                    println(friendObject["id"] as NSString)
                }
            } else {
                println("Error requesting friends list form facebook")
                println("\(error)")
            }
        })
    }
   
    // get facebook portrait
    func getPotraitFromFacebook()->UIImage{
        
        var image:UIImage!
        var str = "http://graph.facebook.com/\(UserInfo.fbid!)/picture?type=large"
        var url = NSURL(string: str)
        var data: NSData = NSData(contentsOfURL: url! as NSURL, options: nil, error: nil)!
        image = UIImage(data: data)
        image = image.roundCornersToCircle()
        return image
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
    
    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
        println(error)
    }


    @IBAction func returnToLoginMain(segue : UIStoryboardSegue) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

