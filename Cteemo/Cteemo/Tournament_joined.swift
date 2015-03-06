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
    var teams: [AnyObject] = [AnyObject]()
    
    var gamenumber = 0
    var url :String = ""
    

    @IBOutlet weak var titel: UILabel!
    
    override func viewDidLoad() {
        
        titel.text = self.url
        self.Tournamentname = Tournament.tournamentName[self.gamenumber] as String
        
        println(self.url)
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func bracket(sender: AnyObject){
        
        self.performSegueWithIdentifier("bracket", sender: self)
        
    }
    
    
    @IBAction func info(sender: AnyObject) {
        
        
    }
    
    
    @IBAction func addMember(sender: AnyObject) {
        
        let alert1 = SCLAlertView()
        let name =  alert1.addTextField(title: "Team Name")
        
        alert1.addButton("Join") {
            
            Tournament.JoinTournament(self.url,name: name.text,email:"")
            
        }
            alert1.showCteemo(self.Tournamentname, subTitle:"I want to join Tournamnet!", closeButtonTitle: "Cancle")
        
        
    }
    
   
    @IBAction func deleteMember(sender: AnyObject) {
        
        
        
        let alert1 = SCLAlertView()
        let name =  alert1.addTextField(title: "Team Name")
        
        alert1.addButton("Delete") {
            println(name.text)
           
            
            Tournament.deleteMemberByname(self.url, member: name.text)
            
            
        }
        alert1.showError("Delete Member from "+self.Tournamentname, subTitle:"", closeButtonTitle: "Cancle")

        
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
