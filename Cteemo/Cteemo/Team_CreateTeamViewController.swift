
//
//  Team_CreateTeamViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/5.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

class Team_CreateTeamViewController: UIViewController, UITextViewDelegate{

    @IBOutlet var schoolPublicOut: UIView!
    
    @IBOutlet weak var schoolPublicIn: CustomSwitcher!

    
    @IBOutlet var icon: UIButton!

    @IBOutlet weak var teamName: UITextField!
    
    
    @IBOutlet weak var teamIntro: UITextView!
    
    @IBOutlet weak var create: UIBarButtonItem!
    
    var switcher: CustomSwitcher!
    
    override func viewDidLoad() {
        
}
    override func viewDidAppear(animated: Bool) {
        var choices = ["SCHOOL","PUBLIC"]
        schoolPublicIn.setup(choices, frame: schoolPublicIn.frame, colorSelected: self.navigationController!.view.tintColor!, colorDefault: UIColor.clearColor())
        schoolPublicIn.frame.origin = CGPointMake(0, 0)
    }
    
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

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.teamName.transform = CGAffineTransformMakeTranslation(0, -100)
            self.icon.transform = CGAffineTransformMakeTranslation(0, -100)
            self.schoolPublicOut.transform = CGAffineTransformMakeTranslation(0, -100)
            self.teamIntro.transform = CGAffineTransformMakeTranslation(0, -100)

            }
            , completion: {
                (value: Bool) in
                
        })
        return true
    }

    
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.teamName.transform = CGAffineTransformMakeTranslation(0, 0)
            self.icon.transform = CGAffineTransformMakeTranslation(0, 0)
            self.schoolPublicOut.transform = CGAffineTransformMakeTranslation(0, 0)
            self.teamIntro.transform = CGAffineTransformMakeTranslation(0, 0)
            
            }
            , completion: {
                (value: Bool) in
                
        })
        return true
    }
    
    
    }

