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
    var cellcount = 0
    var numberOfData = 3
    
    @IBOutlet var tableData: UITableView!
    
    override func viewDidLoad() {
        
        Tournament.getTournamentList()
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let cell2 = NSBundle.mainBundle().loadNibNamed("tableCell", owner: 0, options: nil)[0] as? tournamentViewCell
   
            
            cell2?.setCell(Tournament.gameName[cellcount] as String, name: Tournament.tournamentName[cellcount] as String, rule: Tournament.tournamentType[cellcount] as String, time:Tournament.startTime[cellcount] as String,joined: Tournament.totalMember[cellcount] as Int, maxteam:Tournament.maxteam[cellcount] as Int)
        
        
        //func setcell2(gameName : String,name :String,rule:String,joined:String,time:String,maxteam:String)
        
        cell.addSubview(cell2!.contentView)
        
        cellcount++
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 130
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tournament.totalnumber.toInt()!
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
    @IBAction func leagueoflegend(){
        
        let alert1 = SCLAlertView()
        
        alert1.addButton("Join") {
            
            Tournament.JoinTournament("UIUC_League",name: TeamInfoGlobal.teamName,email:"")
            
            self.performSegueWithIdentifier("joined", sender: self)
            
        }
        if TeamInfoGlobal.teamName != ""
        {
        alert1.showCteemo("League of Legends Tournament", subTitle:TeamInfoGlobal.teamName+" want to join League of legends", closeButtonTitle: "Cancle")
            
        }
        else{
        let alert2 = SCLAlertView()
        alert2.showError("Join Tournament", subTitle: "You must join a team before join tournament", closeButtonTitle: "OK")
        }
        
    }
    */
    
    
    
    @IBAction func dota2(){
        
        let alert2 = SCLAlertView()
        
        alert2.addButton("Join") {
            
            Tournament.JoinTournament("UIUC",name: TeamInfoGlobal.teamName,email:"")
            self.performSegueWithIdentifier("joined", sender: self)
            
        }
        
        alert2.showCteemo("Join Dota2 Tournament", subTitle:TeamInfoGlobal.teamName+" want to join Dota2 ", closeButtonTitle: "Cancle")
        
    }
    
    
    @IBAction func hearthstone(){
        
        let alert3 = SCLAlertView()
        
        alert3.addButton("Join") {
            
            Tournament.JoinTournament("UIUC",name: TeamInfoGlobal.teamName,email:"")
            
            self.performSegueWithIdentifier("joined", sender: self)
            
        }
        
        alert3.showCteemo("Hearthstone Tournament", subTitle:TeamInfoGlobal.teamName+" want to join Hearthstone Tournament", closeButtonTitle: "Cancle")
        
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
