//
//  ChatsViewController.swift
//  Meeet Up
//
//  Created by Kedan Li on 14/11/18.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit

class TournamentViewController: UIViewController {
    
    var Tournamentname :String = ""
    var TournamentType :String = ""
    var joinTeam :String = ""
    var teams: [AnyObject] = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     @IBAction func createTournament(){
        
        
        let alert1 = SCLAlertView()
        
        let name = alert1.addTextField(title: "Tournament")
        let intro = alert1.addTextField(title:"Tournament Intro")
        
        alert1.addButton("Create") {
            if name.text != "" && intro.text != ""{
            
                println("Text value: \(name.text)")
            println("Text value: \(intro.text)")
            Tournament.createTournament(name.text, intro: intro.text)
                
            }
        }
        alert1.showCteemo("Create Tournament", subTitle:UserInfoGlobal.name+" is the admin.", closeButtonTitle: "Cancle")
       
    }
    
    
    
    @IBAction func joinTournament(){
        
        let alert = SCLAlertView()
        
        let name = alert.addTextField(title:"Team Name")
        let email = alert.addTextField(title:"Captain Email")
        alert.addButton("Join"){
            if name.text != ""
            {
                println(name.text)
                //Tournament.JoinTournament("1484321")
                
                Tournament.JoinTournament("UIUC",name: name.text,email: email.text)
            }
        }
        alert.showInfo("Join Tournament", subTitle:UserInfoGlobal.name+" want to jon Tournament", closeButtonTitle: "Cancle")
        

    }

    
    @IBAction func returnToTournament(segue : UIStoryboardSegue) {
        
        
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
