//
//  Team_FindTeamViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/4.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit


class Team_FindTeamViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,RequestResultDelegate{
    
    
    @IBOutlet var search: UISearchBar!
    @IBOutlet var loading : UIActivityIndicatorView!
    @IBOutlet var resultTable : UITableView!
    
    
    var id = ""
    
    var teams: [AnyObject] = [AnyObject]()

    
    override func viewDidLoad()
    {
        
        resultTable.backgroundColor = UIColor.clearColor()
        
    }
    

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if UserInfoGlobal.accessToken != ""{
        var manager = Manager.sharedInstance
        // Specifying the Headers we need
        manager.session.configuration.HTTPAdditionalHeaders = [
            "token": UserInfoGlobal.accessToken
        ]
        
        startLoading()
            if TeamInfoGlobal.findplayer {
        
                var req = request(.GET, "http://54.149.235.253:5000/search_profile", parameters: [ "username":searchBar.text])
                    .responseJSON { (_, _, JSONdata, _) in
                        self.stopLoading()
                        if JSONdata != nil {
                        let myjson = JSON(JSONdata!)
                        println(JSONdata)
                        if let unauthorized = myjson["message"].string
                        {
                            
                            if (unauthorized.rangeOfString("Unauthorized")?.isEmpty != nil)
                            {
                            
                            
                            }
                        
                        }
                        else if JSONdata != nil{
                            
                            var result: [AnyObject] = [AnyObject]()
                            result = JSONdata as! [AnyObject]
                            self.gotResult(result)
                          
                        }
                        }// check nil
                }
            
            }
            else{
            
                var req = request(.GET, "http://54.149.235.253:5000/search_team/lol", parameters: [ "teamName":searchBar.text])
                    .responseJSON { (_, _, JSONdata, _) in
                        self.stopLoading()
                        if JSONdata != nil{
                        
                        println(JSONdata)
                        let myjson = JSON(JSONdata!)
                        
                        if let unauthorized = myjson["message"].string
                        {
                            
                            if (unauthorized.rangeOfString("Unauthorized")?.isEmpty != nil)
                            {
                                
                                
                            }
                            
                        }
                        else if JSONdata != nil{
                            var result: [AnyObject] = [AnyObject]()
                            result = JSONdata as! [AnyObject]
                            self.gotResult(result)
                            
                        }
                            
                        }// check nil
                        
                }
            
            
            }
           
        }
    }
    
    func gotResult(result: [AnyObject]){
        
        teams = result
        
        
        resultTable.reloadData()
            
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var iconurl : String = ""
        var school : String = ""
        var name : String = ""
        var id : String = ""
        
        if TeamInfoGlobal.findplayer {
            
             if !((teams[indexPath.row] as! [String: AnyObject])["profile_id"] is NSNull){
            
            if !((teams[indexPath.row] as! [String: AnyObject])["profile_icon"] is NSNull){
                
            iconurl = (teams[indexPath.row] as! [String: AnyObject])["profile_icon"] as! String
                
            }
                
            if !((teams[indexPath.row] as! [String: AnyObject])["school"] is NSNull){
                
            school = (teams[indexPath.row] as! [String: AnyObject])["school"] as! String
            }
                
            else{
            
            school = "No School"
            
            }
            if !((teams[indexPath.row] as! [String: AnyObject])["username"] is NSNull){
                    
            name = (teams[indexPath.row] as! [String: AnyObject])["username"] as! String
            
            } else{
                
            name = "No Name"
            }
                
            id =  (teams[indexPath.row] as! [String: AnyObject])["profile_id"] as! String
            
            }// name is nil
            
            
            }
            
        else
        {
            if  (teams[indexPath.row] as! [String: AnyObject])["teamID"] != nil {
              
                if !((teams[indexPath.row] as! [String: AnyObject])["teamIcon"] is NSNull){
                    
                iconurl = (teams[indexPath.row] as! [String: AnyObject])["teamIcon"] as! String
                    
                }
              
                if !((teams[indexPath.row] as! [String: AnyObject])["captain"] is NSNull){
                school =  (teams[indexPath.row] as! [String: AnyObject])["captain"] as! String

                
                }
                if !((teams[indexPath.row] as! [String: AnyObject])["teamName"] is NSNull){
                    
                name =  (teams[indexPath.row] as! [String: AnyObject])["teamName"] as! String
                    
                }
            }
            
            
        }
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        if cell == nil {
            
        cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        
        }
        var backButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.width, 80))
        if TeamInfoGlobal.findplayer{
            
        backButton.addTarget(self, action: "viewinfo:", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.tag = id.toInt()!
        }
        backButton.setImage(UIImage(named: "white"), forState: UIControlState.Normal)
        
        cell!.addSubview(backButton)
        
        var cellIcon = UIImageView(image: nil)
        cellIcon.image = UIImage(named: "error.png")!
        
        ImageLoader.sharedLoader.imageForUrl(iconurl, completionHandler:{(image: UIImage?, url: String) in
            if image != nil {
                cellIcon.image = image
            }else{
            
                cellIcon.image = UIImage(named: "error.png")!
            }
            })

        cellIcon.frame = CGRectMake(10, 10, 60, 60)
       

        cell!.addSubview(cellIcon)
        
        var teamName = UILabel(frame: CGRectMake(85, 15, 200, 27))
        teamName.textColor = UIColor.darkGrayColor()
        teamName.text = name
        teamName.font = UIFont(name: "AvenirNext-Medium", size: 18)
        cell!.addSubview(teamName)
        
        var captain = UILabel(frame: CGRectMake(85, 45, 200, 27))
        if TeamInfoGlobal.findplayer {
        captain.text = "School : " + school
        }
        else{
        captain.text = "Captain : " + school
        }
        captain.textColor = UIColor.darkGrayColor()
        captain.font = UIFont(name: "AvenirNext-Regular", size: 13)
        cell!.addSubview(captain)
        
        
        var contactCaptain = UIButton(frame: CGRectMake(self.view.frame.width - 60, 20, 40, 40))
        contactCaptain.setImage(UIImage(named: "adddd"), forState: UIControlState.Normal)
        contactCaptain.addTarget(self, action: "contactCap:", forControlEvents: UIControlEvents.TouchUpInside)
        contactCaptain.tag = indexPath.row
        cell!.addSubview(contactCaptain)

        return cell!
    }

    func  viewinfo(sender : UIButton){
    
        if TeamInfoGlobal.findplayer {
        
            
        self.id = "\(sender.tag)"
        if self.id != ""
        {
            
        self.performSegueWithIdentifier("playerinfo", sender: self)
        
        }
       
        
        }
    
    
    }
    
    func contactCap(sender : UIButton){
        
        if TeamInfoGlobal.findplayer {
            
            if (teams[sender.tag] as? [String: AnyObject])?["profile_id"] != nil{
                var username = ""
                
                var id = (teams[sender.tag] as! [String: AnyObject])["profile_id"] as! String
                
                if (teams[sender.tag] as! [String: AnyObject])["username"] != nil{
                    
                username = (teams[sender.tag] as! [String: AnyObject])["username"] as! String
                
                }
                let alert = SCLAlertView()
                alert.addButton("Sent Invite!"){
                    self.startLoading()
                    var req = ARequest(prefix: "manage_team/lol", method: requestType.POST, parameters: ["profileID": id])
                    req.delegate = self
                    req.sendRequestWithToken(UserInfoGlobal.accessToken)
                    self.stopLoading()
                    
                }
                
                alert.showCustom(self.parentViewController?.parentViewController?.parentViewController, image: UIImage(named: "error.png")!, color: UserInfoGlobal.UIColorFromRGB(0x333333), title: "Invite request", subTitle: "I want to invite " + username,closeButtonTitle: "Cancel", duration: 0.0)
            
            }
        
        }
        
        else if (teams[sender.tag] as? [String: AnyObject])?["teamName"] != nil{
        
        var teamname = (teams[sender.tag] as! [String: AnyObject])["teamName"] as! String
        
        let alert = SCLAlertView()
        alert.addButton("Join team now!"){
            self.startLoading()
            var req = ARequest(prefix: "my_team/lol", method: requestType.POST, parameters: ["teamName": teamname])
            req.delegate = self
            req.sendRequestWithToken(UserInfoGlobal.accessToken)
            self.stopLoading()
            
            }
            
            alert.showCustom(self.parentViewController?.parentViewController, image: UIImage(named: "error.png")!, color: UserInfoGlobal.UIColorFromRGB(0x333333), title: "Join Team request", subTitle: "I want to be part of " + teamname,closeButtonTitle: "Cancel", duration: 0.0)
    
        }
        
      
    
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
        
        println(indexPath.row)
    }
   
    
    func gotResult(prefix: String, result: AnyObject) {

    
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        search.resignFirstResponder()
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "playerinfo"{
            
            var controller: Team_memberinfo = segue.destinationViewController as! Team_memberinfo
            controller.id = self.id
            
        }
        
        
    }
    // background tapped
    
    
    //loading view display while login
    func startLoading(){
        self.loading.startAnimating()
        resultTable.userInteractionEnabled = false
        search.userInteractionEnabled = false
    }
    
    //loading view hide, login finished
    func stopLoading(){
        self.loading.stopAnimating()
        resultTable.userInteractionEnabled = true
        search.userInteractionEnabled = true
    }
}
