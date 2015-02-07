
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

    @IBOutlet var school: UIButton!
    @IBOutlet var publicc: UIButton!
    @IBOutlet var schoolLab: UILabel!
    @IBOutlet var publicLab: UILabel!
    @IBOutlet var schoolView: UIView!
    @IBOutlet var publicView: UIView!
    
    
    
    @IBOutlet var icon: UIButton!

    @IBOutlet weak var teamName: UITextField!
    
    @IBOutlet weak var schoolPublic: UIView!
    
    @IBOutlet weak var teamIntro: UITextView!
    
    @IBOutlet weak var create: UIBarButtonItem!
    
    override func viewDidLoad() {
        school.backgroundColor = self.navigationController?.view.tintColor

    }
    
    @IBAction func switchSection(sender: UIButton){
        
        if sender == school{
            schoolSelect()
        }else if sender == publicc{
            publicSelect()
        }
    }
    
    func schoolSelect(){
        
        schoolLab.backgroundColor = self.navigationController?.view.tintColor
        schoolLab.textColor = UIColor.whiteColor()
        publicLab.backgroundColor = UIColor.whiteColor()
        publicLab.textColor = self.navigationController?.view.tintColor

        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.school.alpha = 1
            self.publicc.alpha = 0
            
            }
            , completion: {
                (value: Bool) in
                
        })
        
        
    }
    
    
    func publicSelect(){

        publicLab.backgroundColor = self.navigationController?.view.tintColor
        publicLab.textColor = UIColor.whiteColor()
        schoolLab.backgroundColor = UIColor.whiteColor()
        schoolLab.textColor = self.navigationController?.view.tintColor
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.school.alpha = 0
            self.publicc.alpha = 1
            
            }
            , completion: {
                (value: Bool) in
                
        })
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
            self.schoolPublic.transform = CGAffineTransformMakeTranslation(0, -100)
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
            self.schoolPublic.transform = CGAffineTransformMakeTranslation(0, 0)
            self.teamIntro.transform = CGAffineTransformMakeTranslation(0, 0)
            
            }
            , completion: {
                (value: Bool) in
                
        })
        return true
    }
    
    
    }

