//
//  ChatsViewController.swift
//  Meeet Up
//
//  Created by Kedan Li on 14/11/18.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Tournament_game: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var Tournamentname :String = ""
    var TournamentType :String = ""
    var starttime : String = ""
    var joinTeam :String = ""
    var memberID = 0
    
    var teams: [AnyObject] = [AnyObject]()
    
    //select tournament in list
    var gamenumber = 0
    // total number of tournamnet
    var teamsnumber = 0
    var refreshControl = UIRefreshControl()
    
    @IBOutlet var tableData: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       self.refreshControl.addTarget(self, action: Selector("flashdata"), forControlEvents: UIControlEvents.ValueChanged)
       self.refreshControl.attributedTitle = NSAttributedString(string: "reload data form servers")
        
       tableData.addSubview(refreshControl)
        
        //Do any additional setup after loading the view.
    }
    
    func flashdata() {
    
        Tournament.getTournamentList()
      
        tableData.reloadData()
        self.refreshControl.endRefreshing()
    
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell2 = NSBundle.mainBundle().loadNibNamed("tableCell", owner: 0, options: nil)[0] as tournamentViewCell
        
            cell2.setCell(Tournament.gameName[indexPath.row] as String, name: Tournament.tournamentName[indexPath.row] as String, rule: Tournament.tournamentType[indexPath.row] as String, time:Tournament.startTime[indexPath.row] as String,joined: Tournament.totalMember[indexPath.row] as Int, maxteam:Tournament.maxteam[indexPath.row] as Int)
        cell2.setNeedsUpdateConstraints()
        
        cell2.JoinedFree.addTarget(self, action: "joinTournament:", forControlEvents: UIControlEvents.TouchUpInside)
        cell2.JoinedFree.tag = indexPath.row
        return cell2
    }
        
    func joinTournament(sender : UIButton){
        
        println(sender.tag)
        
        self.gamenumber = sender.tag
        self.TournamentType = Tournament.tournamentType[sender.tag] as String
        self.starttime = Tournament.startTime[sender.tag] as String
        self.teamsnumber = Tournament.totalMember[sender.tag] as Int
        
         let alert = SCLAlertView()
        let alert1 = SCLAlertView()
        let alert2 = SCLAlertView()
        var url = Tournament.tournamentUrl[sender.tag] as String
        var name = Tournament.tournamentName[sender.tag] as String
        var member = TeamInfoGlobal.teamName
        
        
        alert2.showWaiting(self.parentViewController?.parentViewController, title: "Loading", subTitle: "Cteemo is loading", closeButtonTitle: nil, duration: 0.0)
        var par : [String: AnyObject] = ["api_key":Tournament.key]
        var req = Alamofire.request(.GET, "https://api.challonge.com/v1/tournaments/"+name+"/participants.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                let myjson = SwiftyJSON.JSON(JSON!)
                var s = 0
                if myjson.count != 0{
                    for i in 0...myjson.count-1{
                        if let k = myjson[i]["participant"]["name"].string{
                            
                            if k == member{
                                println(k)
                                if let n =  myjson[i]["participant"]["id"].int{
                                  
                                    s = n
                                  
                                }
                            }
                        }
                    }//end for loop
                    
                    alert2.hideView()
                    
                    if s != 0 {
                          self.memberID = s
                          self.performSegueWithIdentifier("joined", sender: self)
                    
                    }// 在比赛中找到了成员
                    
                        
                    //当在比赛中找不到成员时候
                    else{
                    
                    
                        if TeamInfoGlobal.iscaptain == "yes"{
                            
                            
                            alert.addButton("Join!"){
                                
                                
                                var par : [String: AnyObject] = ["api_key":Tournament.key,"participant[name]":TeamInfoGlobal.teamName]
                                var req = Alamofire.request(.POST, "https://api.challonge.com/v1/tournaments/"+url+"/participants.json",parameters:par)
                                    .responseJSON { (_, _, JSON, _) in
                                        println(JSON)
                                        let myjson = SwiftyJSON.JSON(JSON!)
                                        if JSON != nil {
                                            
                                            var result: [String: AnyObject] = JSON as [String: AnyObject]
                                            if result["errors"]? != nil {
                                                
                                                if let error = myjson["errors"][0].string
                                                {
                                                    println(error)
                                                    if error.rangeOfString("no longer be added")?.isEmpty != nil{
                                                        alert1.showError(self.parentViewController?.parentViewController, title: "Failed to Join", subTitle: "Game already Started", closeButtonTitle: "ok", duration: 0.0)
                                                    }
                                                    if error.rangeOfString("Name has already")?.isEmpty != nil{
                                                        self.performSegueWithIdentifier("joined", sender: self)
                                                        
                                                    } // already joined
                                                    
                                                }// check errors
                                                
                                                
                                            }//error exis
                                                
                                            else if result["participant"]? != nil {
                                                
                                                self.performSegueWithIdentifier("joined", sender: self)
                                                
                                                
                                            }//newuser joined
                                            
                                        }
                                        
                                        
                                        
                                }
                                
                                
                            }
                            alert.showCustom(self.parentViewController?.parentViewController, image: UIImage(named: "error.png")!, color: UserInfoGlobal.UIColorFromRGB(0x2ECC71), title: "Free Tournament!", subTitle: "Dear captain, Do you want to Join " + name,closeButtonTitle: "Cancel", duration: 0.0)
                            
                            
                        }
                            
                        else{
                            
                            alert.showWarning(self.parentViewController?.parentViewController, title: "Join failed", subTitle: "You must be the captain in able to Join Tournament", closeButtonTitle: "ok", duration: 0.0)
                            
                        }

                    
                    }
                    
                
                }
                
                
                
        }


       
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "joined"{
            
            var controller: Tournament_joined = segue.destinationViewController as Tournament_joined
            controller.gamenumber = self.gamenumber
            controller.starttime = self.starttime
            controller.TournamentType = self.TournamentType
            controller.totalmember = self.teamsnumber
            controller.url = Tournament.tournamentUrl[self.gamenumber] as String
            controller.memberID = self.memberID
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 130
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Tournament.totalnumber
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func returnTogame(segue : UIStoryboardSegue) {
        
        
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
