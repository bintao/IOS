//
//  ChatsViewController.swift
//  Meeet Up
//
//  Created by Kedan Li on 14/11/18.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

class Tournament_game: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var Tournamentname :String = ""
    var TournamentType :String = ""
    var joinTeam :String = ""
    var teams: [AnyObject] = [AnyObject]()
    
    var numberOfData = 3
    
    @IBOutlet var tableData: UITableView!
    
    override func viewDidLoad() {
        
        var par : [String: AnyObject] = ["api_key":Tournament.key]
        var req = Alamofire.request(.GET,"https://api.challonge.com/v1/tournaments.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                
            self.numberOfData = (JSON as NSArray).count
            println(self.numberOfData)
        }
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        var cell2 = NSBundle.mainBundle().loadNibNamed("tableCell", owner: 0, options: nil)[0] as? UITableViewCell
        cell.addSubview(cell2!.contentView)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
