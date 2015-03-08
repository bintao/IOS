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
    var joinTeam :String = ""
    var teams: [AnyObject] = [AnyObject]()
    
    //select tournament in list
    var gamenumber = 0
    // total number of tournamnet
    var numberOfData = 3
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
        
        self.performSegueWithIdentifier("joined", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "joined"{
            
            var controller: Tournament_joined = segue.destinationViewController as Tournament_joined
            
            controller.gamenumber = self.gamenumber
            controller.url = Tournament.tournamentUrl[self.gamenumber] as String
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 130
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(Tournament.totalnumber)
        return Tournament.totalnumber.toInt()!
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
