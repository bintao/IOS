//
//  ChatsViewController.swift
//  Meeet Up
//
//  Created by Kedan Li on 14/11/18.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

class Tournament_joined: UIViewController {
    
    var Tournamentname :String = ""
    var totalmember = 0
    var starttime :String = ""
    var TournamentType :String = ""
    
    var joinTeam :String = ""
    var memberID = 1
    var teams: [AnyObject] = [AnyObject]()
    
    var gamenumber = 0
    var url :String = ""
    
    @IBOutlet var type: UITextView!

    @IBOutlet var time: UITextView!

    @IBOutlet var member: UITextView!
    
    override func viewDidLoad() {
        
        RCIMClient.sharedRCIMClient().joinChatRoom("Cteemo", messageCount: 0, completion: { () -> Void in
            
            }, error: nil)
        Tournament.getmatches(self.url, member : 24179900)
        //titel.text = self.url
        self.Tournamentname = Tournament.tournamentName[self.gamenumber] as String
       
        self.memberID = Tournament.findMemberID(self.url, member: TeamInfoGlobal.teamName)
        self.type.text = self.TournamentType
        self.time.text = self.starttime
        self.member.text = "\(self.totalmember)"
        
        super.viewDidLoad()
        
       
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {

        
      
        
    Tournament.tournamentStart(self.url)
    
     ((self.parentViewController as UINavigationController).parentViewController as MainViewController).showTabb()
    
    
    }
    
    @IBAction func bracket(sender: AnyObject){
        
        self.performSegueWithIdentifier("bracket", sender: self)
        
        
    }
    
    
  
    
    
    @IBAction func chat(sender: AnyObject) {
        
       
        var temp = RCChatViewController.alloc()
        
        temp.currentTarget = "Cteemo"
        temp.conversationType = RCConversationType.onversationType_CHATROOM
        temp.enableSettings = false
        temp.currentTargetName = "Cteemo"
    
        ((self.parentViewController as UINavigationController).parentViewController as MainViewController).hideTabb()
        
        
        self.navigationController?.pushViewController(temp, animated: true)
      
        
    }
    
   
    @IBAction func playnext(sender: AnyObject) {
        
        
         self.performSegueWithIdentifier("playnextgame", sender: self)
        
      

        
    }
    
    
    @IBAction func reportresult(sender: AnyObject) {
        
        
        
        
        
    }
    
    
    
    @IBAction func checkin(sender: AnyObject) {
        
        
        var par : [String: AnyObject] = ["api_key":Tournament.key]
        var req = Alamofire.request(.POST, "https://api.challonge.com/v1/tournaments/"+self.url+"/participants/"+"\(self.memberID)"+"/check_in.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                if JSON != nil {
                var result = JSON as [String : AnyObject]
                
                if result["errors"]? != nil {
                    
                    let alert1 = SCLAlertView()
                    alert1.showError(self.parentViewController?.parentViewController, title: "Check in faild", subTitle: "Please contact custom servers", closeButtonTitle: nil, duration: 3.0)
                    
                }
                else {
                    
                    let alert1 = SCLAlertView()
                    alert1.showSuccess(self.parentViewController?.parentViewController, title: "Check in Success", subTitle: TeamInfoGlobal.teamName + "ready for battle", closeButtonTitle: nil, duration: 3.0)
                }
                    
                    
            }
       
        
        }
        
        

       
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "bracket"{
           
            var controller: Bracket = segue.destinationViewController as Bracket
       
            controller.url = Tournament.tournamentUrl[self.gamenumber] as String
            
        }
        else if segue.identifier == "playnextgame"{
            
             var controller: Tournament_playnext = segue.destinationViewController as Tournament_playnext
            
            controller.member = 24179900
           controller.tournamentname = self.Tournamentname
            controller.url = self.url
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
