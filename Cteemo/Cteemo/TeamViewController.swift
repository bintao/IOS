
//
//  PeopleViewController.swift
//  Meeet Up
//
//  Created by Kedan Li on 14/11/18.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

class TeamViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, RequestResultDelegate {
    
    var hasOwnteam = false
    
    @IBOutlet weak var createTeam : UIView!
    @IBOutlet var teamInfo : UIView!
    
    @IBOutlet var otherChoices : UITableView!
    
    var teams: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = ["token": UserInfoGlobal.accessToken!]
        
        
        var req = ARequest(prefix:"my_team/lol" , method: requestType.GET, parameters: nil)
        req.delegate = self
        req.sendRequestWithToken(UserInfoGlobal.accessToken!)

        otherChoices.backgroundColor = UIColor.clearColor()
        
        teams = ["My Boy","I'm the king","Sunrise","Cicicici","God of Michigan"]
        
        // Do any additional setup after loading the view.
    }
    
    func gotResult(prefix: String, result: AnyObject) {
        println(prefix + "dsdd")
        println(result)
    }
    
    
    func gotTeam(result: [String: AnyObject]){
        
        println(result)
        
        if(result["id"]?  != nil ){
            // joined team
            
            var captain = (((result["captain"] as [AnyObject])[0] as [String: AnyObject])["profile_id"] as String)
            
            if(captain != UserInfoGlobal.profile_ID){
                println("You are not a captain.")
                println(UserInfoGlobal.profile_ID)
            }
                
            else {
                
                println("You are a captain.")
                
            }
            
            
            TeamInfoGlobal.teamID = result["id"] as? String
            TeamInfoGlobal.teamName = result["teamName"] as? String
            TeamInfoGlobal.team_Intro = result["teamIntro"] as? String
            
            TeamInfoGlobal.saveUserData()

            self.performSegueWithIdentifier("presentMyTeam", sender: self)
            
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
