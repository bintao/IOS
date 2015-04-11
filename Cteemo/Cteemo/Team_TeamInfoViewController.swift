//
//  Team_TeamInfoViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/8.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

class Team_TeamInfoViewController: UIViewController, RequestResultDelegate{
    
    @IBOutlet var navigation : UINavigationItem!

    @IBOutlet var memberScroll : UIScrollView!
   
    @IBOutlet weak var teamicon: UIImageView!
    
    @IBOutlet var capTain : UIButton!
    @IBOutlet var capTainName : UILabel!
   
    @IBOutlet var edit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TeamInfoGlobal.uploadTeamInfo()
        navigation.title = TeamInfoGlobal.teamName
        
        
        // Do any additional setup after loading the view.
    }

    //Enable editing member
    @IBAction func editMember(sender: UIButton){
        
        
      
    }

    override func viewDidAppear(animated: Bool) {
      
      
        self.memberScroll.reloadInputViews()
        TeamInfoGlobal.uploadTeamInfo()
        navigation.title = TeamInfoGlobal.teamName
       
        if TeamInfoGlobal.teamName != nil && TeamInfoGlobal.teamID != nil {
          
            var grouplist = [AnyObject]()
            
            var team = RCGroup.alloc()
            team.groupId = TeamInfoGlobal.teamID
            team.groupName = TeamInfoGlobal.teamName
            grouplist.append(team)
            
            
            RCIM.sharedRCIM().syncGroups(grouplist, completion: { () -> Void in
                
                }, error: nil)
            
        capTain.setImage(TeamInfoGlobal.captainIcon, forState: UIControlState.Normal)
        capTainName.text = TeamInfoGlobal.captainName
            
        if TeamInfoGlobal.iscaptain == nil {
            
            self.edit.alpha = 0
            
        }
        
            let subviews = self.memberScroll.subviews
            
            for subview in subviews{
                subview.removeFromSuperview()
            }
            var membersName = TeamInfoGlobal.memberName
            var membersIcon = TeamInfoGlobal.memberIcon
            
            memberScroll.contentSize = CGSizeMake(75 * CGFloat(membersName.count), 75)
            for var index = 0; index < TeamInfoGlobal.memberCount; index++ {
                var but = UIButton(frame: CGRectMake(5 + 75 * CGFloat(index), 10, 65, 65))
                ImageLoader.sharedLoader.imageForUrl(TeamInfoGlobal.memberIcon[index] as String, completionHandler:{(image: UIImage?, url: String) in
                    
                    if image? != nil {
                        
                        but.setImage(image, forState: UIControlState.Normal)
                        
                    }
                    else {
                        but.setImage(UIImage(named: "error.png")!, forState: UIControlState.Normal)
                        
                    }})
                
                memberScroll.addSubview(but)
                
                var lab = UILabel(frame: CGRectMake(75 * CGFloat(index), 75, 75, 20))
                lab.textAlignment = NSTextAlignment.Center
                
                lab.text = TeamInfoGlobal.memberName[index] as? String
                lab.font = capTainName.font
                memberScroll.addSubview(lab)
                
            }

     
         ((self.parentViewController as UINavigationController).parentViewController as MainViewController).showTabb()
        
        if TeamInfoGlobal.teamicon != nil && DataManager.getTeamIconFromLocal() != nil{
            
        self.teamicon.image = DataManager.getTeamIconFromLocal()
        
        }
        else if TeamInfoGlobal.teamicon_link != nil{
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
            
        else{
            
            self.performSegueWithIdentifier("returnToTeam", sender: self)
            
        }
        

    }

    
    
    @IBAction func leaveteam(sender: AnyObject) {
        let alert1 = SCLAlertView()
        let alert2 = SCLAlertView()
        var manager = Manager.sharedInstance
        // Specifying the Headers we need
        manager.session.configuration.HTTPAdditionalHeaders = [
            "token": UserInfoGlobal.accessToken
        ]
        
        if TeamInfoGlobal.iscaptain != nil &&  TeamInfoGlobal.iscaptain == "yes"{
        alert1.addButton("Delete", actionBlock:{ (Void) in
            alert2.showWaiting(self.parentViewController?.parentViewController, title: "Wait a second", subTitle: "Quiting......", closeButtonTitle: nil, duration: 0.0)
            var req = request(.DELETE, "http://54.149.235.253:5000/create_team/lol")
                .responseJSON { (_, _, JSON, _) in
                    alert2.hideView()
                    if (JSON as [String:AnyObject])["status"]? != nil{
                        if((JSON as [String:AnyObject])["status"] as String == "success")
                        {
                            TeamInfoGlobal.cleanUserData()
                            TeamInfoGlobal.findplayer = false
                            self.performSegueWithIdentifier("returnToTeam", sender: self)
                        }
                    }
            }
        
        })
            alert1.showNotice(self.parentViewController?.parentViewController, title: "Delete Team", subTitle: "You are a captain , Team need you." + TeamInfoGlobal.teamName, closeButtonTitle: "cancel", duration: 0.0)
            
        }
        else if TeamInfoGlobal.iscaptain == nil {
            alert1.addButton("Leave", actionBlock:{ (Void) in
                  alert2.showWaiting(self.parentViewController?.parentViewController, title: "Wait a second", subTitle: "Quiting......", closeButtonTitle: nil, duration: 0.0)
                var req = request(.DELETE, "http://54.149.235.253:5000/my_team/lol")
                    .responseJSON { (_, _, JSON, _) in
                         alert2.hideView()
                        if (JSON as [String:AnyObject])["status"]? != nil{
                            if((JSON as [String:AnyObject])["status"] as String == "success")
                            {
                                TeamInfoGlobal.cleanUserData()
                                TeamInfoGlobal.findplayer = false
                                self.performSegueWithIdentifier("returnToTeam", sender: self)
                                
                            }
                        }
                }
                
            })
            alert1.showNotice(self.parentViewController?.parentViewController, title: "Leave Team", subTitle: "Do you want to leave " + TeamInfoGlobal.teamName, closeButtonTitle: "cancel", duration: 0.0)
        }
            
        else {
        
        
        
        }
        
        
       

    }
    
    func gotResult(prefix: String, result: AnyObject) {
        
        if prefix == "my_team//lol"{
            println(result)
        }
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func toTeamInfo(segue : UIStoryboardSegue) {
        
    }


    @IBAction func groupchat(sender: AnyObject) {
        
        
       
        

        
        var chatViewController : RCChatViewController = RCIM.sharedRCIM().createGroupChat(TeamInfoGlobal.teamID, title: TeamInfoGlobal.teamName, completion: nil)
        
        ((self.parentViewController as UINavigationController).parentViewController as MainViewController).clearnteambadge()
        
        ((self.parentViewController as UINavigationController).parentViewController as MainViewController).hideTabb()
        
        self.navigationController?.pushViewController(chatViewController, animated: true)
        
    }
    
    
    
    @IBAction func findteammate(sender: AnyObject) {
        
        ((self.parentViewController as UINavigationController).parentViewController as MainViewController).hideTabb()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "findteammate"{
            
            var controller: Team_JoinTeamViewController = segue.destinationViewController as Team_JoinTeamViewController
            controller.join = true
            
        }
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
