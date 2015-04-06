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
    
    
    
    @IBOutlet var navigation: UINavigationItem!
    
    @IBOutlet var type: UITextView!

    @IBOutlet var time: UITextView!

    @IBOutlet var member: UITextView!
    
    override func viewDidLoad() {
        
    
        super.viewDidLoad()
        self.Tournamentname = Tournament.tournamentName[self.gamenumber] as String
        navigation.title = self.Tournamentname
       
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.searchmyid()
        self.Tournamentname = Tournament.tournamentName[self.gamenumber] as String
        self.navigationController?.navigationItem.title = self.Tournamentname
        self.type.text = self.TournamentType
        self.time.text = self.starttime
        self.member.text = "\(self.totalmember)"
        
        
     ((self.parentViewController as UINavigationController).parentViewController as MainViewController).showTabb()
   
    }
    
    @IBAction func bracket(sender: AnyObject){
        
        self.performSegueWithIdentifier("bracket", sender: self)
        
        
    }
    
    
  
    
    
    @IBAction func chat(sender: AnyObject) {
        
        
       self.enterchat()
      
        
    }
    
  
    @IBAction func chatroom(sender: AnyObject){
        
        self.enterchat()
        
        
        
    }
   
    
    
    func enterchat()
    {
    
        var temp = RCChatViewController()
        temp.currentTarget = self.url
        temp.conversationType = RCConversationType.onversationType_CHATROOM
        temp.enableSettings = false
        temp.currentTargetName = self.Tournamentname
        ((self.parentViewController as UINavigationController).parentViewController as MainViewController).hideTabb()
        self.navigationController?.pushViewController(temp, animated: true)
    
    
    }
    @IBAction func playnext(sender: AnyObject) {
        
        
         self.performSegueWithIdentifier("playnextgame", sender: self)
        
      

        
    }
    
    
    @IBAction func reportresult(sender: AnyObject) {
        
        
        var chatViewController : RCChatViewController = RCIM.sharedRCIM().createCustomerService("KEFU1426185510333", title: "cteemo", completion: nil)
        
        UINavigationBar.appearance().tintColor = UserInfoGlobal.UIColorFromRGB(0xE74C3C)
        
        ((self.parentViewController as UINavigationController).parentViewController as MainViewController).hideTabb()
        
        self.navigationController?.pushViewController(chatViewController, animated: true)
        
        
    }
    
    
    
    @IBAction func checkin(sender: AnyObject) {
        
        println(self.memberID)
        var par : [String: AnyObject] = ["api_key":Tournament.key]
        var req = Alamofire.request(.POST, "https://api.challonge.com/v1/tournaments/"+self.url+"/participants/"+"\(self.memberID)"+"/check_in.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                
                if JSON != nil {
                println(JSON)
                var result = JSON as [String : AnyObject]
                
                if result["errors"]? != nil {
                    
                    let alert1 = SCLAlertView()
                    alert1.showError(self.parentViewController?.parentViewController, title: "Check in faild", subTitle: "Please contact custom servers", closeButtonTitle: "ok", duration: 0.0)
                    
                }
                else {
                    
                    let alert1 = SCLAlertView()
                    alert1.showSuccess(self.parentViewController?.parentViewController, title: "Check in Success", subTitle: TeamInfoGlobal.teamName + "ready for battle", closeButtonTitle: "ok", duration: 0.0)
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
            
            controller.myteamid = self.memberID
           controller.tournamentname = self.Tournamentname
            controller.url = self.url
            controller.starttimetext = self.starttime
        }
        

        
    }
    
    override func didReceiveMemoryWarning() {
 
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func returnToJoined(segue : UIStoryboardSegue) {
        
        
        
    }
    
    func searchmyid() {
    
        var myteamname = TeamInfoGlobal.teamName
        var par : [String: AnyObject] = ["api_key":Tournament.key]
        var req = Alamofire.request(.GET, "https://api.challonge.com/v1/tournaments/"+self.url+"/participants.json",parameters:par)
            .responseJSON { (_, _, JSON, _) in
                let myjson = SwiftyJSON.JSON(JSON!)
                var s = 0
                if myjson.count != 0{
                    for i in 0...myjson.count-1{
                        if let k = myjson[i]["participant"]["name"].string{
                            
                            if k == myteamname {
                                
                                if let n =  myjson[i]["participant"]["id"].int{
                                    
                                    self.memberID = n
                                    
                                }
                        
                            }
                        }
                    }//end for loop
                }
                
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
