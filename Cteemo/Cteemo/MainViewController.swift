//
//  ViewController.swift
//  Meeet Up
//
//  Created by Kedan Li on 14/11/19.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITabBarDelegate {
    
    @IBOutlet var tabbar: UITabBar!
    
    @IBOutlet var news: UIView!
    @IBOutlet var team: UIView!
    @IBOutlet var tournament: UIView!
    @IBOutlet var me: UIView!

    var tabbarShouldAppear = true
    
    var content : UIViewController!
    var uploadRequest: NSURLSessionUploadTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabbar.transform = CGAffineTransformMakeTranslation(0, self.tabbar.frame.height)
        self.tabbar.alpha = 0
       
        var req = ARequest()
        req.uploadPhoto()
    }

    override func viewDidAppear(animated: Bool) {
        
        if !UserInfo.userIsLogined(){
            self.performSegueWithIdentifier("login", sender: self)
            FBSession.activeSession().closeAndClearTokenInformation()

        }else{
            
            if tabbarShouldAppear {
                showTabb()
                self.view.bringSubviewToFront(self.tabbar)
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
        UserInfo.cleanUserData()
        FBSession.activeSession().closeAndClearTokenInformation()
        self.performSegueWithIdentifier("login", sender: self)
    }

    
    @IBAction func returnToMain(segue : UIStoryboardSegue) {
        
    }
    
}

