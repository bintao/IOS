//
//  Team_FindTeamViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/4.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

class Team_FindTeamViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet var search: UISearchBar!
    @IBOutlet var loading : UIActivityIndicatorView!
    @IBOutlet var resultTable : UITableView!
    
    var teams: [AnyObject] = [AnyObject]()
    
    override func viewDidLoad() {
        resultTable.backgroundColor = UIColor.clearColor()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        var manager = Manager.sharedInstance
        // Specifying the Headers we need
        manager.session.configuration.HTTPAdditionalHeaders = [
            "token": UserInfo.accessToken
        ]
        
        startLoading()
        var req = Alamofire.request(.GET, "http://54.149.235.253:5000/search_team/lol", parameters: [ "teamName":searchBar.text])
            .responseJSON { (_, _, JSON, _) in
                
                var result: [AnyObject] = [AnyObject]()
                result = JSON as [AnyObject]
                
                self.gotResult(result)
                
        }
    }
    
    func gotResult(result: [AnyObject]){
        stopLoading()
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
        teamName.font = UIFont(name: "AvenirNext-Medium", size: 18)
        cell.addSubview(teamName)
        
        return cell
    }
    
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
