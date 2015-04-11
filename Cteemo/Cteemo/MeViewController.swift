//
//  SelfViewController.swift
//  Meeet Up
//
//  Created by Kedan Li on 14/11/18.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit


class MeViewController: UIViewController  {

    
    @IBOutlet var username: UILabel!
   
    @IBOutlet var school: UILabel!

    @IBOutlet var usericon: UIImageView!
    
    @IBOutlet var unreadmessage: UIButton!
    
    
    var iconurl:String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        if UserInfoGlobal.accessToken != nil{
        var manager = Manager.sharedInstance
        // Specifying the Headers we need
        manager.session.configuration.HTTPAdditionalHeaders = [
            "token": UserInfoGlobal.accessToken
        ]
    
        var req = request(.GET, "http://54.149.235.253:5000/profile")
            .responseJSON { (_, _, JSONdata, _) in
                if JSONdata != nil {
                    
                
                    let myjson = JSON(JSONdata!)
                    if let name = myjson["username"].string{
                        self.username.text = name
                    }
                    else {
                        
                        self.username.text = ""
                    }
                    
                    if let school = myjson["school"].string{
                        self.school.text = school
                    }
                    
                    if let url = myjson["profile_icon"].string{
                        self.iconurl = url
                    }
                   
                    
                }
                
            
                
        }
            
            
    if UserInfoGlobal.profile_icon_Link != nil {
        ImageLoader.sharedLoader.imageForUrl(UserInfoGlobal.profile_icon_Link, completionHandler:{(image: UIImage?, url: String) in
            if image? != nil {
                self.usericon.image = image
            }
        })
        }
            
        if UserInfoGlobal.icon != nil {
        self.usericon.image = UserInfoGlobal.icon
        }
        
        
            
        }
        
        ((self.parentViewController as UINavigationController).parentViewController as MainViewController).showTabb()
        
    }

    func updatemesage(num : Int){
        
        println(num)
        
        if num < 99 && num > 0 {
            
             self.unreadmessage.setBackgroundImage(UIImage(named: "free button.png")!, forState: UIControlState.Normal)
            self.unreadmessage.setTitle("\(num)", forState: UIControlState.Normal)
           
            
        }
        else if num > 0{
            
           self.unreadmessage.setBackgroundImage(UIImage(named: "free button.png")!, forState: UIControlState.Normal)
            self.unreadmessage.setTitle("99", forState: UIControlState.Normal)
        }
        else if num == 0 {
        
             self.unreadmessage.setBackgroundImage(nil, forState: UIControlState.Normal)
            self.unreadmessage.setTitle("", forState: UIControlState.Normal)
        
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
 
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
            
        )
        
    }



    @IBAction func myinfo(sender: AnyObject) {
        
        
        
        
    }
   
    
    
    @IBAction func getlist(sender: AnyObject) {
        
        
        self.unreadmessage.setBackgroundImage(nil, forState: UIControlState.Normal)
        self.unreadmessage.setTitle("", forState: UIControlState.Normal)
        
        var list : RCChatListViewController =  RCIM.sharedRCIM().createConversationList { () -> Void in
            
        }
        
        ((self.parentViewController as UINavigationController).parentViewController as MainViewController).hideTabb()
        
        ((self.parentViewController as UINavigationController).parentViewController as MainViewController).cleanbadge()
        
        self.navigationController?.pushViewController(list, animated: true)
        
        
    }
    

    
    @IBAction func aboutCteemo(sender: AnyObject) {
        
        
        
    }
    
    @IBAction func facebookshare(sender: AnyObject) {
        
        
        
    }
    
    
    
    @IBAction func customservers(sender: AnyObject) {
        
        var chatViewController : RCChatViewController = RCIM.sharedRCIM().createCustomerService("KEFU1426185638731", title: "cteemo", completion: nil)
        
        UINavigationBar.appearance().tintColor = UserInfoGlobal.UIColorFromRGB(0xE74C3C)
        
        ((self.parentViewController as UINavigationController).parentViewController as MainViewController).hideTabb()
        
        self.navigationController?.pushViewController(chatViewController, animated: true)
        
        
    }
    
    
    @IBAction func log_out(sender: UIButton) {
        
        //clean all saved user data
        
        let alert1 = SCLAlertView()
        alert1.addButton("logout", actionBlock:{ (Void) in
            
             ((self.parentViewController as UINavigationController).parentViewController as MainViewController).logout()
            
        })
       alert1.showCustom(self.parentViewController?.parentViewController, image: UIImage(named: "error.png")!, color: UserInfoGlobal.UIColorFromRGB(0x2ECC71), title: "Log out CTeemo", subTitle: "Play tournament next time~ ",closeButtonTitle: "Cancel", duration: 0.0)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
