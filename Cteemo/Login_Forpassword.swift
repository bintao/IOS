//
//  forpassword.swift
//  Cteemo
//
//  Created by bintao on 15/2/2.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire


class Login_Forpassword: UIViewController, UITextFieldDelegate{
    
    
    
    @IBOutlet var bg : UIImageView!
    
    @IBOutlet var email : UITextField!
   
    
    @IBOutlet var back : UIButton!
    
    @IBOutlet var signup : UIButton!
    
    @IBOutlet var loadingView : UIImageView!
    @IBOutlet var loading : UIActivityIndicatorView!
    
    @IBOutlet var teemoSpeaker : UIView!
    @IBOutlet var messageDisplay : UITextView!
    
    override func viewDidLoad() {
        //add tap gesture to board
        self.bg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "backGroundTapped:"))
        
    }
    
    @IBAction func submit_Password(sender: UIButton) {
        
        
        if (email.text != nil && email.text.rangeOfString("@")?.isEmpty != nil) {
        
        var req = Alamofire.request(.POST, "http://54.149.235.253:5000/forget_password", parameters: ["email": email.text])
        .responseJSON { (_, _, JSON, _) in
        var result: [String: AnyObject] = JSON as [String: AnyObject]
        self.gotSubmitResult(result)
        }
        
        self.startLoading()
        
        }else if email.text == "" || email.text.rangeOfString("@")?.isEmpty == nil{
        displaySpeaker("Email Invalid")
        }
        
        
    
    }
    
    func gotSubmitResult(result: [String: AnyObject]){
        
        stopLoading()
        
        println(result)
        
        // email with user
        if (((result["message"] as String).rangeOfString("Please")?.isEmpty != nil) && result["status"] as String == "success") {
            println("OK")
            
            
        }
        //can't find email
        else{
            if((result["message"] as String).rangeOfString("Validation")?.isEmpty != nil){
                displaySpeaker("Invalid Email")
            }
            
            
        }
        
        
    }
    
    
    
    // display the speaker on teemo
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
    
    
    // keyboard customization
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == email{
            email.resignFirstResponder()
        }
        return true
    }
    
    // background tapped
    func backGroundTapped(gestureRecognizer: UITapGestureRecognizer){
        email.resignFirstResponder()
        if teemoSpeaker.alpha != 0{
            disappearSpeaker()
        }
    }
    
    //loading view display while login
    func startLoading(){
        self.view.bringSubviewToFront(loadingView)
        self.loading.startAnimating()
    }
    
    //loading view hide, login finished
    func stopLoading(){
        self.view.sendSubviewToBack(loadingView)
        self.loading.stopAnimating()
    }
    
    
}