
//
//  PeopleViewController.swift
//  Meeet Up
//
//  Created by Kedan Li on 14/11/18.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

class TeamViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, RequestResultDelegate{
    
    var hasOwnteam = false
    
    @IBOutlet weak var createTeam : UIView!
    
    
    @IBOutlet var otherChoices : UITableView!
    
    var teams: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

        if UserInfoGlobal.profile_ID == ""{
                UserInfoGlobal.updateUserInfo()
        }
        if(UserInfoGlobal.accessToken != ""){
            updateTeam()
        }
        //otherChoices.backgroundColor = UIColor.clearColor()
        
        teams = []
        
        // Do any additional setup after loading the view.
    }

    func updateTeam(){
        var req = ARequest(prefix:"my_team/lol" , method: requestType.GET, parameters: nil)
        req.delegate = self
        req.sendRequestWithToken(UserInfoGlobal.accessToken)

    }
    
    func gotResult(prefix: String, result: AnyObject) {

        if(prefix == "my_team/lol" ){
       if(result["id"]?  != nil ){
            TeamInfoGlobal.gotResult(result as [String : AnyObject])
            println(TeamInfoGlobal.team_Intro)
            println(TeamInfoGlobal.teamID)
            println(TeamInfoGlobal.teamName)
            
            self.performSegueWithIdentifier("presentMyTeam", sender: self)
            
            }
            else {
              println("not joined team yet")
            if ((result as? [String: AnyObject])?["message"] as? String)?.rangeOfString("Unauthorized")?.isEmpty != nil {
               
                 ((self.parentViewController as UINavigationController).parentViewController as MainViewController).tokennotvaild()
            }
            }
        }

    }
    
   
    func gotTeam(result: [String: AnyObject]){
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        ((self.parentViewController as UINavigationController).parentViewController as MainViewController).showTabb()
        
        if TeamInfoGlobal.teamID != ""{
            TeamInfoGlobal.uploadTeamInfo()
            self.performSegueWithIdentifier("presentMyTeam", sender: self)
        }

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
    
    
    @IBAction func returnToTeam(segue : UIStoryboardSegue) {
      
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
