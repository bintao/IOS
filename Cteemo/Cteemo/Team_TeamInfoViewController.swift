//
//  Team_TeamInfoViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/8.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

class Team_TeamInfoViewController: UIViewController {

    @IBOutlet var navigation : UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigation.title = TeamInfo.teamName
        // Do any additional setup after loading the view.
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
