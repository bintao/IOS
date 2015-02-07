//
//  Team_JoinTeamViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/5.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

class Team_JoinTeamViewController: UIViewController {

    @IBOutlet var search: UIButton!
    @IBOutlet var post: UIButton!
    @IBOutlet var searchLab: UILabel!
    @IBOutlet var postLab: UILabel!
    @IBOutlet var postView: UIView!
    @IBOutlet var searchView: UIView!

    var container : UIViewController!

    var isPostNotSearch = true
    
    override func viewDidLoad() {
        post.backgroundColor = self.navigationController?.view.tintColor
    }

    @IBAction func switchSection(sender: UIButton){
        if sender == post{
            postSelect()
        }else if sender == search{
            searchSelect()
        }
    }
    
    func postSelect(){
        postLab.backgroundColor = self.navigationController?.view.tintColor
        postLab.textColor = UIColor.whiteColor()
        searchLab.backgroundColor = UIColor.whiteColor()
        searchLab.textColor = self.navigationController?.view.tintColor

        isPostNotSearch = true
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.postView.alpha = 1
            self.searchView.alpha = 0

            }
            , completion: {
                (value: Bool) in
                
        })

        
    }
    
    
    func searchSelect(){
        postLab.textColor = self.navigationController?.view.tintColor
        postLab.backgroundColor = UIColor.whiteColor()
        searchLab.textColor = UIColor.whiteColor()
        searchLab.backgroundColor = self.navigationController?.view.tintColor
        
        isPostNotSearch = false

        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.postView.alpha = 0
            self.searchView.alpha = 1
            
            }
            , completion: {
                (value: Bool) in
                
        })
    }
    
    
}
