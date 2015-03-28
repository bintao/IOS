//
//  ChatsViewController.swift
//  Meeet Up
//
//  Created by Kedan Li on 14/11/18.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit


class Tournament_joined: UIViewController {
    
    var Tournamentname :String = ""
    
    var TournamentType :String = ""
    var joinTeam :String = ""
    var memberID = 1
    var teams: [AnyObject] = [AnyObject]()
    
    var gamenumber = 0
    var url :String = ""
    

    @IBOutlet weak var titel: UILabel!
    
    override func viewDidLoad() {
        
        //titel.text = self.url
        self.Tournamentname = Tournament.tournamentName[self.gamenumber] as String
        self.url =  Tournament.tournamentUrl[self.gamenumber] as String
        self.memberID = Tournament.findMemberID(self.url, member: TeamInfoGlobal.teamName)
        
       
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
    
    
    
    println(memberID)
    
    
    }
    
    @IBAction func bracket(sender: AnyObject){
        
        self.performSegueWithIdentifier("bracket", sender: self)
        
    }
    
    
  
    
    
    @IBAction func chat(sender: AnyObject) {
        
       
        
        
    }
    
   
    @IBAction func playnext(sender: AnyObject) {
        
        
      

        
    }
    
    
    @IBAction func reportresult(sender: AnyObject) {
        
        
        
        
        
    }
    
    
    
    @IBAction func checkin(sender: AnyObject) {
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "bracket"{
           
            var controller: Bracket = segue.destinationViewController as Bracket
       
            controller.url = Tournament.tournamentUrl[self.gamenumber] as String
            
        }
        

        
    }
    
    override func didReceiveMemoryWarning() {
 
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func returnToJoined(segue : UIStoryboardSegue) {
        
        
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
