//
//  Team_TeamInfoViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/8.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

class Team_TeamInfoViewController: UIViewController, RequestResultDelegate{
    
    @IBOutlet var navigation : UINavigationItem!

    @IBOutlet var memberScroll : UIScrollView!
   
    @IBOutlet weak var teamicon: UIImageView!
    
    @IBOutlet var capTain : UIButton!
    @IBOutlet var capTainName : UILabel!

    var members = ["kedan", "jake", "Tom", "Father","BOSS"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TeamInfoGlobal.uploadTeamInfo()
        navigation.title = TeamInfoGlobal.teamName
        println(UserInfoGlobal.profile_icon_Link)
        
        capTain.setImage(UserInfoGlobal.icon, forState: UIControlState.Normal)
        capTainName.text = UserInfoGlobal.name
        
        memberScroll.contentSize = CGSizeMake(75 * CGFloat(members.count), 75)
        for var index = 0; index < members.count; index++ {
            var but = UIButton(frame: CGRectMake(5 + 75 * CGFloat(index), 10, 65, 65))
            but.setImage(UserInfoGlobal.icon, forState: UIControlState.Normal)
            memberScroll.addSubview(but)
            
            var lab = UILabel(frame: CGRectMake(75 * CGFloat(index), 75, 75, 20))
            lab.textAlignment = NSTextAlignment.Center
            lab.text = members[index]
            lab.font = capTainName.font
            memberScroll.addSubview(lab)
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    //Enable editing member
    @IBAction func editMember(sender: UIButton){
        
        sender.setTitle("Cancel", forState: UIControlState.Normal)
    }
       
    override func viewDidAppear(animated: Bool) {
        println(memberScroll.frame)
        
         ((self.parentViewController as UINavigationController).parentViewController as MainViewController).showTabb()
        
        if TeamInfoGlobal.teamicon != nil{
            
        self.teamicon.image = DataManager.getTeamIconFromLocal()
        
        }
        else if TeamInfoGlobal.teamicon_link != ""{
            ImageLoader.sharedLoader.imageForUrl(TeamInfoGlobal.teamicon_link, completionHandler:{(image: UIImage?, url: String) in
                println(url)
                if image? != nil {
                    self.teamicon.image = image
                }
                else {
                    self.teamicon.image = UIImage(named: "error.png")!
                }})
        }
        

    }

    @IBAction func leaveteam(sender: AnyObject) {
        let alert1 = SCLAlertView()
        
        alert1.addButton("ok", actionBlock:{ (Void) in
            var req = ARequest(prefix: "create_team/lol", method: requestType.DELETE)
            req.delegate = self
            req.sendRequestWithToken(UserInfoGlobal.accessToken)
        })
       alert1.showNotice(self.parentViewController?.parentViewController, title: "Leave Team", subTitle: "Do you want to leave " + TeamInfoGlobal.teamName, closeButtonTitle: "cancel", duration: 0.0)
        

    }
    
    func gotResult(prefix: String, result: AnyObject) {
        println(result)
        if (result as [String:AnyObject])["status"]? != nil{
        if((result as [String:AnyObject])["status"] as String == "success")
        {
            TeamInfoGlobal.cleanUserData()
            self.performSegueWithIdentifier("returnToTeam", sender: self)
        }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func toTeamInfo(segue : UIStoryboardSegue) {
        
    }


    @IBAction func groupchat(sender: AnyObject) {
        
        var chatViewController : RCChatViewController = RCIM.sharedRCIM().createGroupChat("12", title: "cteemo", completion: nil)
        
        ((self.parentViewController as UINavigationController).parentViewController as MainViewController).hideTabb()
        
        self.navigationController?.pushViewController(chatViewController, animated: true)
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
