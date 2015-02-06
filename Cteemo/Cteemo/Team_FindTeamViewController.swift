//
//  Team_FindTeamViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/4.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

class Team_FindTeamViewController: UIViewController, UISearchBarDelegate{
    
    
    @IBOutlet var search: UISearchBar!
    @IBOutlet var loading : UIActivityIndicatorView!
    @IBOutlet var resultTable : UITableView!

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        var manager = Manager.sharedInstance
        // Specifying the Headers we need
        manager.session.configuration.HTTPAdditionalHeaders = [
            "token": UserInfo.accessToken
        ]
        
        startLoading()
        var req = Alamofire.request(.GET, "http://54.149.235.253:5000/search_team/lol", parameters: ["teamName": searchBar.text])
            .responseJSON { (_, _, JSON, _) in
                
                var result: [AnyObject] = [AnyObject]()
                println(JSON)
                result = JSON as [AnyObject]
                
                self.gotResult(result)
        }
    }
    
    func gotResult(result: [AnyObject]){
        stopLoading()
        print(result)
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
