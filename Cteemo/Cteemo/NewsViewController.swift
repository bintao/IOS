//
//  PostViewController.swift
//  Meeet Up
//
//  Created by Kedan Li on 14/11/18.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, RequestResultDelegate {
    
    @IBOutlet var imageScrollView : CustomPosterView!
    @IBOutlet var newsTable : UITableView!
    @IBOutlet var menu: UIBarButtonItem!

    var imageArray : [UIImage]!
    
    //@IBOutlet var menu : UIBarButtonItem!
    var hotImageIcon : UIButton!
    
    
    var newsArr: [AnyObject] = ["news1", "news2", "news3", "news4"]
    var hotImage = UIImageView(image: UIImage(named: "RED"))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        imageArray = [UIImage]()
        
        var req = ARequest(prefix: "news_list/all/0", method: requestType.GET)
        req.delegate = self
        req.sendRequest()
        
        for var index = 1; index <= 3; index++ {
            var str = "img\(index).jpg"
                    var img : UIImage = UIImage(named: str)!
                    imageArray.append(img)
            }
    }
    
    func gotResult(prefix: String, result: AnyObject) {
        println(result)
       // if prefix.substringToIndex(9)
    }
    
    override func viewDidAppear(animated: Bool) {
        imageScrollView.setup(imageArray)
        
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
