//
//  Login_SchoolSearch.swift
//  Cteemo
//
//  Created by Kedan Li on 15/1/24.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

class Login_SchoolSearchViewController: UIViewController, UITextFieldDelegate , UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var schoolSearch : UITextField!
    @IBOutlet var schoolResult : UITableView!

    var chosenSchool: String = "School"
    var schools:[String] = [String]()

    override func viewDidLoad() {
        schoolSearch.becomeFirstResponder()
        schools = ["Public","UIUC","SCSU","PURDUE","MIT","Others"]
        
        schoolResult.backgroundColor = UIColor.clearColor()
        schoolResult.reloadData()
        
    }
    


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "gotSchoolResult"{
            
            var controller: Login_SchoolAndPhoto = segue.destinationViewController as! Login_SchoolAndPhoto
            
            controller.school.text = self.chosenSchool as String
        }
        
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schools.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        var school = UILabel(frame: CGRectMake(20, 0, 200, 40))
        school.font = UIFont(name: "AvenirNext-Regular", size: 23)
        school.text = schools[indexPath.row]
        school.textColor = UIColor.grayColor()
        school.textAlignment = NSTextAlignment.Left
        school.adjustsFontSizeToFitWidth = true
        
        cell.addSubview(school)

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        chosenSchool = schools[indexPath.row]
        self.performSegueWithIdentifier("gotSchoolResult", sender: self)
    }

}
