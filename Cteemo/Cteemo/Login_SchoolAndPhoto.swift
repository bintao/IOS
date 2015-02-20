//
//  Login_SchoolAndPhoto.swift
//  Cteemo
//
//  Created by Kedan Li on 15/1/24.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire


class Login_SchoolAndPhoto: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RequestResultDelegate{
    
    @IBOutlet var bg : UIImageView!
    @IBOutlet var submit : UIButton!
    @IBOutlet var gender: UISegmentedControl!
    @IBOutlet var addPhoto : UIButton!
    @IBOutlet var iconDisplay : UIImageView!
    @IBOutlet var lolName : UITextField!
    @IBOutlet var school : UITextField!
    
    var sourceImage: UIImage!
    
    @IBOutlet var teemoSpeaker : UIView!
    @IBOutlet var messageDisplay : UITextView!
    
    override func viewDidLoad() {
        //add tap gesture to board
        bg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "backGroundTapped:"))
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if UserInfoGlobal.icon != nil{
            iconDisplay.image = UserInfoGlobal.icon
        }
        
    }
    
    // get photo of user
    @IBAction func getPhoto(sender : UIButton) {
        
        // get photo from system album
        let pickerC = UIImagePickerController()
        pickerC.delegate = self
        self.presentViewController(pickerC, animated: true, completion: nil)
        
    }
    
    
    @IBAction func submitProfile(sender: UIButton) {
        
        if (UserInfoGlobal.accessToken != "" && lolName.text != "" && school.text != "" ){
            
            //upload user profile
            var req = ARequest(prefix: "profile", method: requestType.POST, parameters: ["username": UserInfoGlobal.name, "school":school.text,"lolID":lolName.text])
            req.delegate = self
            req.sendRequestWithToken(UserInfoGlobal.accessToken)
            
            
        }
        else{
            //lol ID or school is empty
            self.displaySpeaker("lolID or school is empty")
            
        }
        
    }
    
    func gotResult(prefix: String, result: AnyObject) {
        
        if prefix == "profile"{
            
            LolAPIGlobal.lolName = self.lolName.text
<<<<<<< HEAD
      
=======
>>>>>>> FETCH_HEAD
            if self.gender.selectedSegmentIndex == 1{
                UserInfoGlobal.gender = "Female"
            }else{
                UserInfoGlobal.gender = "Male"
            }
            UserInfoGlobal.school = self.school.text
            
            UserInfoGlobal.saveUserData()
            
            if (LolAPIGlobal.lolID != ""){
                
               // self.performSegueWithIdentifier("gotololID", sender: self)
                
            }
            else {
                //can't find lolID
            self.displaySpeaker("We can't find your lolID information please check your ID")
            }
            
            var re = ARequest()
            re.uploadPhoto()
        }else if prefix == LolAPIGlobal.key {
<<<<<<< HEAD
                     LolAPIGlobal.getIDresult((result as [String: AnyObject])[LolAPIGlobal.lolName] as [String: AnyObject])
        
=======
            LolAPIGlobal.getIDresult((result as [String: AnyObject])[LolAPIGlobal.lolName] as [String: AnyObject])
>>>>>>> FETCH_HEAD
            
        }
        
    }
    
    
    // after got photo   go to cropping view
    func imagePickerController(picker: UIImagePickerController!,
        
        didFinishPickingMediaWithInfo info: NSDictionary!) {
            
<<<<<<< HEAD
            self.dismissViewControllerAnimated(true, completion: nil);
         
=======
            self.dismissViewControllerAnimated(true, completion: nil)
            
>>>>>>> FETCH_HEAD
            sourceImage =  info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
            self.performSegueWithIdentifier("addImage", sender: self)
            
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addImage"{
            
            var controller: Login_AddPhoto = segue.destinationViewController as Login_AddPhoto
            controller.sourceImage = self.sourceImage
            
        }
        
    }
    
    // background tapped
    func backGroundTapped(gestureRecognizer: UITapGestureRecognizer){
        lolName.resignFirstResponder()
    }
    
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if textField == school{
            self.performSegueWithIdentifier("searchSchool", sender: self)
            return false
        }
        return true
    }
    
    // keyboard customization
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        lolName.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == lolName {
            
            LolAPIGlobal.getSummonerID(self.lolName.text, loginView: Login_SchoolAndPhoto())
        }
    }

    func displaySpeaker(text: String){
        messageDisplay.text = text
        
        if teemoSpeaker.alpha != 1{
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                self.teemoSpeaker.alpha = 1
                
                }
                , completion: {
                    (value: Bool) in
                    
            })
        }
    }
    
    // speaker on teemo disappear
    
    func disappearSpeaker(){
        if teemoSpeaker.alpha != 0{
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                self.teemoSpeaker.alpha = 0
                
                }
                , completion: {
                    (value: Bool) in
                    
            })
        }
        
    }
    
    @IBAction func returnToLoginSchoolAndPhoto(segue : UIStoryboardSegue) {
        
    }
}
