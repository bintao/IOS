//
//  Team_playerpost.swift
//  Cteemo
//
//  Created by bintao on 15/3/25.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit


class Team_playerpost: UIViewController, UITableViewDataSource, UITableViewDelegate,RequestResultDelegate {

    @IBOutlet var resultTable: UITableView!
    
    @IBOutlet var loading: UIActivityIndicatorView!
    
    var teams: [AnyObject] = [AnyObject]()
    
   
    
    override func viewDidLoad() {
        resultTable.backgroundColor = UIColor.clearColor()
        resultTable.delegate = self
        resultTable.dataSource = self
        
        
        
    }
    override func viewDidAppear(animated: Bool) {
        search()
      
        
        
    }
    
 

    
    
    func search(){
        
        var manager = Manager.sharedInstance
        // Specifying the Headers we need
        manager.session.configuration.HTTPAdditionalHeaders = [
            "token": UserInfoGlobal.accessToken
        ]
        
        startLoading()
        
        var req = request(.GET, "http://54.149.235.253:5000/player_post", parameters: ["page": 0])
            .responseJSON { (_, _, JSON, _) in
                self.stopLoading()
                if ((JSON as? [String: AnyObject])?["message"] as? String)?.rangeOfString("Unauthorized")?.isEmpty != nil {
                    
                }
                else if(JSON != nil){
                    println(JSON)
                    self.teams = JSON as [AnyObject]
                    var result: [AnyObject] = [AnyObject]()
                    result = JSON as [AnyObject]
                    self.gotResult(result)
                }
                
        }
    }
    
