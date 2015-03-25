
//
//  Team_FindTeamPostsViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/5.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire


class Team_FindTeamPostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var loading : UIActivityIndicatorView!
    @IBOutlet var resultTable : UITableView!
    
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
        
        var req = Alamofire.request(.GET, "http://54.149.235.253:5000/team_post", parameters: ["page": 0])
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
        
        if ((teams[indexPath.row] as? [String: AnyObject])?["user_profile"] as? [String: AnyObject])?["profile_icon"]? != nil
        {
            
            iconurl = ((teams[indexPath.row] as [String: AnyObject])["user_profile"] as [String: AnyObject])["profile_icon"] as String
            if !(((teams[indexPath.row] as? [String: AnyObject])?["user_profile"] as? [String: AnyObject])?["username"]? is NSNull){
                
                username = ((teams[indexPath.row] as [String: AnyObject])["user_profile"] as [String: AnyObject])["username"] as String
                
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
        
        var teamName = UILabel(frame: CGRectMake(85, 15, 200, 27))
        teamName.textColor = UIColor.darkGrayColor()
        teamName.text = "Cteemo"
        teamName.font = UIFont(name: "AvenirNext-Medium", size: 18)
        cell.addSubview(teamName)
        
        
        var captain = UILabel(frame: CGRectMake(85, 45, 200, 27))
        
        captain.text = "Captain: " + username
        captain.textColor = UIColor.darkGrayColor()
        captain.font = UIFont(name: "AvenirNext-Regular", size: 13)
        cell.addSubview(captain)
        
        
        var joinTeam = UIButton(frame: CGRectMake(self.view.frame.width / 2, 80, self.view.frame.width / 2, 30))
        joinTeam.backgroundColor = UIColor.whiteColor()
        cell.addSubview(joinTeam)
        
         var contact = UIButton(frame: CGRectMake(0, 80, self.view.frame.width / 2, 30))
        
        contact.backgroundColor = UIColor.whiteColor()
        
        cell.addSubview(contact)
        
        
        var ccaptain = UILabel(frame: CGRectMake(0, 80, self.view.frame.width / 2, 30))
        ccaptain.text = "Contact Captain"
        ccaptain.textAlignment = NSTextAlignment.Center
        ccaptain.textColor = UserInfoGlobal.UIColorFromRGB(0xE74A52)
        ccaptain.font = UIFont(name: "AvenirNext-Medium", size: 17)
        cell.addSubview(ccaptain)
        
        var join = UILabel(frame: CGRectMake(self.view.frame.width / 2, 80, self.view.frame.width / 2, 30))
        join.text = "I want to join!"
        join.textAlignment = NSTextAlignment.Center
        join.textColor = UserInfoGlobal.UIColorFromRGB(0xE74A52)
        join.font = UIFont(name: "AvenirNext-Medium", size: 17)
        cell.addSubview(join)
        
        return cell
    }
    
    func contactCap(sender : AnyObject){
        
        
    
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
