//
//  Team_TeamInfoViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/8.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

class Team_TeamInfoViewController: UIViewController, RequestResultDelegate{
    
    @IBOutlet var navigation : UINavigationItem!

    @IBOutlet var memberScroll : UIScrollView!
   
    @IBOutlet var capTain : UIButton!
    @IBOutlet var capTainName : UILabel!

    var members = ["kedan", "jake", "Tom", "Father","BOSS"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation.title = TeamInfoGlobal.teamName
        
        capTain.setImage(UserInfoGlobal.icon, forState: UIControlState.Normal)
        capTainName.text = UserInfoGlobal.name
        
        memberScroll.contentSize = CGSizeMake(75 * CGFloat(members.count), 75)
        for var index = 0; index < members.count; index++ {
            var but = UIButton(frame: CGRectMake(5 + 75 * CGFloat(index), 10, 65, 65))
            but.setImage(UserInfoGlobal.icon, forState: UIControlState.Normal)
            memberScroll.addSubview(but)
            
            var lab = UILabel(frame: CGRectMake(75 * CGFloat(index), 75, 75, 20))
            lab.textAlignment = NSTextAlignment.Center
            lab.text = members[index]
            lab.font = capTainName.font
            memberScroll.addSubview(lab)
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    //Enable editing member
    @IBAction func editMember(sender: UIButton){
        
        sender.setTitle("Cancel", forState: UIControlState.Normal)
    }
       
    override func viewDidAppear(animated: Bool) {
        
    }

    @IBAction func leaveteam(sender: AnyObject) {
        
        var req = ARequest(prefix: "create_team/lol", method: requestType.DELETE)
        req.delegate = self
        req.sendRequestWithToken(UserInfoGlobal.accessToken)

    }
    
    func gotResult(prefix: String, result: AnyObject) {
        
        if((result as [String:AnyObject])["status"] as String == "success")
        {
            TeamInfoGlobal.cleanUserData()
            self.performSegueWithIdentifier("returnToTeam", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toTeamInfo(segue : UIStoryboardSegue) {
        
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
