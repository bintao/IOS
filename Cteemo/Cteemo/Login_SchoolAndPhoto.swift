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
                "token": UserInfo.accessToken
            ]


            
            var req = Alamofire.request(.POST, "http://54.149.235.253:5000/profile", parameters: ["username": UserInfo.name, "school":school.text,"lolID":lolName.text])
                .responseJSON { (_, _, JSON, _) in
                    var result: [String: AnyObject] = JSON as [String: AnyObject]
                    self.gotResult(result)
            }
            
            var req1 = Alamofire.upload(.POST, "http://54.149.235.253:5000/upload_profile_icon", NSURL(fileURLWithPath: DataManager.getUserIconURL())!).responseJSON { (_, _, JSON, _) in
                print(JSON)
            }
            
        }
        else{
        //lol ID or school is empty

          
        
        }
        
    }

    
    //got the result from the server
    func gotResult(result: [String: AnyObject]){
                
        UserInfo.lolName = self.lolName.text
        UserInfo.saveUserData()
        
        if self.gender.selectedSegmentIndex == 1{
            UserInfo.gender = "Female"
        }else{
            UserInfo.gender = "Male"
        }
        UserInfo.school = self.school.text

        self.performSegueWithIdentifier("goToMain", sender: self)

        
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
        lolName.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == lolName{
           
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
    
    @IBAction func returnToLoginSchoolAndPhoto(segue : UIStoryboardSegue) {
        
    }
}
