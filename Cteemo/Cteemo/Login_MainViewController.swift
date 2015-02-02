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
    var time = true;
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
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        

        var myToken = FBSession.activeSession().accessTokenData.accessToken
        var fbid: String = UserInfo.fbid
        println(fbid)
        FBRequestConnection.startForMeWithCompletionHandler({connection, result, error in
            if !(error != nil)
            {
                
                var myToken = FBSession.activeSession().accessTokenData.accessToken
                
                
                var req = Alamofire.request(.POST, "http://54.149.235.253:5000/fb_login", parameters: ["fbtoken": myToken, "fbid": UserInfo.fbid,"fbemail":UserInfo.fbid+"@cteemo.com"])
                    .responseJSON { (_, _, JSON, _) in
                        var result: [String: AnyObject] = JSON as [String: AnyObject]
                        self.gotFBResult(result)
                }
                
                println(UserInfo.fbid)
                println(UserInfo.name)
                println(UserInfo.email)
                println(myToken)
                self.time = false;
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
           
        }

        if user.objectForKey("email") == nil{
           UserInfo.email = ""
        }else{
           UserInfo.email = user.objectForKey("email") as String
        }
        
   
        
    }
    
    
    
    func gotFBResult(result: [String: AnyObject]){
        if result["token"]?  != nil
        {
        UserInfo.accessToken = result["token"] as String
        println(UserInfo.accessToken)
        }
        
            
        
    }
    
    @IBAction func returnToLoginMain(segue : UIStoryboardSegue) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

