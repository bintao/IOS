//
//  PostViewController.swift
//  Meeet Up
//
//  Created by Kedan Li on 14/11/18.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, RequestResultDelegate {
    
    @IBOutlet var newsTable : UITableView!
    @IBOutlet var menu: UIBarButtonItem!

    var currentChosen:Int = 0
    
    var imageArray : [UIImage]!
    
    //@IBOutlet var menu : UIBarButtonItem!
    var hotImageIcon : UIButton!
    
    var newsArr: [AnyObject]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadata()
        //get news
        var req = ARequest(prefix: "news_list/all/0", method: requestType.GET)
        req.server = "http://54.149.235.253:4000/"
        req.delegate = self
        req.sendRequest()
        //imageScrollimageScrollView.contentSize = image.size
        
    }
    //reload data of the news
    func reloadata(){
        newsArr = DataManager.getNewsInfo()
        imageArray = DataManager.getNewsImages()
        newsTable.reloadData()
    }
    
    func gotResult(prefix: String, result: AnyObject) {
        if (prefix as NSString).substringToIndex(15) == "news_list/all/0" {
            
            var newsInfo = ["news":result]
            //save user info and update image files
            DataManager.saveNewsInfoToLocal(newsInfo)
            self.reloadata()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
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
        
        if indexPath.row == 0{
            return self.view.frame.width * 0.67
        }else{
            return 120
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        

        var cellImage = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, 120))
        cellImage.image = imageArray[indexPath.row]
        cell.addSubview(cellImage)
        
        var img = UIImage()
        img = img.setGradientToImage(cellImage.frame, locationList: [0.0,1.0], colorList: [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.2], startPoint: CGPointMake(0, 120), endPoint: CGPointMake(cellImage.frame.width + 200, -30))
       // img = img.setGradientToImage(cellImage.frame, locationList: [0.0,1.0], colorList: [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0], startPoint: CGPointMake(60, 120), endPoint: CGPointMake(-40, 0))
        //img = img.setGradientToImage(cellImage.frame, locationList: [0.0,1.0], colorList: [253.0/255.0, 76.0/255.0, 83.0 / 255.0, 1.0, 1.0, 1.0, 1.0, 0.0], startPoint: CGPointMake(0, 0), endPoint: CGPointMake(cellImage.frame.width +, 0))
        var coverImage = UIImageView(frame: cellImage.frame)
        coverImage.image = img
        cell.addSubview(coverImage)
        var coverImage2 = coverImage
        cell.addSubview(coverImage2)

        var title = UITextView(frame: CGRectMake(15, 10, self.view.frame.width - 100, 70))
        title.font = UIFont(name: "Palatino-Roman", size: 18)
        title.text = (newsArr[indexPath.row] as [String : AnyObject])["title"] as String
        title.textColor = UIColor.darkGrayColor()
        title.backgroundColor = UIColor.clearColor()
        title.textAlignment = NSTextAlignment.Left
        title.scrollEnabled = false
        title.editable = false
        cell.addSubview(title)

        var time = UILabel(frame: CGRectMake(20, 85, self.view.frame.width - 100, 20))
        time.font = UIFont(name: "Palatino-Bold", size: 14)
        time.text = (newsArr[indexPath.row] as [String : AnyObject])["date"] as? String
        var index = countElements(time.text!) - 7
        time.text = (time.text! as NSString).substringToIndex(index)
        time.textColor = UIColor.grayColor()
        time.alpha = 0.8
        time.backgroundColor = UIColor.clearColor()
        time.textAlignment = NSTextAlignment.Left
        cell.addSubview(time)


        var line = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, 0.7))
        line.backgroundColor = UIColor.lightGrayColor()
        cell.addSubview(line)
        
        if indexPath.row == 0{
            coverImage.removeFromSuperview()
            cellImage.frame.size = CGSizeMake(self.view.frame.width, self.view.frame.width * 0.67)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)

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
