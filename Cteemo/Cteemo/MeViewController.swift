//
//  SelfViewController.swift
//  Meeet Up
//
//  Created by Kedan Li on 14/11/18.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit

class MeViewController: UIViewController  {

    @IBOutlet weak var logout: UIButton!
    
    @IBOutlet var rong: UIButton!
    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        var img = UIImageView(image: UserInfoGlobal.icon)
        img.frame = CGRectMake(100, 100, 100, 100)
        self.view.addSubview(img)
        
       
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(animated: Bool) {
          ((self.parentViewController as UINavigationController).parentViewController as MainViewController).showTabb()
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



    @IBAction func rongtest(sender: AnyObject) {
        
        //KgLJaeVjsIyWv3PRLdqkYriSPvCjR9Lj4In18RCEVuwrzFaSzav844KZM4q65MyO9TmJ6QHsPsU= " 1
        
        //"b3rDNPQmJIpBeq1QXvNOez7ZGryb3Xip4jqmBYclOnCJR3FPmXnadpAdgB2RyT/oEB5/N5xrURN+Dp6+HsM1Qw==" 88
        

            
            var chatViewController : RCChatViewController = RCIM.sharedRCIM().createPrivateChat("88", title: "self answer", completion:nil)
        
        UINavigationBar.appearance().tintColor = UserInfoGlobal.UIColorFromRGB(0xE74C3C)
        
            ((self.parentViewController as UINavigationController).parentViewController as MainViewController).hideTabb()
            
            self.navigationController?.pushViewController(chatViewController, animated: true)
            
                MMProgressHUD.dismissWithSuccess("Success")
        
        
        
    }
    
    
    @IBAction func getlist(sender: AnyObject) {
        
        //"b3rDNPQmJIpBeq1QXvNOez7ZGryb3Xip4jqmBYclOnCJR3FPmXnadpAdgB2RyT/oEB5/N5xrURN+Dp6+HsM1Qw=="
       
            
            var chatViewController : RCChatViewController = RCIM.sharedRCIM().createCustomerService("KEFU1426185510333", title: "cteemo", completion: nil)
        
        UINavigationBar.appearance().tintColor = UserInfoGlobal.UIColorFromRGB(0xE74C3C)
        
            ((self.parentViewController as UINavigationController).parentViewController as MainViewController).hideTabb()
            
            self.navigationController?.pushViewController(chatViewController, animated: true)
        
        
    }
    
    
    
    @IBAction func group(sender: AnyObject) {
        
        
        
        
        
    }
    
    
    
    @IBAction func log_out(sender: UIButton) {
        
        //clean all saved user data

         ((self.parentViewController as UINavigationController).parentViewController as MainViewController).logout()
        
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
