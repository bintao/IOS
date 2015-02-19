
//
//  Team_CreateTeamViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/5.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

class Team_CreateTeamViewController: UIViewController, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, RequestResultDelegate{

    @IBOutlet var schoolPublicOut: UIView!
    
    @IBOutlet weak var schoolPublicIn: CustomSwitcher!

    @IBOutlet var icon: UIButton!

    @IBOutlet weak var teamName: UITextField!
    
    @IBOutlet weak var teamIntro: UITextView!
    
    @IBOutlet weak var create: UIBarButtonItem!
    
    @IBOutlet var iconDisplay : UIImageView!
    
    var sourceImage:UIImage!
    
    var switcher: CustomSwitcher!
    
    override func viewDidLoad() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "backGroundTapped:"))

    }
    override func viewDidAppear(animated: Bool) {
        var choices = ["SCHOOL","PUBLIC"]
        schoolPublicIn.setup(choices, colorSelected: self.navigationController!.view.tintColor!, colorDefault: UIColor.whiteColor())
        
        if TeamInfoGlobal.teamicon != nil{
            iconDisplay.image = TeamInfoGlobal.teamicon
        }
    }
    
    @IBAction func createTeam(sender: UIBarButtonItem) {
        
        var req = ARequest(prefix: "create_team/lol", method: requestType.POST, parameters: ["teamName":teamName.text, "teamIntro":teamIntro.text,"isSchool":true])
        req.delegate = self
        req.sendRequestWithToken(UserInfoGlobal.accessToken!)
        
    }
    
    func gotResult(prefix: String, result: AnyObject) {
        
        println(result)

        if(result["id"]? != nil){
            
            self.performSegueWithIdentifier("toTeamInfo", sender: self)
            
            println(result["id"])
        }

    }
    
    //get photo for team
    @IBAction func getPhoto(){
        
        let pickerC = UIImagePickerController()
        pickerC.delegate = self
        self.presentViewController(pickerC, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!) {
        self.dismissViewControllerAnimated(true, completion: nil);
        sourceImage =  info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
        self.performSegueWithIdentifier("addTeamImage", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addTeamImage"{
            
            var controller: Team_AddPhoto = segue.destinationViewController as Team_AddPhoto
            controller.sourceImage = self.sourceImage
        }
                
    }

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.teamName.transform = CGAffineTransformMakeTranslation(0, -100)
            self.icon.transform = CGAffineTransformMakeTranslation(0, -100)
            self.schoolPublicOut.transform = CGAffineTransformMakeTranslation(0, -100)
            self.teamIntro.transform = CGAffineTransformMakeTranslation(0, -100)
            self.iconDisplay.transform = CGAffineTransformMakeTranslation(0, -100)

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
            self.iconDisplay.transform = CGAffineTransformMakeTranslation(0, 0)

            
            
            }
            , completion: {
                (value: Bool) in
                
        })
        return true
    }
    
    func backGroundTapped(gestureRecognizer: UITapGestureRecognizer){
        teamName.resignFirstResponder()
        teamIntro.resignFirstResponder()
        }
    
    @IBAction func returnToCreate(segue : UIStoryboardSegue) {


    }
}

