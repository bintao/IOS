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
        
        //Create faceook login
        var loginView: FBLoginView = FBLoginView()
        loginView.delegate = self
        loginView.frame.size = facebook.frame.size
        self.facebook.addSubview(loginView)
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        
        
                // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //facebook logedin
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        
        var myToken = FBSession.activeSession().accessTokenData.accessToken
        var fbid: String = UserInfo.fbid

        
        FBRequestConnection.startForMeWithCompletionHandler({connection, result, error in
            if !(error != nil)
            {
                //already got facebook information
                var myToken = FBSession.activeSession().accessTokenData.accessToken
                
                var req = Alamofire.request(.POST, "http://54.149.235.253:5000/fb_login", parameters: ["fbtoken": myToken, "fbid": UserInfo.fbid,"fbemail":UserInfo.fbid+"@cteemo.com"])
                    .responseJSON { (_, _, JSON, _) in
                        var result: [String: AnyObject] = JSON as [String: AnyObject]
                        self.saveToken(result)
                        self.getProfileFromServer()
                        
                }
            
            println(UserInfo.email)
            println(UserInfo.name)
            println(UserInfo.profile_ID)
                
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

    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!)
    {
       //save and update user data

        if UserInfo.fbid.isEmpty || UserInfo.gender.isEmpty||UserInfo.name.isEmpty{
            
            UserInfo.gender = user.objectForKey("gender") as String
            UserInfo.name = user.name
            UserInfo.fbid = user.objectForKey("id") as String
            UserInfo.email = user.objectForKey("email") as String
            UserInfo.saveUserData()
        
        }

        if user.objectForKey("email") == nil{
           UserInfo.email = ""
        }else{
           UserInfo.email = user.objectForKey("email") as String
        }
        
        UserInfo.saveUserData()
   
        
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
                println(result)
                if ( result["username"]? != nil) {
                //old User
                    
                    UserInfo.profile_ID = result["id"] as String
                    UserInfo.saveUserData()
                    println(UserInfo.profile_ID)
                    
                    
                    var facebookIcon: UIImage? = self.getPotraitFromFacebook() as UIImage

                    if facebookIcon != nil{
                        UserInfo.icon = facebookIcon
                        UserInfo.saveUserIcon()

                    }

                    self.performSegueWithIdentifier("exitToMain", sender: self)
                    /*self.performSegueWithIdentifier("getSchoolAfterFacebook", sender: self)*/
    
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

