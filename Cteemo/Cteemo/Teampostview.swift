//
//  Teampostview.swift
//  Cteemo
//
//  Created by bintao on 15/3/24.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit


class Teampostview: UIViewController,UITextViewDelegate,RequestResultDelegate {
    
    @IBOutlet var post: UIButton!
    
    
    @IBOutlet var content: UITextView!
    

    override func viewDidAppear(animated: Bool) {
        
        
        content.becomeFirstResponder()
        content.delegate = self
        self.post.enabled = false
        
    }
    
    override func viewDidLoad(){
    
        
        
    
    
    }
    

    @IBAction func post(sender: AnyObject) {
        
        
        if content.text != ""{
            if TeamInfoGlobal.findplayer {
                var req = ARequest(prefix: "team_post", method: requestType.POST, parameters: ["content": self.content.text])
                req.delegate = self
                req.sendRequestWithToken(UserInfoGlobal.accessToken)
            
            }
            else{
                var req = ARequest(prefix: "player_post", method: requestType.POST, parameters: ["content": self.content.text])
                req.delegate = self
                req.sendRequestWithToken(UserInfoGlobal.accessToken)
            }
        }
    }
    
    
    func gotResult(prefix: String, result: AnyObject) {
        
        if result["status"] != nil {
            var str = result["status"] as! String
            if str == "success"{
                
                self.performSegueWithIdentifier("backtojoin", sender: self)
                
            }
        }
    }
    
    
    
     func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
       
       
            if content.text != ""{
             self.post.titleLabel?.textColor = UserInfoGlobal.UIColorFromRGB(0xE74A52)
                self.post.enabled = true
            }
            else{
                 self.post.titleLabel?.textColor = UIColor.lightGrayColor()
                 self.post.enabled = false
        
            }
            return true
        
    }
    
  




}