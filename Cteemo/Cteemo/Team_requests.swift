//
//  Team_requests.swift
//  Cteemo
//
//  Created by bintao on 15/3/25.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//


import UIKit



class Team_requests: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet var loading: UIActivityIndicatorView!

    @IBOutlet var resultTable: UITableView!

     var requests: [AnyObject] = [AnyObject]()
    
    
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
        
        if TeamInfoGlobal.iscaptain == "no" || TeamInfoGlobal.iscaptain == ""{
        var req = request(.GET, "http://54.149.235.253:5000/invite_request/lol", parameters: ["page": 0])
            .responseJSON { (_, _, JSON, _) in
                self.stopLoading()
                 println(JSON)
                if ((JSON as? [String: AnyObject])?["message"] as? String)?.rangeOfString("Unauthorized")?.isEmpty != nil {
                     
                }
                else if JSON != nil && JSON as? [AnyObject]? != nil {
                    self.requests = JSON as [AnyObject]
                    var result: [AnyObject] = [AnyObject]()
                    result = JSON as [AnyObject]
                    self.gotResult(result)
                }
        }
        }else if TeamInfoGlobal.iscaptain == "yes" {
        
            var req = request(.GET, "http://54.149.235.253:5000/join_request/lol", parameters: ["page": 0])
                .responseJSON { (_, _, JSON, _) in
                    self.stopLoading()
                    println(JSON)
                    if ((JSON as? [String: AnyObject])?["message"] as? String)?.rangeOfString("Unauthorized")?.isEmpty != nil {
                        
                    }
                    else if(JSON as? [AnyObject] != nil){
                        println(JSON)
                        var result: [AnyObject] = [AnyObject]()
                        result = JSON as [AnyObject]
                        self.gotResult(result)
                    }
            }
        
        
        }
        
        
    }
    
    func gotResult(result: [AnyObject]){
        requests = result
        println(requests.count)
        
        self.resultTable.reloadData()
        
    }
    
   
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 110
        
        }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var iconurl :String = ""
        var username :String = ""
        var school : String = ""
        
        if (requests[indexPath.row] as? [String: AnyObject])?["profile_icon"]? != nil
        {
            
            iconurl = (requests[indexPath.row] as [String: AnyObject])["profile_icon"] as String
            
            
            if !((requests[indexPath.row] as? [String: AnyObject])?["username"] is NSNull){
                
                username = (requests[indexPath.row] as [String: AnyObject])["username"] as String
                
            }
            
            if !((requests[indexPath.row] as? [String: AnyObject])?["school"]? is NSNull){
                school = (requests[indexPath.row] as [String: AnyObject])["school"] as String
            }
            else {
                school = "NO school"
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
        
        
        var schoolt = UILabel(frame: CGRectMake(85, 45, 200, 27))
        
        schoolt.text = school
        schoolt.textColor = UIColor.darkGrayColor()
        schoolt.font = UIFont(name: "AvenirNext-Regular", size: 13)
        cell.addSubview(schoolt)
        
        
        var Decline = UIButton(frame: CGRectMake(self.view.frame.width / 2, 80, self.view.frame.width / 2, 30))
        Decline.setBackgroundImage(UIImage(named: "postbu.png")!, forState: UIControlState())
        
        Decline.addTarget(self, action: "Decline:", forControlEvents: UIControlEvents.TouchUpInside)
        Decline.tag = indexPath.row
        cell.addSubview(Decline)
        
        var accept = UIButton(frame: CGRectMake(0, 80, self.view.frame.width / 2, 30))
        
        accept.setBackgroundImage(UIImage(named: "postsomething.png")!, forState: UIControlState())
        accept.addTarget(self, action: "accept:", forControlEvents: UIControlEvents.TouchUpInside)
        accept.tag = indexPath.row
        cell.addSubview(accept)
        
        
        var ccaptain = UILabel(frame: CGRectMake(0, 80, self.view.frame.width / 2, 30))
        ccaptain.text = "Accept"
        ccaptain.textAlignment = NSTextAlignment.Center
        ccaptain.textColor = UIColor.whiteColor()
        ccaptain.font = UIFont(name: "AvenirNext-Medium", size: 17)
        cell.addSubview(ccaptain)
        
        var join = UILabel(frame: CGRectMake(self.view.frame.width / 2, 80, self.view.frame.width / 2, 30))
        join.text = "Decline"
        join.textAlignment = NSTextAlignment.Center
        join.textColor = UIColor.whiteColor()
        join.font = UIFont(name: "AvenirNext-Medium", size: 17)
        cell.addSubview(join)

        
        return cell
        
    }
    func accept(sender : AnyObject){
    
        println(sender.tag)
       if (requests[sender.tag] as? [String: AnyObject])?["profile_id"]? != nil {
            
            var id = (requests[sender.tag] as [String: AnyObject])["profile_id"] as String
            var username = ""
            if !((requests[sender.tag] as? [String: AnyObject])?["username"] is NSNull){
                username = (requests[sender.tag] as [String: AnyObject])["username"] as String
            }
        
            let alert = SCLAlertView()
            let alert1 = SCLAlertView()
        
        
        
      
        
            alert.addButton("Accept!"){
                self.startLoading()
                
                var manager = Manager.sharedInstance
                manager.session.configuration.HTTPAdditionalHeaders = [
                    "token": UserInfoGlobal.accessToken
                ]
                
                if TeamInfoGlobal.iscaptain == "yes"{
                    
                    var req = request(.POST, "http://54.149.235.253:5000/join_request/lol",parameters: ["profileID": id])
                        .responseJSON { (_, _, JSONdata, _) in
                            
                            if JSONdata == nil {
                                
                                
                                
                            }
                                
                            else{
                                let myjson = JSON(JSONdata!)
                                
                                if let url = myjson["message"].string
                                {
                                    
                                alert1.showError(self.parentViewController?.parentViewController, title: "Player already joined a team", subTitle: " Sorry you can't add him", closeButtonTitle: nil, duration: 3.0)
                                    
                                    
                                }
                            }
                            
                            self.stopLoading()
                            self.search()
                            
                    }
                    
                    
                }
                    
                else{
                var req = request(.POST, "http://54.149.235.253:5000/invite_request/lol",parameters: ["profileID": id])
                    .responseJSON { (_, _, JSONdata, _) in
                        
                        println(JSONdata)
                        if JSONdata == nil {
                            
                            ((((self.parentViewController as UINavigationController).parentViewController as MainViewController).childViewControllers[1] as  UINavigationController).childViewControllers[0] as TeamViewController).toTeammatedIfNeede()
                            
                            
                        }
                            
                        else{
                        let myjson = JSON(JSONdata!)
                      
                            if let url = myjson["message"].string
                            {
                                if url.rangeOfString("joined")?.isEmpty != nil{
                                    alert1.showError(self.parentViewController?.parentViewController, title: "Alreday joned a Team", subTitle: " Sorry you can't join", closeButtonTitle: nil, duration: 3.0)
                                    
                                }
                                
                            }
                        }
                       
                        self.stopLoading()
                        self.search()
                    }
                    
                }//is not captain
            
            }//add button
            
        if TeamInfoGlobal.iscaptain == "yes"{
            
            alert.showCustom(self.parentViewController?.parentViewController, image: UIImage(named: "error.png")!, color: UserInfoGlobal.UIColorFromRGB(0x2ECC71), title: "Join request", subTitle: username + " Want join your team ",closeButtonTitle: "Cancel", duration: 0.0)
        
        }
        else{
            
            alert.showCustom(self.parentViewController?.parentViewController, image: UIImage(named: "error.png")!, color: UserInfoGlobal.UIColorFromRGB(0x2ECC71), title: "Invite request", subTitle: "I want to be part of " + username + "'s Team",closeButtonTitle: "Cancel", duration: 0.0)
            
        }
        
       
        
        }
        
        
        
        
        
        
        
    }
    
    
    func Decline(sender : AnyObject){

         if (requests[sender.tag] as? [String: AnyObject])?["profile_id"]? != nil  {
        
            var id = (requests[sender.tag] as [String: AnyObject])["profile_id"] as String
             var username = ""
            if !((requests[sender.tag] as? [String: AnyObject])?["username"] is NSNull){
                username = (requests[sender.tag] as [String: AnyObject])["username"] as String
            }
            
            
            
            let alert = SCLAlertView()
            alert.addButton("Decline!"){
                self.startLoading()
                var manager = Manager.sharedInstance
                manager.session.configuration.HTTPAdditionalHeaders = [
                    "token": UserInfoGlobal.accessToken
                ]
                var req = request(.DELETE, "http://54.149.235.253:5000/invite_request/lol",parameters: ["profileID": id])
                    .responseJSON { (_, _, JSON, _) in
                        println(JSON)
                        if (JSON as [String:AnyObject])["status"]? != nil{
                            if((JSON as [String:AnyObject])["status"] as String == "success")
                            {
                              self.search()
                            }
                        }
                        
                         self.stopLoading()
                }
             
               
            }
            
            alert.showCustom(self.parentViewController, image: UIImage(named: "error.png")!, color: UserInfoGlobal.UIColorFromRGB(0x2ECC71), title: "Invite request", subTitle: "I don't want to join " + username + "'s Team",closeButtonTitle: "Cancel", duration: 0.0)
            
        }
        
        
    }

    
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
