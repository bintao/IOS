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

    @IBOutlet var postView: UIView!
    @IBOutlet var searchView: UIView!

    var container : UIViewController!

    
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        var choices = ["POSTS","SEARCH"]
        switcher.setup(choices, colorSelected: self.navigationController!.view.tintColor!, colorDefault: UIColor.whiteColor())
        switcher.delegate = self
    }
    
    func customSwitcherSwitched(switcher: CustomSwitcher) {
        if switcher.chosenBox == 0{
            postSelect()
        }else if switcher.chosenBox == 1{
            searchSelect()
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
    
    
}
