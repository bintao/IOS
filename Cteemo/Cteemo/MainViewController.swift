//
//  ViewController.swift
//  Meeet Up
//
//  Created by Kedan Li on 14/11/19.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit

class MainViewController:  UIViewController , UITabBarDelegate, RequestResultDelegate , RCIMReceiveMessageDelegate , RCIMUserInfoFetcherDelegagte , RCIMConnectionStatusDelegate {
    
    @IBOutlet var tabbar: UITabBar!
    
    @IBOutlet var news: UIView!
    @IBOutlet var team: UIView!
    @IBOutlet var tournament: UIView!
    @IBOutlet var me: UIView!
    
    
    var tabbarShouldAppear = true
    var firstlogin = true
    var groupcount = 0
    var count = 0
    var content : UIViewController!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabbar.transform = CGAffineTransformMakeTranslation(0, self.tabbar.frame.height)
        self.tabbar.alpha = 0
        news.alpha = 0
        tournament.alpha = 0
        team.alpha = 0
        me.alpha = 0
      
        
        
        // doens't appear if user haven't login
        RCIM.sharedRCIM().setReceiveMessageDelegate(self)
        LolAPIGlobal.getlolvision()
        Tournament.getsolodata()
        Tournament.getteamdata()
        
        
    }
    
    
     func responseConnectionStatus(status: RCConnectionStatus) {
        
        
        if RCIMClient.sharedRCIMClient().getCurrentConnectionstatus().rawValue == 9 {
            
            RCIM.connectWithToken(UserInfoGlobal.rongToken, completion: { (userId:String!) -> Void in
                
                NSLog("Login successfully with userId: %@.",userId)
                println(RCIMClient.sharedRCIMClient().getCurrentConnectionstatus().rawValue)
                }){
                    (status:RCConnectErrorCode) -> Void in
                    
                    
                    println(status.rawValue)
                    
                    NSLog("Login failed")
            }
        }
        
    }
    
    
    
    func clearnteambadge(){
    
        var tabItem  = self.tabbar.items![2] as! UITabBarItem
        self.groupcount = 0
        tabItem.badgeValue = nil
        
    }
    
    func cleanbadge(){
        
        var tabItem  = self.tabbar.items![3] as! UITabBarItem
        self.count = 0
        tabItem.badgeValue = nil
    
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // 融云得到用户头像
    func getUserInfoWithUserId(userId: String!, completion: ((RCUserInfo!) -> Void)!){
        
        var manager = Manager.sharedInstance
        // Specifying the Headers we need
        manager.session.configuration.HTTPAdditionalHeaders = [
            "token": UserInfoGlobal.accessToken
        ]
        var user  = RCUserInfo.alloc()
        user.userId = userId
        
        
        //从服务器获取用户资料
        if userId != UserInfoGlobal.profile_ID{
        var req = request(.GET, "http://54.149.235.253:5000/view_profile/" + userId)
            .responseJSON { (_, _, JSONdata, _) in
                if JSONdata != nil {
                let myjson = JSON(JSONdata!)
                println(myjson)
                 if let icon = myjson["profile_icon"].string{
                    user.portraitUri = icon
                   
                    }
                    if let name = myjson["username"].string{
                    user.name = name
                 
                    }
                    return completion(user)
                }
            
            }
        }
            
        //当用户是自己时候从本地缓存
        else{
        
        user.portraitUri = UserInfoGlobal.profile_icon_Link
        user.name = UserInfoGlobal.name
        
        return completion(user)
        }
      
        
    }
    
    
    //融云收到新信息
    func didReceivedMessage(message: RCMessage!, left: Int32) {
        
        //得到组群信息并且设置角标
        println(message.targetId)
        if  message.conversationType == RCConversationType.ConversationType_GROUP {
            
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
                dispatch_async(dispatch_get_main_queue(), {
                    
                     self.groupcount = self.groupcount + 1
                     var tabItem  = self.tabbar.items![2] as! UITabBarItem
                     tabItem.badgeValue = "\(self.groupcount)"
                    
                })
            })
        
        }
            
        else if message.targetId != "KEFU1428955428622" && message.conversationType != RCConversationType.ConversationType_CHATROOM {
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
                dispatch_async(dispatch_get_main_queue(),{
                  
                    self.count = self.count + 1
                    var tabItem  = self.tabbar.items![3] as! UITabBarItem
                    tabItem.badgeValue = "\(self.count)"
                    
                    ((self.childViewControllers[0] as!  UINavigationController).childViewControllers[0] as! MeViewController).updatemesage(self.count)
                    
                })
            })
        
        
        }
        
        
    }
    
    
   
    override func viewDidAppear(animated: Bool) {
        
        
        println(NSUserDefaults.standardUserDefaults().objectForKey("introview"))
        
        if NSUserDefaults.standardUserDefaults().objectForKey("introview") == nil{
          self.performSegueWithIdentifier("showIntro", sender: self)
        }
        
        //当用户没有token时跳转到登录界面
        if UserInfoGlobal.accessToken == nil
        {
            self.performSegueWithIdentifier("login", sender: self)
            
        }
        //当用户没有成功登录跳转到登录
        else if !UserInfoGlobal.userIsLogined(){
            
            // if user have't login let him login
            FBSession.activeSession().closeAndClearTokenInformation()
            self.performSegueWithIdentifier("login", sender: self)
       
        }
            
        //当用户有token时候跟融云链接并且更新信息
        else{
         
            RCIM.setUserInfoFetcherWithDelegate(self, isCacheUserInfo: true)
            
            println(UserInfoGlobal.rongToken)
            
            if UserInfoGlobal.rongToken != nil{
                
                RCIM.connectWithToken(UserInfoGlobal.rongToken, completion: { (userId:String!) -> Void in
                    
                NSLog("Login successfully with userId: %@.",userId)
                println(RCIMClient.sharedRCIMClient().getCurrentConnectionstatus().rawValue)
            
                }){
                    (status:RCConnectErrorCode) -> Void in
                    
                
                   println(status.rawValue)
                    
                    NSLog("Login failed")
                }
            }

            
            if tabbarShouldAppear && firstlogin {
                news.alpha = 1
                showTabb()
                self.view.bringSubviewToFront(self.tabbar)
                firstlogin = false
                
                UserInfoGlobal.updateUserInfo()
                
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        
        
        if item.title! == "News" && news.alpha != 1 {
            self.view.bringSubviewToFront(news)
            displayView(news)
            self.view.bringSubviewToFront(tabbar)
        }else if item.title! == "Tournament" && tournament.alpha != 1{
            self.view.bringSubviewToFront(tournament)
            displayView(tournament)
            self.view.bringSubviewToFront(tabbar)
        }else if item.title! == "Team" && team.alpha != 1{
            self.view.bringSubviewToFront(team)
            displayView(team)
            self.view.bringSubviewToFront(tabbar)
        }else if item.title! == "Me" && me.alpha != 1{
            self.view.bringSubviewToFront(me)
            displayView(me)
            
            self.view.bringSubviewToFront(tabbar)
        }
        
        
    }
    
    func displayView(content: UIView){
        news.alpha = 0
        tournament.alpha = 0
        team.alpha = 0
        me.alpha = 0
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
        if UserInfoGlobal.fbid != nil {
            
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
        LolAPIGlobal.cleanUserData()
        TeamInfoGlobal.cleanUserData()
        
        RCIM.sharedRCIM().disconnect()
        
        println(UserInfoGlobal.fbid)
        
        self.performSegueWithIdentifier("login", sender: self)
        
    }
    
    
    func tokennotvaild(){
    
        let alert1 = SCLAlertView()
        alert1.addButton("ok", actionBlock:{ (Void) in
            self.logout()
        })
        alert1.showError(self, title: "Unauthorized", subTitle: "Try logout and login again", closeButtonTitle: nil, duration: 0.0)
    
    }
    
    
    func gotResult(prefix: String, result: AnyObject) {
        
        println(result)
    }
    
    @IBAction func returnToMain(segue : UIStoryboardSegue) {
        showTabb()
        
        if segue.identifier == "exitToMain"{
            println(self.childViewControllers[2])
        }
        
        if segue.identifier == "returnFromIntro" {
            
             NSUserDefaults.standardUserDefaults().setObject("already Showed", forKey: "introview")
             NSUserDefaults.standardUserDefaults().synchronize()
            
        }
        
    }
    
}

