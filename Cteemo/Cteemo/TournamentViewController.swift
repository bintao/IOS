//
//  ChatsViewController.swift
//  Meeet Up
//
//  Created by Kedan Li on 14/11/18.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit

class TournamentViewController: UIViewController {
    
    @IBOutlet var constrain: NSLayoutConstraint!
    
    @IBOutlet var create: UIButton!
    @IBOutlet var currentGame: UIButton!
    @IBOutlet var result: UIButton!

    var Tournamentname :String = ""
    var TournamentType :String = ""
    var joinTeam :String = ""
    var teams: [AnyObject] = [AnyObject]()
    
    @IBOutlet var teamshamer: FBShimmeringView!
    @IBOutlet var shamer: FBShimmeringView!
    @IBOutlet var sologame: UIImageView!
    
    @IBOutlet var teamgame: UIImageView!
    
    
    override func viewDidAppear(animated: Bool) {
        
      //  ((self.parentViewController as UINavigationController).parentViewController as MainViewController).showTabb()
     
    }
    
    
    override func viewDidLoad() {
        
        shamer.contentView = sologame
        shamer.shimmering = true
        teamshamer.contentView = teamgame
        teamshamer.shimmering = true
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    @IBAction func returnToTournament(segue : UIStoryboardSegue) {
        
    
    }
    
       override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if segue.identifier == "gotoGame"{
            
            var controller: Tournament_game = segue.destinationViewController as Tournament_game
            controller.solo = false
            Tournament.key = Tournament.teamkey
        }
        
        else if segue.identifier == "sologame"{
            
            var controller: Tournament_game = segue.destinationViewController as Tournament_game
            controller.solo = true
            Tournament.key = Tournament.solokey
        }
        
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
