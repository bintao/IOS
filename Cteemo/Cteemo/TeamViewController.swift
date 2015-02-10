
//
//  PeopleViewController.swift
//  Meeet Up
//
//  Created by Kedan Li on 14/11/18.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

class TeamViewController: UIViewController , UITableViewDataSource, UITableViewDelegate  {
    
    var hasOwnteam = false
    
    @IBOutlet var createTeam : UIView!
    @IBOutlet var teamInfo : UIView!
    
    @IBOutlet var otherChoices : UITableView!
    
    var teams: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = ["token": UserInfo.accessToken]
        
        var req = Alamofire.request(.GET, "http://54.149.235.253:5000/my_team/lol")
            .responseJSON { (_, _, JSON, _) in
                if JSON != nil{
                    var result: [String: AnyObject] = JSON as [String: AnyObject]
                    self.gotTeam(result)
                }
                
        }
        

        
        otherChoices.backgroundColor = UIColor.clearColor()
        
        teams = ["My Boy","I'm the king","Sunrise","Cicicici","God of Michigan"]
        
        // Do any additional setup after loading the view.
    }
    
    
    func gotTeam(result: [String: AnyObject]){
        
        println(result)
        
        if(result["id"]?  != nil ){
            // joined team
            
            var captain = (((result["captain"] as [AnyObject])[0] as [String: AnyObject])["profile_id"] as String)
            
            if(captain != UserInfo.profile_ID){
                println("You are not a captain.")
                println(UserInfo.profile_ID)
            }
                
            else {
                
                self.performSegueWithIdentifier("presentMyTeam", sender: self)
                
                println("You are a captain.")
                
            }
            
            
            TeamInfo.teamID = result["id"] as String
            TeamInfo.teamName = result["teamName"] as String
            TeamInfo.team_Intro = result["teamIntro"] as String
            
            TeamInfo.saveUserData()
            println(TeamInfo.teamID)
            println(TeamInfo.teamName)
            println(TeamInfo.team_Intro)
            
        }
        else {
            println("not joined team yet")
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        ((self.parentViewController as UINavigationController).parentViewController as MainViewController).showTabb()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != "presentMyTeam"{
            ((self.parentViewController as UINavigationController).parentViewController as MainViewController).hideTabb()
        }
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
        
        var backButton = UIButton()
        backButton.frame.size = createTeam.frame.size
        backButton.setImage(UIImage(named: "white"), forState: UIControlState.Normal)
        cell.addSubview(backButton)
        
        var cellIcon = UIImageView(image: UIImage(named: "Forma 1"))
        cellIcon.frame = CGRectMake(10, 10, 60, 60)
        cell.addSubview(cellIcon)
        
        var teamName = UILabel(frame: CGRectMake(85, 15, 200, 27))
        teamName.text = teams[indexPath.row]
        teamName.textColor = UIColor.darkGrayColor()
        teamName.font = UIFont(name: "AvenirNext-Medium", size: 18)
        cell.addSubview(teamName)
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
