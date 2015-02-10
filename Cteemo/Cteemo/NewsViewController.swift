//
//  PostViewController.swift
//  Meeet Up
//
//  Created by Kedan Li on 14/11/18.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var imageScroll : UIScrollView!
    @IBOutlet var newsTable : UITableView!
    @IBOutlet var menu: UIBarButtonItem!

    //@IBOutlet var menu : UIBarButtonItem!
    var hotImageIcon : UIButton!
    
    
    var newsArr: [AnyObject] = ["news1", "news2", "news3", "news4"]
    var hotImage = UIImageView(image: UIImage(named: "RED"))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        // Hot Image Icon
        // Icon frame
        hotImageIcon = UIButton(frame: CGRectMake(45, 18, 70, 70))
        hotImageIcon.setImage(UIImage(named: "RED"), forState: UIControlState.Normal)
        // text frame
        var imageText = UILabel(frame: CGRectMake(12, 25, 80, 20))
        // text attributes
        imageText.font = UIFont(name: "AvenirNext-Bold", size: 22)
        imageText.textColor = UIColor.whiteColor()
        imageText.text = "HOT"
        // addsubview
        self.view.addSubview(hotImageIcon)
        hotImageIcon.addSubview(imageText)
        */
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickMenu(sender: AnyObject) {
        
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArr.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        var cellImage = UIImageView(frame: CGRectMake(0, 10, 125, 85))
        cellImage.backgroundColor = UIColor.darkGrayColor()
        cell.addSubview(cellImage)
        
        return cell
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
