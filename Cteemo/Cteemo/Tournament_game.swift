//
//  ChatsViewController.swift
//  Meeet Up
//
//  Created by Kedan Li on 14/11/18.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit




class Tournament_game: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var Tournamentname :String = ""
    var TournamentType :String = ""
    var starttime : String = ""
    var joinTeam :String = ""
    var memberID = 0
    
    var teams: [AnyObject] = [AnyObject]()
    
    //select tournament in list
   
    // total number of tournamnet
    var teamsnumber = 0
    var name = ""
    var url = ""
    var refreshControl = UIRefreshControl()
    
    
    var Tournaments :[Tournamentdata] = []
    
    @IBOutlet var tableData: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if Tournament.solo{
            
            Tournaments = Tournament.soloTournaments
        }else{
            
            Tournaments = Tournament.teamTournaments
            
        }
        
       self.refreshControl.addTarget(self, action: Selector("flashdata"), forControlEvents: UIControlEvents.ValueChanged)
       self.refreshControl.attributedTitle = NSAttributedString(string: "reload data form servers")
        
       tableData.addSubview(refreshControl)
        
        
        //Do any additional setup after loading the view.
    }
    
    func flashdata() {
        
        
            if Tournament.solo {
                
                Tournament.gettournamentdata(true)
                Tournaments = Tournament.soloTournaments
            }
            else {
                Tournament.gettournamentdata(false)
                Tournaments = Tournament.teamTournaments

            }
        
            
            self.tableData.reloadData()
            self.refreshControl.endRefreshing()
        
      

        
        
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell2 = NSBundle.mainBundle().loadNibNamed("tableCell", owner: 0, options: nil)[0] as tournamentViewCell
        
        if Tournaments.count != 0 && Tournaments.count > indexPath.row {
            
        cell2.setCell(Tournaments[indexPath.row].gameName, name: Tournaments[indexPath.row].name, rule: Tournaments[indexPath.row].type, time:Tournaments[indexPath.row].startTime,joined: Tournaments[indexPath.row].joinedmember, maxteam:Tournaments[indexPath.row].max)
        cell2.setNeedsUpdateConstraints()
        cell2.JoinedFree.addTarget(self, action: "joinTournament:", forControlEvents: UIControlEvents.TouchUpInside)
        cell2.JoinedFree.tag = indexPath.row
        }
        return cell2
    
    }
    
    
        
    func joinTournament(sender : UIButton){
        
        println(sender.tag)
        
        self.TournamentType = self.Tournaments[sender.tag].type
        self.starttime = self.Tournaments[sender.tag].startTime
        self.teamsnumber = self.Tournaments[sender.tag].joinedmember
        
         let alert = SCLAlertView()
        let alert1 = SCLAlertView()
        let alert2 = SCLAlertView()
        self.url = self.Tournaments[sender.tag].url
        self.name = self.Tournaments[sender.tag].name
        
        var member :String!
        
      
        
        if Tournament.solo {
            
            member = LolAPIGlobal.lolName
           
            
        }else{
        
            
            member = TeamInfoGlobal.teamName
            
        }
        
        if member != nil {
            
            alert2.showWaiting(self.parentViewController?.parentViewController, title: "Loading", subTitle: "Cteemo is loading", closeButtonTitle: nil, duration: 0.0)
            
            var par : [String: AnyObject] = ["api_key":Tournament.key]
            
            
            var req = request(.GET, "https://api.challonge.com/v1/tournaments/"+self.url+"/participants.json",parameters:par)
                
                .responseJSON { (_, _, JSONdata, _) in
                    println(JSONdata)
                   
                    let myjson = JSON(JSONdata!)
                    var s = 0
                    println(myjson)
                    if myjson.count != 0{
                        for i in 0...myjson.count-1{
                            if let k = myjson[i]["participant"]["name"].string{
                                
                                if k == member {
                                    println(k)
                                    if let n =  myjson[i]["participant"]["id"].int{
                                        
                                        s = n
                                        
                                    }
                                }
                            }
                        }//end for loop
                    }
                    
                    
                    alert2.hideView()
                    
                    if s != 0 {
                        self.memberID = s
                        self.performSegueWithIdentifier("joined", sender: self)
                        
                    }// 在比赛中找到了成员
                        
                        
                        //当在比赛中找不到成员时候
                    else{
                        
                        if Tournament.solo  || (TeamInfoGlobal.iscaptain != nil && TeamInfoGlobal.iscaptain == "yes"){
                            
                            alert.addButton("Join!"){
                                
                                var par : [String: AnyObject] = ["api_key":Tournament.key,"participant[name]":member]
                                var req = request(.POST, "https://api.challonge.com/v1/tournaments/"+self.url+"/participants.json",parameters:par)
                                    .responseJSON { (_, _, JSONdata, _) in
                                        
                                        let myjson = JSON(JSONdata!)
                                        if JSONdata != nil {
                                            
                                            var result: [String: AnyObject] = JSONdata as [String: AnyObject]
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
                            alert.showCustom(self.parentViewController?.parentViewController, image: UIImage(named: "error.png")!, color: UserInfoGlobal.UIColorFromRGB(0x333333), title: "Free Tournament!", subTitle: "Do you want to Join " + self.name,closeButtonTitle: "Cancel", duration: 0.0)
                            
                            
                        }
                            
                        else{
                            
                            alert.showWarning(self.parentViewController?.parentViewController, title: "Join failed", subTitle: "You must be the captain in able to Join Tournament", closeButtonTitle: "ok", duration: 0.0)
                            
                        }// not captain
                        
                        
                    }// can't find member
                    
                    
            }//end request
            

        
        }// no team 
        
        else {
        
            alert.showWarning(self.parentViewController?.parentViewController, title: "Join failed", subTitle: "You must have a team before join a tournament", closeButtonTitle: "ok", duration: 0.0)
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "joined"{
            
            var controller: Tournament_joined = segue.destinationViewController as Tournament_joined
            controller.starttime = self.starttime
            controller.TournamentType = self.TournamentType
            controller.totalmember = self.teamsnumber
            controller.url = self.url
            controller.Tournamentname  = self.name
            controller.memberID = self.memberID
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 130
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if Tournament.solo {
            
        return Tournament.soloTournaments.count
        
        }
        else{
            
        return Tournament.teamTournaments.count
            
        }
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
