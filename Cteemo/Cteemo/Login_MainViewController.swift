//
//  ViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/1/24.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

class Login_MainViewController: UIViewController, FBLoginViewDelegate,RequestResultDelegate{

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
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        

        var myToken = FBSession.activeSession().accessTokenData.accessToken
        var fbid: String = UserInfo.fbid
        println(fbid)
        FBRequestConnection.startForMeWithCompletionHandler({connection, result, error in
            if !(error != nil)
            {
                fbid = result.objectForKey("id") as String
                println("@@@@@")
            }
            else
            {
                println("Error")
            }
        })
        
        var req =  ARequest(prefix: "/fb_login", method: "POST", data: ["fbtoken": myToken, "fbid": fbid])
        req.delegate = self
        req.sendRequest()
        
    }
    
    
    func getFriends(){
        FBRequestConnection.startForMyFriendsWithCompletionHandler({ (connection, result, error: NSError!) -> Void in
            if error == nil {
                var friendObjects = result["data"] as [NSDictionary]
                for friendObject in friendObjects {
                    println(friendObject["id"] as NSString)
                }
                println("\(friendObjects.count)")
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
        UserInfo.fbid = user.objectForKey("id") as String
        UserInfo.email = user.objectForKey("email") as String
        UserInfo.gender = user.objectForKey("gender") as String
        UserInfo.name = user.name


        
        //login 
        
        //UserInfo.setUserData(user.objectForKey("email") as String, name: user.name + " " + user.first_name, accessToken: "", id: user.objectID)
        
    }
    
    func gotResult(prefix:String ,result: [String: AnyObject]){
        println(result)
        
    }
    
    @IBAction func returnToLoginMain(segue : UIStoryboardSegue) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

