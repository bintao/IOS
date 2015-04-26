//
//  Team_DeleteMember.swift
//  Cteemo
//
//  Created by bintao on 15/3/29.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit



class Team_DeleteMember: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet var loading: UIActivityIndicatorView!
    
    @IBOutlet var resultTable: UITableView!
    
    override func viewDidAppear(animated: Bool) {
        
        
        resultTable.backgroundColor = UIColor.clearColor()
        resultTable.delegate = self
        resultTable.dataSource = self
         resultTable.reloadData()
        
        
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return TeamInfoGlobal.memberName.count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 80
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    
    {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        var backButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.width, 80))
        backButton.setImage(UIImage(named: "white"), forState: UIControlState.Normal)
        cell.addSubview(backButton)
        
        var iconurl = TeamInfoGlobal.memberIcon[indexPath.row] as! String
        var name = TeamInfoGlobal.memberName[indexPath.row] as! String
        
        var cellIcon = UIImageView(image: nil)
        
        
        ImageLoader.sharedLoader.imageForUrl(iconurl, completionHandler:{(image: UIImage?, url: String) in
            println(url)
            if image != nil {
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
        
        
        /*
        
        var captain = UILabel(frame: CGRectMake(85, 45, 200, 27))
        if TeamInfoGlobal.findplayer {
      
        captain.textColor = UIColor.darkGrayColor()
        captain.font = UIFont(name: "AvenirNext-Regular", size: 13)
        cell.addSubview(captain)
        
        */
        
        var DeleteMember = UIButton(frame: CGRectMake(self.view.frame.width - 60, 20, 40, 40))
        DeleteMember.setImage(UIImage(named: "minussss.png"), forState: UIControlState.Normal)
        DeleteMember.addTarget(self, action: "deleteMember:", forControlEvents: UIControlEvents.TouchUpInside)
        DeleteMember.tag = indexPath.row
        cell.addSubview(DeleteMember)
        
        return cell

    }
    
    
    func deleteMember(sender : UIButton){
        
        //curl localhost:5000/manage_team/lol -X DELETE --header "token: from login" -d "profileID=1"

        let alert1 = SCLAlertView()
        let alert2 = SCLAlertView()
        var manager = Manager.sharedInstance
        // Specifying the Headers we need
        manager.session.configuration.HTTPAdditionalHeaders = [
            "token": UserInfoGlobal.accessToken
        ]
        var profileid =  TeamInfoGlobal.memberId[sender.tag] as! String
        var name = TeamInfoGlobal.memberName[sender.tag] as! String
        
        alert1.addButton("Delete", actionBlock:{ (Void) in
            alert2.showWaiting(self.parentViewController?.parentViewController, title: "Wait a second", subTitle: "Quiting......", closeButtonTitle: nil, duration: 0.0)
            
            var req = request(.DELETE, "http://54.149.235.253:5000/manage_team/lol",parameters: ["profileID": profileid ])
                .responseJSON { (_, _, JSON, _) in
                    alert2.hideView()
                    
                    println(JSON)
                    
                    if (JSON as! [String:AnyObject])["status"] != nil{
                        if((JSON as! [String:AnyObject])["status"] as! String == "success")
                        {
                            TeamInfoGlobal.deletemember(sender.tag)
                            self.resultTable.reloadData()
                    
                        }
                    }
                    
            }
            
        })
        
        alert1.showWarning(self.parentViewController?.parentViewController, title: "Kick Member", subTitle: "Do you want to kick" + name  , closeButtonTitle: "Cancel", duration: 0.0)
        
        
     
    
        
        
    }



}