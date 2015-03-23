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
        
        
            var chatViewController : RCChatViewController = RCIM.sharedRCIM().createPrivateChat("17", title: "self answer", completion:nil)
        
        UINavigationBar.appearance().tintColor = UserInfoGlobal.UIColorFromRGB(0xE74C3C)
        
            ((self.parentViewController as UINavigationController).parentViewController as MainViewController).hideTabb()
            
            self.navigationController?.pushViewController(chatViewController, animated: true)
        
    }
    
    
    @IBAction func getlist(sender: AnyObject) {
        
       
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
