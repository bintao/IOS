//
//  Team_FindTeamViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/4.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

class Team_FindTeamViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,RequestResultDelegate{
    
    
    @IBOutlet var search: UISearchBar!
    @IBOutlet var loading : UIActivityIndicatorView!
    @IBOutlet var resultTable : UITableView!
    
    var teams: [AnyObject] = [AnyObject]()
    
    
    override func viewDidLoad()
    {
        resultTable.backgroundColor = UIColor.clearColor()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if UserInfoGlobal.accessToken != ""{
        var manager = Manager.sharedInstance
        // Specifying the Headers we need
        manager.session.configuration.HTTPAdditionalHeaders = [
            "token": UserInfoGlobal.accessToken
        ]
        
        startLoading()
        println(searchBar.text)
        var req = Alamofire.request(.GET, "http://54.149.235.253:5000/search_team/lol", parameters: [ "teamName":searchBar.text])
            .responseJSON { (_, _, JSON, _) in
                self.stopLoading()
                if  ((JSON as [AnyObject])[0] as [String: AnyObject])["teamID"]? != nil
                {
                    println(UserInfoGlobal.accessToken)
                    if JSON? != nil{
                        println(JSON)
                        self.teams = JSON as [AnyObject]
                        var result: [AnyObject] = [AnyObject]()
                        result = JSON as [AnyObject]
                        self.gotResult(result)
                    }
                }
                else if JSON == nil{
                
                
                }
                else{
                    let alert1 = SCLAlertView()
                    alert1.showError("Unauthorized", subTitle: "Try logout and login again", closeButtonTitle: "OK")
                }
            }
        }
    }
    
    func gotResult(result: [AnyObject]){
        
        teams = result
        resultTable.reloadData()
            
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        var backButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.width, 80))
        backButton.setImage(UIImage(named: "white"), forState: UIControlState.Normal)
        cell.addSubview(backButton)
        
        var cellIcon = UIImageView(image: UIImage(named: "Forma 1"))
        cellIcon.frame = CGRectMake(10, 10, 60, 60)
        cell.addSubview(cellIcon)
        
        var teamName = UILabel(frame: CGRectMake(85, 15, 200, 27))
        teamName.textColor = UIColor.darkGrayColor()
        teamName.text = (teams[indexPath.row] as [String: AnyObject])["teamName"] as? String
        teamName.font = UIFont(name: "AvenirNext-Medium", size: 18)
        cell.addSubview(teamName)
        

        var captain = UILabel(frame: CGRectMake(85, 45, 200, 27))
        captain.text = "Captain: " + ((teams[indexPath.row] as [String: AnyObject])["captain"] as String)
        captain.textColor = UIColor.darkGrayColor()
        captain.font = UIFont(name: "AvenirNext-Regular", size: 13)
        cell.addSubview(captain)
        
        var contactCaptain = UIButton(frame: CGRectMake(self.view.frame.width - 60, 20, 40, 40))
        contactCaptain.setImage(UIImage(named: "adddd"), forState: UIControlState.Normal)
        contactCaptain.addTarget(self, action: "contactCap:", forControlEvents: UIControlEvents.TouchUpInside)
        contactCaptain.tag = indexPath.row
        cell.addSubview(contactCaptain)

               return cell
    }

    
    func contactCap(sender : UIButton){
        
        println(sender.tag)
        if (teams[sender.tag] as [String : AnyObject])["teamName"]? != nil{
            
        var teamname = (teams[sender.tag] as [String : AnyObject])["teamName"] as String
        
        let alert = SCLAlertView()
        alert.addButton("Join team now!"){
            self.startLoading()
            var req = ARequest(prefix: "my_team/lol", method: requestType.POST, parameters: ["teamName": teamname])
            req.delegate = self
            req.sendRequestWithToken(UserInfoGlobal.accessToken)
            self.stopLoading()
        
            }
       
        alert.showCteemo("Join team request", subTitle: "i want to join "+teamname, closeButtonTitle: "cancel")
        }
        
        /*
        self.startLoading()
        var req = ARequest(prefix: "my_team/lol", method: requestType.POST, parameters: ["teamName": teamname])
        req.delegate = self
        req.sendRequestWithToken(UserInfoGlobal.accessToken)
        self.stopLoading()
        }
        */
    
    }
    
    func gotResult(prefix: String, result: AnyObject) {
    
    
        println(result)
    
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        search.resignFirstResponder()
        return true
    }
    
    
    // background tapped
    
    
    //loading view display while login
    func startLoading(){
        self.loading.startAnimating()
        resultTable.userInteractionEnabled = false
        search.userInteractionEnabled = false
    }
    
    //loading view hide, login finished
    func stopLoading(){
        self.loading.stopAnimating()
        resultTable.userInteractionEnabled = true
        search.userInteractionEnabled = true
    }
}
