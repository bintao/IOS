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
        
        
    
    }
    
    
    
    func gotResult(prefix:String ,result: [String: AnyObject]){
        println(result)
        
        
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

    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
       println(user)
        var myToken = FBSession.activeSession().accessTokenData.accessToken
        
      print(myToken)
        
        
        //login successful
        
        //UserInfo.setUserData(user.objectForKey("email") as String, name: user.name + " " + user.first_name, accessToken: "", id: user.objectID)
        
    }
    
    
    @IBAction func returnToLoginMain(segue : UIStoryboardSegue) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

