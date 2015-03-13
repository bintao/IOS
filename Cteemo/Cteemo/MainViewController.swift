//
//  ViewController.swift
//  Meeet Up
//
//  Created by Kedan Li on 14/11/19.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController, UITabBarDelegate, RequestResultDelegate{
    
    @IBOutlet var tabbar: UITabBar!
    
    @IBOutlet var news: UIView!
    @IBOutlet var team: UIView!
    @IBOutlet var tournament: UIView!
    @IBOutlet var me: UIView!
    
    var tabbarShouldAppear = true
    
    var content : UIViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabbar.transform = CGAffineTransformMakeTranslation(0, self.tabbar.frame.height)
        self.tabbar.alpha = 0
        
        

        // doens't appear if user haven't login
        news.alpha = 0
        tournament.alpha = 0
        team.alpha = 0
        me.alpha = 0
        
    }
    
    override func viewDidAppear(animated: Bool) {
        Tournament.getTournamentList()
        LolAPIGlobal.getlolvision()
    RCIM.connectWithToken("b3rDNPQmJIpBeq1QXvNOez7ZGryb3Xip4jqmBYclOnCJR3FPmXnadpAdgB2RyT/oEB5/N5xrURN+Dp6+HsM1Qw==", completion: { (userId:String!) -> Void in
            
            NSLog("Login successfully with userId: %@.",userId)
            
            }){
                (status:RCConnectErrorCode) -> Void in
                println(RCConnectErrorCode)
                NSLog("Login failed")
        }
        
        if UserInfoGlobal.accessToken == ""
        {
         
            self.performSegueWithIdentifier("login", sender: self)
            
        }else if !UserInfoGlobal.userIsLogined(){
            
            // if user have't login let him login
            FBSession.activeSession().closeAndClearTokenInformation()
            self.performSegueWithIdentifier("login", sender: self)

        }
        else{
            
            news.alpha = 1
            
            if tabbarShouldAppear {
                showTabb()
                self.view.bringSubviewToFront(self.tabbar)
            }
            UserInfoGlobal.updateUserInfo()
            if UserInfoGlobal.tokenVaild == "false"{
                let alert1 = SCLAlertView()
                alert1.addButton("ok", actionBlock:{ (Void) in
                    self.logout()
                })
                alert1.showError(self, title: "Unauthorized", subTitle: "Try logout and login again", closeButtonTitle: nil, duration: 0.0)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if item.title! == "News"{
            self.view.bringSubviewToFront(news)
            news.alpha = 0
            displayView(news)
            self.view.bringSubviewToFront(tabbar)
        }else if item.title! == "Tournament"{
            self.view.bringSubviewToFront(tournament)
            tournament.alpha = 0
            displayView(tournament)
            self.view.bringSubviewToFront(tabbar)
        }else if item.title! == "Team"{
            self.view.bringSubviewToFront(team)
            team.alpha = 0
            displayView(team)
            self.view.bringSubviewToFront(tabbar)
        }else if item.title! == "Me"{
            self.view.bringSubviewToFront(me)
            me.alpha = 0
            displayView(me)
            self.view.bringSubviewToFront(tabbar)
        }
    }
    
    func displayView(content: UIView){
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            content.alpha = 1
            
            }
            , completion: {
                (value: Bool) in
                
        })
        
    }
    
    // display the new view controller
    func displayContentController(content: UIViewController){
        self.addChildViewController(content)
        content.didMoveToParentViewController(self)          // 3
        content.view.alpha = 0
        self.view.addSubview(content.view)
        
        //reset the tab bar to front
        self.view.bringSubviewToFront(self.tabbar)
        
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.content.view.alpha = 1
            
            }
            , completion: {
                (value: Bool) in
                
        })
        
    }
    
    
    //hide tab bar
    
    func hideTabb(){
        tabbarShouldAppear = false
        if tabbar.alpha > 0{
            UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                self.tabbar.alpha = 0
                self.tabbar.transform = CGAffineTransformMakeTranslation(0, self.tabbar.frame.height)
                }
                , completion: {
                    (value: Bool) in
                    
            })
        }
    }
    
    //display the tab bar
    func showTabb(){
        tabbarShouldAppear = true
        
        if tabbar.alpha < 1{
            
            UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                self.tabbar.alpha = 1
                self.tabbar.transform = CGAffineTransformMakeTranslation(0, 0)
                }
                , completion: {
                    (value: Bool) in
                    
            })
        }
    }
    
    
    func logout(){
        hideTabb()
    
        // clean facebook login
        if UserInfoGlobal.fbid != "" {
            
            
            if FBSession.activeSession().state == FBSessionState.Open{
                FBSession.activeSession().closeAndClearTokenInformation()
            }else{
                
                FBSession.activeSession().openWithCompletionHandler { (session, state, error) -> Void in
                    // logout if needed
                    FBSession.activeSession().closeAndClearTokenInformation()
                }
            }
        }
        UserInfoGlobal.cleanUserData()
        TeamInfoGlobal.cleanUserData()
        LolAPIGlobal.cleanUserData()
        
        

        self.performSegueWithIdentifier("login", sender: self)
    }
    
    
    func postsomething() {
        
        //localhost:5000/team_post -X POST --header "token: from login api" -d "content=I want to find someone to talk"
        var req = ARequest(prefix: "team_post", method: requestType.POST, parameters: ["content":"bintao here"])
        req.delegate = self
        req.sendRequestWithToken(UserInfoGlobal.accessToken)
        
    }
    func gotResult(prefix: String, result: AnyObject) {
        
        println(result)
    }
    
    @IBAction func returnToMain(segue : UIStoryboardSegue) {
        showTabb()
        
        if segue.identifier == "exitToMain"{
            println(self.childViewControllers[2])
        }
    }
    
}

