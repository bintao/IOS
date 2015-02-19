//
//  Login_SchoolAndPhoto.swift
//  Cteemo
//
//  Created by Kedan Li on 15/1/24.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire


class Login_SchoolAndPhoto: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
        if UserInfo.icon != nil{
            iconDisplay.image = UserInfo.icon
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
        
        if (UserInfo.accessToken != "" && lolName.text != "" && school.text != "" ){

            var manager = Manager.sharedInstance
            // Specifying the Headers we need

            
            
            manager.session.configuration.HTTPAdditionalHeaders = [
                "token": UserInfo.accessToken!
                ]
            var req = Alamofire.request(.POST, "http://54.149.235.253:5000/profile", parameters: ["username": UserInfo.name!, "school":school.text,"lolID":lolName.text])
                .responseJSON { (_, _, JSON, _) in
                    var result: [String: AnyObject] = JSON as [String: AnyObject]
                    self.gotResult(result)
            }
            
            //println(UserInfo.lolID)
            if (UserInfo.lolID != ""){
                
                self.performSegueWithIdentifier("gotololID", sender: self)
            
            }
            else {
                //can't find lolID
            self.displaySpeaker("We can't find your lolID information please check your ID")
            }
            
            var re = ARequest()
            re.uploadPhoto()
            

        }
        else{
        //lol ID or school is empty
          self.displaySpeaker("lolID or school is empty")
        
        }
        
    }
    
    

    //got the result from the server
   func gotResult(result: [String: AnyObject]){
                
        UserInfo.lolName = self.lolName.text
        
        if self.gender.selectedSegmentIndex == 1{
            
            UserInfo.gender = "Female"
            
        }else{
            
            UserInfo.gender = "Male"
        
        }
        
        UserInfo.school = self.school.text
        
        UserInfo.saveUserData()
    
        lolapi.getSummonerID(UserInfo.lolName!)
        //self.performSegueWithIdentifier("goToMain", sender: self)
        
    }

    // after got photo   go to cropping view
    func imagePickerController(picker: UIImagePickerController!,
        
        didFinishPickingMediaWithInfo info: NSDictionary!) {
        
        self.dismissViewControllerAnimated(true, completion: nil);
        println(info);
            
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
