//
//  Team_JoinTeamViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/5.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

class Team_JoinTeamViewController: UIViewController, CustomSwitcherDelegate{

    
    @IBOutlet var switcher: CustomSwitcher!
    @IBOutlet var searchView: UIView!

    var container : UIViewController!
    var join  = false
    
    override func viewDidLoad() {
       
        if join {
            
            self.navigationItem.title = "Find Teammate"
            TeamInfoGlobal.findplayer = true
       
        }
        else{
            
            self.navigationItem.title = "Join a Team"
            
        }
        
            self.searchView.alpha = 1
        

        
        
    }
    
    override func viewDidAppear(animated: Bool) {
       var choices = ["SEARCH"]
        
        if join {
            
       choices = ["SEARCH PLAYER"]
        
       }else {
            
        choices = ["SEARCH TEAMS"]
            
        }
        
        switcher.setup(choices, colorSelected: self.navigationController!.view.tintColor!, colorDefault: UIColor.whiteColor())
        switcher.delegate = self
        
    }
    
    func customSwitcherSwitched(switcher: CustomSwitcher) {
      if switcher.chosenBox == 0{
            searchSelect()
        }
    }
    
    
    func searchSelect(){

        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.searchView.alpha = 1
            
            }
            , completion: {
                (value: Bool) in
                
        })
    }
    
    @IBAction func TeamJoinview(segue : UIStoryboardSegue) {
    
        
        
    }

    
    
}
