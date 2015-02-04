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

    @IBOutlet var lolID : UITextField!
    @IBOutlet var school : UITextField!

    var sourceImage: UIImage!

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
        
        if (UserInfo.accessToken != "" && lolID.text != "" && school.text != "" ){
            var manager = Manager.sharedInstance
            // Specifying the Headers we need
            manager.session.configuration.HTTPAdditionalHeaders = [
                "token": UserInfo.accessToken
            ]

            var req = Alamofire.request(.POST, "http://54.149.235.253:5000/profile", parameters: ["username": UserInfo.name, "school":school.text,"lolID":lolID.text])
                .responseJSON { (_, _, JSON, _) in
                    var result: [String: AnyObject] = JSON as [String: AnyObject]
                    self.postProfile(result)
            }
            
 
         /*  upload image
           var r = Alamofire.upload(.POST,"http://54.149.235.253:5000/upload_profile_icon", sourceImage)
                     .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                     println(totalBytesWritten)
                     }
            */
            }
        else{
        //lol ID or school is empty
            
        
        }
        
    }
    func postProfile(result: [String: AnyObject]){
        
        println(result)
        
        UserInfo.lolID = self.lolID.text
        UserInfo.school = self.school.text
        UserInfo.icon = self.sourceImage
        if self.gender.selectedSegmentIndex == 1{
        UserInfo.gender = "Female"
        
        }
        else{
        UserInfo.gender = "Male"
        }
        println(UserInfo.lolID)
        println(UserInfo.school)
        println(UserInfo.gender)
        
        
       /*
        if (((result["message"] as String).rangeOfString("Please")?.isEmpty != nil) && result["status"] as String == "success") {
            println("OK")
            
            UserInfo.email = email.text
            UserInfo.name = nickname.text
            UserInfo.saveUserData()
            
            self.performSegueWithIdentifier("addSchoolAndPhoto", sender: self)
            
        }else{
            if((result["message"] as String).rangeOfString("Validation")?.isEmpty != nil){
                displaySpeaker("Invalid Email")
            }
            
            if((result["message"] as String).rangeOfString("Tried")?.isEmpty != nil){
                displaySpeaker("Your Account Already Exist")
            }

            
        }
        */ 
        
    }

    // after got photo   go to cropping view
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!) {
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
        lolID.resignFirstResponder()
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

        lolID.resignFirstResponder()
        
        return true
    }
    
    @IBAction func returnToLoginSchoolAndPhoto(segue : UIStoryboardSegue) {
        
    }
}
