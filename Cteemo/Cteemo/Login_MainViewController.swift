//
//  ViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/1/24.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

class Login_MainViewController: UIViewController, FBLoginViewDelegate{

    @IBOutlet var bg : UIImageView!

    @IBOutlet var login : UIButton!
    @IBOutlet var signup : UIButton!
    
    @IBOutlet var facebook : UIView!

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
        if UserInfo.fbid.isEmpty || UserInfo.gender.isEmpty||UserInfo.name.isEmpty{
            
            UserInfo.gender = user.objectForKey("gender") as String
            UserInfo.name = user.name
            UserInfo.fbid = user.objectForKey("id") as String
            if user.objectForKey("email") != nil{
                UserInfo.email = user.objectForKey("email") as String
            }
            UserInfo.saveUserData()
            
        }

        
        
    }
    
    
    //facebook logedin
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        
        FBRequestConnection.startForMeWithCompletionHandler({connection, result, error in
            if !(error != nil)
            {
                println(result)
                //get facebook token
                var myToken = FBSession.activeSession().accessTokenData.accessToken
                println(myToken)
                var req = Alamofire.request(.POST, "http://54.149.235.253:5000/fb_login", parameters: ["fbtoken": myToken, "fbid": UserInfo.fbid,"fbemail":UserInfo.fbid+"@cteemo.com"])
                    .responseJSON { (_, _, JSON, _) in
                        var result: [String: AnyObject] = JSON as [String: AnyObject]
                        self.saveToken(result)
                        self.getProfileFromServer()
                        
                }
           
                
            }
            else
            {
                println("Error")
            }
        })
        
        
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
        var str = "http://graph.facebook.com/\(UserInfo.fbid)/picture?type=large"
        var url = NSURL(string: str)
        var data: NSData = NSData(contentsOfURL: url! as NSURL, options: nil, error: nil)!
        image = UIImage(data: data)
        image = image.roundCornersToCircle()
        return image
    }
    
    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
        println(error)
    }


    
    //get user profile from server

    func getProfileFromServer(){
    
        var manager = Manager.sharedInstance
        
        // Specifying the Headers we need
        manager.session.configuration.HTTPAdditionalHeaders = [
            "token": UserInfo.accessToken
        ]
        
        var req = Alamofire.request(.GET, "http://54.149.235.253:5000/profile", parameters: nil)
            .responseJSON { (_, _, JSON, _) in
                var result: [String: AnyObject] = JSON as [String: AnyObject]
                
                if ( result["username"]? != nil) {
                //old User
                    
                    UserInfo.profile_ID = result["id"] as String
                    UserInfo.saveUserData()
                    
                    
                    var facebookIcon: UIImage? = self.getPotraitFromFacebook() as UIImage

                    if facebookIcon != nil{
                        UserInfo.icon = facebookIcon
                        UserInfo.saveUserIcon()

                    }
                    

                    self.performSegueWithIdentifier("exitToMain", sender: self)
                 
                }
                else {
                //new user
                var facebookIcon: UIImage? = self.getPotraitFromFacebook() as UIImage
                        
                        if facebookIcon != nil{
                            UserInfo.icon = facebookIcon
                            UserInfo.saveUserIcon()

                            }

                        self.performSegueWithIdentifier("getSchoolAfterFacebook", sender: self)
                
                }
        }

    
    }

    func saveToken(result: [String: AnyObject]){
        
        if result["token"]?  != nil
        {
            UserInfo.accessToken = result["token"] as String
            UserInfo.saveUserData()
        }
    }
    
    @IBAction func returnToLoginMain(segue : UIStoryboardSegue) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

