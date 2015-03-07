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
    
    override func viewDidAppear(animated: Bool) {
        
      //  ((self.parentViewController as UINavigationController).parentViewController as MainViewController).showTabb()
        
    }
    
    
    override func viewDidLoad() {
        Tournament.getTournamentList()
        super.viewDidLoad()
       
        constrain.constant = self.view.frame.width / 3
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
            //((self.parentViewController as UINavigationController).parentViewController as MainViewController).hideTabb()
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
