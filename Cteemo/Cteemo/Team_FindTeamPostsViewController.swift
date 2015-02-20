
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
        search()
    }
    
    func search(){
        
        var manager = Manager.sharedInstance
        // Specifying the Headers we need
        manager.session.configuration.HTTPAdditionalHeaders = [
            "token": UserInfoGlobal.accessToken
        ]
        
        startLoading()
        var req = Alamofire.request(.GET, "http://54.149.235.253:5000/team_post", parameters:[String: AnyObject]())
            .responseJSON { (_, _, JSON, _) in
                println(JSON)
                if JSON != nil{
                    println(JSON)
                }
                self.stopLoading()
                
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
        
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        var backButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.width, 80))
        backButton.setImage(UIImage(named: "white"), forState: UIControlState.Normal)
        cell.addSubview(backButton)
        
        var cellIcon = UIImageView(image: UIImage(named: "Forma 1"))
        cellIcon.frame = CGRectMake(10, 10, 60, 60)
        cell.addSubview(cellIcon)
        
        var teamName = UILabel(frame: CGRectMake(85, 15, 200, 27))
        teamName.textColor = UIColor.darkGrayColor()
        teamName.text = (teams[indexPath.row] as [String: AnyObject])["teamName"] as? String
        teamName.font = UIFont(name: "AvenirNext-Medium", size: 18)
        cell.addSubview(teamName)
        
        
        var captain = UILabel(frame: CGRectMake(85, 45, 200, 27))
        captain.text = "Captain: " + ((teams[indexPath.row] as [String: AnyObject])["captain"] as String)
        captain.textColor = UIColor.darkGrayColor()
        captain.font = UIFont(name: "AvenirNext-Regular", size: 13)
        cell.addSubview(captain)
        
        var contactCaptain = UIButton(frame: CGRectMake(self.view.frame.width - 60, 20, 40, 40))
        contactCaptain.setImage(UIImage(named: "adddd"), forState: UIControlState.Normal)
        cell.addSubview(contactCaptain)
        
        /*
        var joinTeam = UIButton(frame: CGRectMake(self.view.frame.width / 2, 80, self.view.frame.width / 2, 30))
        joinTeam.backgroundColor = self.navigationController!.view.tintColor!
        cell.addSubview(joinTeam)
        
        
        var ccaptain = UILabel(frame: CGRectMake(0, 80, self.view.frame.width / 2, 30))
        ccaptain.text = "Contact Captain"
        ccaptain.textAlignment = NSTextAlignment.Center
        ccaptain.textColor = UIColor.whiteColor()
        ccaptain.font = UIFont(name: "AvenirNext-Medium", size: 17)
        cell.addSubview(ccaptain)
        
        var join = UILabel(frame: CGRectMake(self.view.frame.width / 2, 80, self.view.frame.width / 2, 30))
        join.text = "I want to join!"
        join.textAlignment = NSTextAlignment.Center
        join.textColor = UIColor.whiteColor()
        join.font = UIFont(name: "AvenirNext-Medium", size: 17)
        cell.addSubview(join)
        */
        return cell
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
