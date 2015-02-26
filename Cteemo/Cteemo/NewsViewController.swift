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
    var menu: UIBarButtonItem!

    var newsDisplay : NewsDisplayViewController!

    var currentChosen:Int = 0
    
    var imageArray : [UIImage]!
    var originalImage :[UIImage]!
    
    //@IBOutlet var menu : UIBarButtonItem!
    var hotImageIcon : UIButton!
    
    var newsArr: [AnyObject]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu.target = self
        menu.action = Selector("clickMenu:")
        newsArr = DataManager.getNewsInfo()
        imageArray = DataManager.getNewsImages()      
        originalImage = DataManager.getNewsImages()

        var req = ARequest(prefix: "news_list/all/0", method: requestType.GET)
        req.server = "http://54.149.235.253:4000/"
        req.delegate = self
        req.sendRequest()
        //imageScrollimageScrollView.contentSize = image.size
        
    }
    
    //reload data of the news
    func reloadata(){
        
    }
    
    func gotResult(prefix: String, result: AnyObject) {
        if (prefix as NSString).substringToIndex(15) == "news_list/all/0" {
            
            var newsInfo = ["news":result]
            //save user info and update image files
            DataManager.saveNewsInfoToLocal(newsInfo)
            newsArr = result as [AnyObject]
            downloadNewsPictureImages(newsInfo)
        
        }
    }
    
    func downloadNewsPictureImages(info: [String:AnyObject]){
        
        for var index = 0; index < (info["news"] as [AnyObject]).count; index++ {
            
            var imageURL = ((info["news"] as [AnyObject])[index] as [String:AnyObject])["news_pic"] as String
            
            if imageURL != "" && !DataManager.checkIfFileExist((imageURL as NSString).substringFromIndex(countElements(imageURL) - 10) as String) {

                var imgarr = (imageURL as NSString).substringFromIndex(countElements(imageURL) - 10) as String

                
                ImageLoader.sharedLoader.imageForUrl(imageURL, completionHandler:{(image: UIImage?, url: String) in
                    println(image)
                    if image? != nil {
                        DataManager.saveImageToLocal(image!, name: "\(imgarr).png")
                        //reload data after all images are downloaded
                            self.imageArray = DataManager.getNewsImages()
                            self.originalImage = DataManager.getNewsImages()
                            self.newsTable.reloadData()

                    }
                    else {
                    }})
                
                }
            }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clickMenu(sender: AnyObject) {
        
    }
    
    //neturn from news detail
    func clickReturn(sender: AnyObject) {
        
        UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.newsDisplay.view.transform = CGAffineTransformMakeTranslation(self.view.frame.width, 0)
            
            },completion: {
                (value: Bool) in
                self.newsDisplay.view.removeFromSuperview()
                self.newsDisplay.removeFromParentViewController()
                self.newsDisplay = nil
                self.menu.action = Selector("clickMenu:")
                self.menu.image = UIImage(named: "SUMMARY")

        })

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
        
        var imgHeight = imageArray[indexPath.row].size.width * 120 / self.view.frame.width
        var cellImage = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, 120))
        // crop the part image in the center
        cellImage.image = imageArray[indexPath.row].crop(CGRectMake(0, (imageArray[indexPath.row].size.height - imgHeight) / 2, imageArray[indexPath.row].size.width, imgHeight))
        cell.addSubview(cellImage)
        
        var img = UIImage()
        img = img.setGradientToImage(cellImage.frame, locationList: [0.0,1.0], colorList: [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.2], startPoint: CGPointMake(0, 120), endPoint: CGPointMake(cellImage.frame.width + 200, -30))
        var coverImage = UIImageView(frame: cellImage.frame)
        coverImage.image = img
        cell.addSubview(coverImage)

        var title = UITextView(frame: CGRectMake(15, 10, self.view.frame.width - 100, 70))
        title.font = UIFont(name: "Palatino-Roman", size: 20)
        title.text = (newsArr[indexPath.row] as [String : AnyObject])["title"] as String
        title.textColor = UIColor.darkGrayColor()
        title.backgroundColor = UIColor.clearColor()
        title.textAlignment = NSTextAlignment.Left
        title.userInteractionEnabled = false
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
            cellImage.image = imageArray[indexPath.row]
            title.frame.origin = CGPointMake(15, self.view.frame.width * 0.67 - 90)
            title.textColor = UIColor.whiteColor()
            title.font = UIFont(name: "Palatino-Bold", size: 22)
            
            time.frame.origin = CGPointMake(20, self.view.frame.width * 0.67 - 30)
            time.textColor = UIColor.whiteColor()

        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var upbound = indexPath.row - 1
        var downbound = indexPath.row + 1

        var countUp = 0
        var countDown = 0
        
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            

            // hide cover
            if indexPath.row != 0{
                (tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: 0))?.subviews[2] as UIView).alpha = 0
                
            }

            
            while(countUp < 4 && upbound >= 0){
                
                if tableView.cellForRowAtIndexPath(NSIndexPath(forRow: upbound, inSection: 0)) != nil{

                    tableView.cellForRowAtIndexPath(NSIndexPath(forRow: upbound, inSection: 0))!.transform = CGAffineTransformMakeTranslation(0 , -500)
                }
                upbound--
                countUp++
            }
            
            while(countDown < 4 && downbound < self.newsArr.count){
                println(downbound)
                if tableView.cellForRowAtIndexPath(NSIndexPath(forRow: downbound, inSection: 0)) != nil{
                    tableView.cellForRowAtIndexPath(NSIndexPath(forRow: downbound, inSection: 0))!.transform = CGAffineTransformMakeTranslation(0 , 500)
                }
                downbound++
                countDown++
            }

            
            }
            , completion: {
                (value: Bool) in
                
                self.displayNews(indexPath.row)
        })
        
    }

    func displayNews(newsNum: Int){

        var center = newsTable.convertPoint(newsTable.cellForRowAtIndexPath(NSIndexPath(forRow: newsNum, inSection: 0))!.center, toView: UIApplication.sharedApplication().keyWindow)
                
        println(center)
        
        newsDisplay = self.storyboard!.instantiateViewControllerWithIdentifier("newsDisplay")! as NewsDisplayViewController
        println(originalImage)
        
        newsDisplay.newsInfo = newsArr[newsNum] as [String: AnyObject]
        newsDisplay.backImg = originalImage[newsNum]
        newsDisplay.transformPoint = center      // 3
        newsDisplay.parentView = self
        
        self.addChildViewController(newsDisplay)
        newsDisplay.didMoveToParentViewController(self)
        self.view.addSubview(newsDisplay.view)
        
        menu.action = Selector("clickReturn:")
        menu.image = UIImage(named: "left")
        newsTable.reloadData()
        //Do any additional setup after loading the view.
        //self.view.backgroundColor = UIColor(red: 240.0/255, green: 242.0/255, blue: 245.0/255, alpha: 1)
        
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
