//
//  Team_FindTeamViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/4.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class Team_FindTeamViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,RequestResultDelegate{
    
    
    @IBOutlet var search: UISearchBar!
    @IBOutlet var loading : UIActivityIndicatorView!
    @IBOutlet var resultTable : UITableView!
    
    
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
        
                var req = Alamofire.request(.GET, "http://54.149.235.253:5000/search_profile", parameters: [ "username":searchBar.text])
                    .responseJSON { (_, _, JSON, _) in
                        self.stopLoading()
                    
                        println(JSON)
                        if ((JSON as? [String: AnyObject])?["message"] as? String)?.rangeOfString("Unauthorized")?.isEmpty != nil {
                            
                        }
                        else if JSON? != nil{
                            println(JSON)
                            self.teams = JSON as [AnyObject]
                            var result: [AnyObject] = [AnyObject]()
                            result = JSON as [AnyObject]
                            self.gotResult(result)
                          
                        }
                        
                }
            
            }
            else{
            
                var req = Alamofire.request(.GET, "http://54.149.235.253:5000/search_team/lol", parameters: [ "teamName":searchBar.text])
                    .responseJSON { (_, _, JSON, _) in
                        self.stopLoading()
                        
                        println(JSON)
                        if ((JSON as? [String: AnyObject])?["message"] as? String)?.rangeOfString("Unauthorized")?.isEmpty != nil {
                            
                        }
                        else if JSON? != nil{
                            println(JSON)
                            self.teams = JSON as [AnyObject]
                            var result: [AnyObject] = [AnyObject]()
                            result = JSON as [AnyObject]
                            self.gotResult(result)
                        }
                        
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

        
        if TeamInfoGlobal.findplayer {
            
             if (teams[indexPath.row] as? [String: AnyObject])?["username"]? != nil{
            
            if !((teams[indexPath.row] as? [String: AnyObject])?["profile_icon"]? is NSNull){
                
            iconurl = (teams[indexPath.row] as [String: AnyObject])["profile_icon"] as String
                
            }
            if !((teams[indexPath.row] as? [String: AnyObject])?["school"]? is NSNull){
                
            school = (teams[indexPath.row] as [String: AnyObject])["school"] as String
            }
            else{
            
            school = "No School"
            
            }
            
           
            name =  (teams[indexPath.row] as [String: AnyObject])["username"] as String
            }
            
            
            }
            
        else
        {
            if  (teams[indexPath.row] as? [String: AnyObject])?["teamIcon"] != nil {
              
                
                iconurl = (teams[indexPath.row] as [String: AnyObject])["teamIcon"] as String
                school =  (teams[indexPath.row] as [String: AnyObject])["captain"] as String
                name =  (teams[indexPath.row] as [String: AnyObject])["teamName"] as String
            
            }
            
            
        }
        
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        var backButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.width, 80))
        backButton.setImage(UIImage(named: "white"), forState: UIControlState.Normal)
        cell.addSubview(backButton)
        
        var cellIcon = UIImageView(image: nil)
        
        ImageLoader.sharedLoader.imageForUrl(iconurl, completionHandler:{(image: UIImage?, url: String) in
            println(url)
            if image? != nil {
                cellIcon.image = image
            }else{
            
                cellIcon.image = UIImage(named: "Forma 1")
            }
            })

        cellIcon.frame = CGRectMake(10, 10, 60, 60)
        cell.addSubview(cellIcon)
        
        
        var teamName = UILabel(frame: CGRectMake(85, 15, 200, 27))
        teamName.textColor = UIColor.darkGrayColor()
        teamName.text = name
        teamName.font = UIFont(name: "AvenirNext-Medium", size: 18)
        cell.addSubview(teamName)
        
        
        
        var captain = UILabel(frame: CGRectMake(85, 45, 200, 27))
        if TeamInfoGlobal.findplayer {
        captain.text = "School : " + school
        }
        else{
            
        captain.text = "Captain : " + school
            
        }
        captain.textColor = UIColor.darkGrayColor()
        captain.font = UIFont(name: "AvenirNext-Regular", size: 13)
        cell.addSubview(captain)
        
        
        var contactCaptain = UIButton(frame: CGRectMake(self.view.frame.width - 60, 20, 40, 40))
        contactCaptain.setImage(UIImage(named: "adddd"), forState: UIControlState.Normal)
        contactCaptain.addTarget(self, action: "contactCap:", forControlEvents: UIControlEvents.TouchUpInside)
        contactCaptain.tag = indexPath.row
        cell.addSubview(contactCaptain)

               return cell
    }


    
    func contactCap(sender : UIButton){
        
        println(sender.tag)
        
        
        if TeamInfoGlobal.findplayer {
            
            if (teams[sender.tag] as? [String: AnyObject])?["profile_id"] != nil{
                var username = ""
                
                var id = (teams[sender.tag] as [String: AnyObject])["profile_id"] as String
                
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
        else if (teams[sender.tag] as? [String: AnyObject])?["teamName"] != nil{
        
        var teamname = (teams[sender.tag] as [String: AnyObject])["teamName"] as String
        
        let alert = SCLAlertView()
        alert.addButton("Join team now!"){
            self.startLoading()
            var req = ARequest(prefix: "my_team/lol", method: requestType.POST, parameters: ["teamName": teamname])
            req.delegate = self
            req.sendRequestWithToken(UserInfoGlobal.accessToken)
            self.stopLoading()
            
            }
            
        alert.showCustom(self.parentViewController?.parentViewController, image: UIImage(named: "error.png")!, color: UserInfoGlobal.UIColorFromRGB(0x2ECC71), title: "Join Team request", subTitle: "I want to be part of " + teamname,closeButtonTitle: "Cancel", duration: 0.0)
       
        
        }
        
      
    
    }
    
    func gotResult(prefix: String, result: AnyObject) {
    
        
        println(result)
    
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        search.resignFirstResponder()
        return true
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
