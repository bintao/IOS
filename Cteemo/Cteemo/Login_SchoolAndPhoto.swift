//
//  Login_SchoolAndPhoto.swift
//  Cteemo
//
//  Created by Kedan Li on 15/1/24.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

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
