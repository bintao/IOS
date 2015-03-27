
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
        if( teamName.text != "" ){
        var req = Alamofire.request(.POST, "http://54.149.235.253:5000/create_team/lol", parameters: ["teamName":teamName.text, "teamIntro":teamIntro.text,"isSchool":true])
            .responseJSON { (_, _, JSON, _) in
                if JSON != nil{
                   var result: [String: AnyObject] = JSON as [String: AnyObject]
                self.getResult(result)
                }
            }
        }
        else{
            
            let alert = SCLAlertView()
            alert.showError(self.parentViewController?.parentViewController, title: "Empty Team name", subTitle: "Please fill your team name", closeButtonTitle: "ok", duration: 0.0)
        
        }

        
        }
    
    func getResult(result: [String: AnyObject]) {
        println(result)
        if result["message"]? != nil{
        
            if (result["message"] as String).rangeOfString("Tried to save")?.isEmpty != nil{
            
                     let alert = SCLAlertView()
                alert.showError(self.parentViewController?.parentViewController, title: "Team name exised", subTitle: "Please enter team name again", closeButtonTitle: "ok", duration: 0.0)
                
            
            }
        }

       if(result["id"]? != nil){
            TeamInfoGlobal.gotResult(result)
        
            println(TeamInfoGlobal.teamName+TeamInfoGlobal.team_isschool+TeamInfoGlobal.iscaptain)
            var req1 = ARequest(prefix: "upload_team_icon/lol", method: requestType.POST)
            req1.delegate = self
            req1.uploadPhoto("teamicon.png")
            
            
            self.performSegueWithIdentifier("toTeamInfo", sender: self)
        }

    }
    
    
    func gotResult(prefix: String, result: AnyObject) {
    
    print(result)
        
        if result["teamIcon"]? != nil {
            
            TeamInfoGlobal.teamicon_link = result["teamIcon"] as String
        }
        else {TeamInfoGlobal.teamicon_link = "" }
        
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

