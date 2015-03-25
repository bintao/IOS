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

    @IBOutlet var postbutton: UIButton!
    @IBOutlet var postView: UIView!
    @IBOutlet var searchView: UIView!

    var container : UIViewController!
    var join  = false
    
    override func viewDidLoad() {
        self.postView.alpha = 1
        self.searchView.alpha = 0
        
        if join {
            
            self.navigationItem.title = "Find Teammate"
            TeamInfoGlobal.findplayer = true
       
        }
        else{
            
            self.navigationItem.title = "Join a Team"
            
        }

        
    }
    
    override func viewDidAppear(animated: Bool) {
        var choices = ["POSTS","SEARCH"]
        
        switcher.setup(choices, colorSelected: self.navigationController!.view.tintColor!, colorDefault: UIColor.whiteColor())
        switcher.delegate = self
        
    }
    
    func customSwitcherSwitched(switcher: CustomSwitcher) {
        if switcher.chosenBox == 0{
            postSelect()
            postbutton.alpha = 1
            
        }else if switcher.chosenBox == 1{
            searchSelect()
            postbutton.alpha = 0
        }
    }
    
    func postSelect(){
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.postView.alpha = 1
            self.searchView.alpha = 0
            
            }
            , completion: {
                (value: Bool) in
                
        })
    }
    
    
    func searchSelect(){

        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.postView.alpha = 0
            self.searchView.alpha = 1
            
            }
            , completion: {
                (value: Bool) in
                
        })
    }
    
    @IBAction func TeamJoinview(segue : UIStoryboardSegue) {
    
        
        
    }

    
    
}
