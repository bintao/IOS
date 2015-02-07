
//
//  Team_CreateTeamViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/5.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

class Team_CreateTeamViewController: UIViewController {

    @IBOutlet var icon: UIButton!

    @IBOutlet weak var teamName: UITextField!
    
    @IBOutlet weak var school: UILabel!
    
    @IBOutlet weak var teamIntro: UITextView!
    
    @IBOutlet weak var create: UIBarButtonItem!
    
    
    
    @IBAction func createTeam(sender: UIBarButtonItem) {
        
        var manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = ["token": UserInfo.accessToken]
        println(UserInfo.accessToken)
        var req = Alamofire.request(.POST, "http://54.149.235.253:5000/create_team/lol",parameters: ["teamName":teamName.text, "teamIntro":teamIntro.text,"isSchool":true])
            .responseJSON { (_, _, JSON, _) in
                var result: [String: AnyObject] = JSON as [String: AnyObject]
                    println(result)
            }
        }
    
    
    
    
    }

