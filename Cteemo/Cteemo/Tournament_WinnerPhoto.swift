//
//  Tournament_WinnerPhoto.swift
//  Cteemo
//
//  Created by bintao on 15/4/12.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit


class Tournament_WinnerPhoto:  UIViewController ,CACameraSessionDelegate {

    var myteamdata = teamdata()
    var oppteam = teamdata()
    var matchid = 0
    var url = ""
    
    
    @IBOutlet weak var reportimage: UIImageView!
    
    var cameraView: CameraSessionView!
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }

    @IBAction func addphoto(sender: AnyObject) {
     
        
       self.cameraView = CameraSessionView(frame: self.view.frame)
        self.cameraView.delegate = self
        
    
    self.parentViewController?.parentViewController?.view.addSubview(self.cameraView)
        
    
    }
    
    
     @IBAction func win(sender: AnyObject) {
        
        if self.reportimage.image != nil {
        var score = ""
        var win = myteamdata.win + 1
        var par : [String: AnyObject]
        if myteamdata.teamkey == 1 {
            score = "\(win)" + "-" + "\(oppteam.win)"
            
        }
        else{
            score = "\(oppteam.win)" + "-" + "\(win)"
            
        }
        
        println(score)
        
        if win < 2 {
            
            par  = ["api_key":Tournament.key,"match[scores_csv]":score,"match[winner_id]": myteamdata.teamid]
        }
        else{
            par  = ["api_key":Tournament.key,"match[scores_csv]":score,"match[winner_id]": myteamdata.teamid]
        }
        
        println(par)
        
        let url = "https://api.challonge.com/v1/tournaments/"+self.url+"/matches/"+"\(self.matchid)"+".json"
        
        request(.PUT,url, parameters: par)
            .responseJSON { (_, _, JSON, _) in
                
                if JSON != nil{
                    
                    let alert1 = SCLAlertView()
                    alert1.addButton("ok"){
                        
                        self.performSegueWithIdentifier("backjoinedgame", sender: self)
                        
                    }
                    alert1.showSuccess(self.parentViewController?.parentViewController, title: "WIN", subTitle: "Cong summoner ! You just win a game!", closeButtonTitle: nil, duration: 0.0)
                    
                    
                }
        }
        
        }else {
            let alert1 = SCLAlertView()
            alert1.showWarning(self.parentViewController?.parentViewController, title: "No image", subTitle: "Please click add button to add picture", closeButtonTitle: "ok", duration: 0.0)
        
        }

        
    }
    
    
    
    
    func didCaptureImage(image: UIImage!) {
        
        
        self.cameraView.removeFromSuperview()
        
        self.reportimage.image = image
        
        
    }
    
    
    


}