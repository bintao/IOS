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

    @IBOutlet var news: UIView!
    @IBOutlet var tournament: UIView!
    @IBOutlet var me: UIView!
    @IBOutlet var team: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        content = self.storyboard!.instantiateViewControllerWithIdentifier("News")! as UIViewController
        self.displayContentController(content)
        self.view.bringSubviewToFront(self.tabbar)
        // Do any additional setup after loading the view, typically from a nib.
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
    
    func presentTheView(view: UIView){
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.me.alpha = 0
            self.team.alpha = 0
            self.news.alpha = 0
            self.tournament.alpha = 0
            view.alpha = 1
            }
            , completion: {
                (value: Bool) in
        })
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
    
}