    func gotResult(result: [AnyObject]){
        teams = result
        println(teams.count)
        
        self.resultTable.reloadData()
        
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var iconurl :String = ""
        var username :String = ""
        var content : String = ""
        
        if ((teams[indexPath.row] as? [String: AnyObject])?["user_profile"] as? [String: AnyObject])?["profile_icon"]? != nil
        {
            
            iconurl = ((teams[indexPath.row] as [String: AnyObject])["user_profile"] as [String: AnyObject])["profile_icon"] as String
            
            
            if !(((teams[indexPath.row] as? [String: AnyObject])?["user_profile"] as? [String: AnyObject])?["username"]? is NSNull){
                
                username = ((teams[indexPath.row] as [String: AnyObject])["user_profile"] as [String: AnyObject])["username"] as String
                
            }
            
            if !((teams[indexPath.row] as? [String: AnyObject])?["content"]? is NSNull){
                content = (teams[indexPath.row] as [String: AnyObject])["content"] as String
            }
            else {
            content = " nothing to say"
            }
            
        }
        
      
        
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        var backButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.width, 80))
        backButton.setImage(UIImage(named: "white"), forState: UIControlState.Normal)
        cell.addSubview(backButton)
        
        var cellIcon = UIImageView(image: nil)
        
        ImageLoader.sharedLoader.imageForUrl(iconurl, completionHandler:{(image: UIImage?, url: String) in
            if image? != nil {
                cellIcon.image = image
            }else{
                
                cellIcon.image = UIImage(named: "Forma 1")
            }
        })
        cellIcon.frame = CGRectMake(10, 10, 60, 60)
        cell.addSubview(cellIcon)
        
        var userName = UILabel(frame: CGRectMake(85, 15, 200, 27))
        userName.textColor = UIColor.darkGrayColor()
        userName.text = username
        userName.font = UIFont(name: "AvenirNext-Medium", size: 18)
        cell.addSubview(userName)
        
        
        var school = UILabel(frame: CGRectMake(85, 45, 200, 27))
        
        school.text = content
        school.textColor = UIColor.darkGrayColor()
        school.font = UIFont(name: "AvenirNext-Regular", size: 13)
        cell.addSubview(school)
        
        
        var joinTeam = UIButton(frame: CGRectMake(self.view.frame.width / 2, 80, self.view.frame.width / 2, 30))
          joinTeam.setBackgroundImage(UIImage(named: "postbu.png")!, forState: UIControlState())
        
        joinTeam.addTarget(self, action: "invite:", forControlEvents: UIControlEvents.TouchUpInside)
        joinTeam.tag = indexPath.row
        cell.addSubview(joinTeam)
        
        var contact = UIButton(frame: CGRectMake(0, 80, self.view.frame.width / 2, 30))
        
        contact.setBackgroundImage(UIImage(named: "postsomething.png")!, forState: UIControlState())
        contact.addTarget(self, action: "contactplayer:", forControlEvents: UIControlEvents.TouchUpInside)
         contact.tag = indexPath.row
        cell.addSubview(contact)
        
        
        var ccaptain = UILabel(frame: CGRectMake(0, 80, self.view.frame.width / 2, 30))
        ccaptain.text = "Contact Player"
        ccaptain.textAlignment = NSTextAlignment.Center
        ccaptain.textColor = UIColor.whiteColor()
        ccaptain.font = UIFont(name: "AvenirNext-Medium", size: 17)
        cell.addSubview(ccaptain)
        
        var join = UILabel(frame: CGRectMake(self.view.frame.width / 2, 80, self.view.frame.width / 2, 30))
        join.text = "Invite him !!"
        join.textAlignment = NSTextAlignment.Center
        join.textColor = UIColor.whiteColor()
        join.font = UIFont(name: "AvenirNext-Medium", size: 17)
        cell.addSubview(join)
        
        return cell
    }
    
    
    
    
    func contactplayer(sender : AnyObject){
        
        if ((teams[sender.tag] as? [String: AnyObject])?["user_profile"] as? [String : AnyObject])?["id"] != nil {
            
            var id = ((teams[sender.tag] as [String: AnyObject])["user_profile"] as [String : AnyObject])["id"]  as String
            
            var name = ((teams[sender.tag] as [String: AnyObject])["user_profile"] as [String : AnyObject])["username"]  as String
            
            var content = (teams[sender.tag] as [String: AnyObject])["content"] as String
            
          
            println(sender.tag)

            
            var chatViewController : RCChatViewController = RCIM.sharedRCIM().createPrivateChat(id, title: name , completion: nil)
            
            self.navigationController?.pushViewController(chatViewController, animated: true)
            
            
        }


    }
    
    func invite(sender : AnyObject){
        
        
        if ((teams[sender.tag] as? [String: AnyObject])?["user_profile"] as? [String : AnyObject])?["id"] != nil {
            
            var username = ""
            
            var id = ((teams[sender.tag] as [String: AnyObject])["user_profile"] as [String : AnyObject])["id"] as String
            
            if (teams[sender.tag] as? [String: AnyObject])?["username"] != nil{
                username = (teams[sender.tag] as [String: AnyObject])["username"] as String
            }
            
            let alert = SCLAlertView()
            alert.addButton("Sent Invite!"){
                self.startLoading()
                var req = ARequest(prefix: "manage_team/lol", method: requestType.POST, parameters: ["profileID": id])
                req.delegate = self
                req.sendRequestWithToken(UserInfoGlobal.accessToken)
                self.stopLoading()
                
            }
            
            
            alert.showCustom(self.parentViewController?.parentViewController?.parentViewController, image: UIImage(named: "error.png")!, color: UserInfoGlobal.UIColorFromRGB(0x2ECC71), title: "Invite request", subTitle: "I want to invite " + username,closeButtonTitle: "Cancel", duration: 0.0)
            
        }
        
        
    }
    
    func gotResult(prefix: String, result: AnyObject) {
        
        
            println(result)
    }
    
    //loading view display while login
    func startLoading(){
        self.loading.startAnimating()
        resultTable.userInteractionEnabled = false
    }
    
    //loading view hide, login finished
    func stopLoading(){
        self.loading.stopAnimating()
        resultTable.userInteractionEnabled = true
    }
}