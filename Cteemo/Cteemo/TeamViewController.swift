
//
//  PeopleViewController.swift
//  Meeet Up
//
//  Created by Kedan Li on 14/11/18.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit

class TeamViewController: UIViewController , UITableViewDataSource, UITableViewDelegate  {

    var hasOwnteam = false
    
    @IBOutlet var createTeam : UIView!
    @IBOutlet var teamInfo : UIView!

    @IBOutlet var otherChoices : UITableView!

    var teams: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        otherChoices.backgroundColor = UIColor.clearColor()
        
        teams = ["UIUC","UCB","Stanford","MIT","University of Michigan"]

        if hasOwnteam{
            
        }else{
            var iconBack = UIImage(color: UIColor(red: 255.0, green: 244.0, blue: 73.0, alpha: 1), size: CGSizeMake(300, 300))

        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        ((self.parentViewController as UINavigationController).parentViewController as MainViewController).showTabb()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        ((self.parentViewController as UINavigationController).parentViewController as MainViewController).hideTabb()

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        var cellbg = UIImageView(image: UIImage(named: "textField"))
        cellbg.frame = CGRectMake(10, 0, tableView.frame.width - 20, 60)
        cell.addSubview(cellbg)
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
