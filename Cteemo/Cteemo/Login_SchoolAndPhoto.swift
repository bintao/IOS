//
//  Login_SchoolAndPhoto.swift
//  Cteemo
//
//  Created by Kedan Li on 15/1/24.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire


class Login_SchoolAndPhoto: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate {

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
                "token": "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQyMzg4NDg4OCwiaWF0IjoxNDIzNTI0ODg4fQ.IjU0ZDQyOGZiMDU1MWRjMWYxMTdjOTZhNiI.--n9JSm00dvVZng9g8eDlD3-cRgxFITYIHG-qxruDrc"//UserInfo.accessToken
            ]
            //manager.session.configuration.HTTPAdditionalHeaders = ["Content-Type" : "multipart/form-data"]

            var req = Alamofire.request(.POST, "http://54.149.235.253:5000/profile", parameters: ["username": UserInfo.name, "school":school.text,"lolID":lolName.text])
                .responseJSON { (_, _, JSON, _) in
                    var result: [String: AnyObject] = JSON as [String: AnyObject]
                    self.gotResult(result)
            }
            
            //println(UserInfo.lolID)
            if (UserInfo.lolID != ""){
                
                //self.performSegueWithIdentifier("gotololID", sender: self)
            
            }
         /*
            var request = NSMutableURLRequest(URL:NSURL(string: "")!)http://54.149.235.253:5000/upload_profile_icon
            request.HTTPMethod = "POST"
            request.addValue(UserInfo.accessToken, forHTTPHeaderField: "token")
            var contentype = "multipart/form-data;"
            request.setValue(contentype, forHTTPHeaderField: "Content-Type")
            
            Alamofire.upload(request, )
                .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                println(totalBytesWritten)
                println(bytesWritten)
                }
                .responseJSON { (_, _, JSON, _) in
                    println(JSON)
            }
        */
            //uploadFileToUrl()
            
            let URL = NSURL(string: "http://httpbin.org/get")!
            var request = NSURLRequest(URL: URL)
            
            
            
            
            Alamofire.upload(.POST, "http://54.149.235.253:5000/upload_profile_icon", UIImageJPEGRepresentation(UserInfo.icon, 1))
                .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                    println(totalBytesWritten)
                    println(bytesWritten)
                }
                .responseJSON { (_, _, JSON, _) in
                    println(JSON)
            }
            
        }
        else{
        //lol ID or school is empty
        
          
        
        }
        
    }
    
    
    func uploadFileToUrl(){
        
        var request = NSMutableURLRequest(URL:NSURL(string: "http://54.149.235.253:5000/upload_profile_icon")!)
        request.HTTPMethod = "POST"
        request.addValue(UserInfo.accessToken, forHTTPHeaderField: "token")
    
    
        var boundary = "----------------------------6f875f2289c9"
        var contentype = "multipart/form-data;"
        //request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(contentype, forHTTPHeaderField: "Content-Type")
        
        var body = NSMutableData()
        body.appendData("\r\n--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition: form-data; name=\"upload\"; \r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(UIImagePNGRepresentation(UserInfo.icon))
        body.appendData("\r\n--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)

        request.setValue("\(body.length)", forHTTPHeaderField: "Content-Length")
        
        request.HTTPBody = body
        println("miraqui \(request.debugDescription)")
        
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        var HTTPError: NSError? = nil
        var JSONError: NSError? = nil
        
        
        var dataVal: NSData? =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: &HTTPError)
        
        if ((dataVal != nil) && (HTTPError == nil)) {
            var jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(dataVal!, options: NSJSONReadingOptions.MutableContainers, error: &JSONError)
            
            if (JSONError != nil) {
                println("Bad JSON")
            } else {
                println("Synchronous\(jsonResult)")
            }
        } else if (HTTPError != nil) {
            println("Request failed")
        } else {
            println("No Data returned")
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
    
        lolapi.getSummonerID(UserInfo.lolName)
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
