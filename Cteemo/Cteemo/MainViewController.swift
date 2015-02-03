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
    @IBOutlet var tournament: UIView!
    @IBOutlet var me: UIView!
    @IBOutlet var team: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        if title == "Tournament"{
            presentTheView(tournament)
        }else if title == "Me"{
            presentTheView(me)
        }else if title == "Team"{
            presentTheView(team)
        }else if title == "News"{
            presentTheView(news)
        }
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
    
}

