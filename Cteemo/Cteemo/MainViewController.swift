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
    
    var content : UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabbar.transform = CGAffineTransformMakeTranslation(0, self.tabbar.frame.height)
        self.tabbar.alpha = 0

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        if !UserInfo.userIsLogined(){
            self.performSegueWithIdentifier("login", sender: self)
            FBSession.activeSession().closeAndClearTokenInformation()

        }else{
            showTabb()
            content = self.storyboard!.instantiateViewControllerWithIdentifier("News")! as UIViewController
            self.displayContentController(content)
            self.view.bringSubviewToFront(self.tabbar)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        presentView(item.title!)
    }
    
    func presentView(title: String){
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.content.view.alpha = 0
            
            }
            , completion: {
                (value: Bool) in
                self.hideContentController(self.content)
                self.content = self.storyboard!.instantiateViewControllerWithIdentifier(title)! as UIViewController
                self.displayContentController(self.content)
                
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
    
    func hideContentController(content: UIViewController){
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }
 
    //hide tab bar
    
    func hideTabb(){
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
        hideContentController(content)
        UserInfo.cleanUserData()
        FBSession.activeSession().closeAndClearTokenInformation()
        self.performSegueWithIdentifier("login", sender: self)
    }

    
    @IBAction func returnToMain(segue : UIStoryboardSegue) {
        
    }
    
}

