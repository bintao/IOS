//
//  Login_SchoolAndPhoto.swift
//  Cteemo
//
//  Created by Kedan Li on 15/1/24.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

class Login_SchoolAndPhoto: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RequestResultDelegate{
    
    @IBOutlet var bg : UIImageView!
    @IBOutlet var submit : UIButton!
    @IBOutlet var gender: UISegmentedControl!
    @IBOutlet var addPhoto : UIButton!
    @IBOutlet var iconDisplay : UIImageView!
    @IBOutlet var lolName : UITextField!
    @IBOutlet var school : UITextField!
    
    var sourceImage: UIImage!
    var name : String = ""
    var lolid : String = ""
    
    @IBOutlet var teemoSpeaker : UIView!
    @IBOutlet var messageDisplay : UITextView!
    
    override func viewDidLoad() {
        //add tap gesture to board
        bg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "backGroundTapped:"))
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if UserInfoGlobal.icon != nil{
            iconDisplay.image = UserInfoGlobal.icon
            UserInfoGlobal.saveUserIcon()
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

        //upload user profile

        if (UserInfoGlobal.accessToken != nil && lolName.text != "" && school.text != "" ){
            if (LolAPIGlobal.lolID != nil){
                self.lolid = lolName.text
                self.performSegueWithIdentifier("gotololid", sender: self)
        
            }
            else {
                //can't find lolID
                self.displaySpeaker("We can't find your lolID information please check your ID")
            }
            
        }
        else{
            
            //lol ID or school is empty
            self.displaySpeaker("lolID or school is empty")
            
        }
        
    }
    
    func gotResult(prefix: String, result: AnyObject) {
        
        
         if prefix == LolAPIGlobal.key {
            
            println(LolAPIGlobal.lolName)
            
            
            if LolAPIGlobal.lolName != nil && (result as! [String: AnyObject])[LolAPIGlobal.lolName] as? [String: AnyObject] != nil {
                
                LolAPIGlobal.getIDresult((result as! [String: AnyObject])[LolAPIGlobal.lolName] as! [String: AnyObject])
            
            }
                
                

        }
        
    }
    
    
    
    
    // after got photo   go to cropping view
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
            
            self.dismissViewControllerAnimated(true, completion: nil);
         
            sourceImage =  (info as NSDictionary).objectForKey(UIImagePickerControllerOriginalImage) as! UIImage
            self.performSegueWithIdentifier("addImage", sender: self)
            
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addImage"{
            
            var controller: Login_AddPhoto = segue.destinationViewController as! Login_AddPhoto
            controller.sourceImage = self.sourceImage
            
        }
        if segue.identifier == "gotololid"{
            
            var controller: Login_lolID = segue.destinationViewController as! Login_lolID
            var gender = ""
            if self.gender.selectedSegmentIndex == 1{
                gender = "Female"
            }else{
                gender = "Male"
            }
            controller.gender = gender
            controller.school = self.school.text
            controller.name = self.name
            controller.clolname = LolAPIGlobal.lolName
            
        }
        
        
        
    }
    
    // background tapped
    func backGroundTapped(gestureRecognizer: UITapGestureRecognizer){
        lolName.resignFirstResponder()
        if teemoSpeaker.alpha != 0{
            disappearSpeaker()
        }
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
            if self.lolName.text != "" && self.lolName.endEditing(true){
                
                var str: String = self.lolName.text.lowercaseString
                var newStr = str.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
           
        
            LolAPIGlobal.lolName = newStr
            LolAPIGlobal.saveLOLData()
            LolAPIGlobal.getSummonerID(newStr, loginView: Login_SchoolAndPhoto())
                
            }
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
