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
    
    @IBOutlet var loading : UIActivityIndicatorView!
    
    var newsDisplay : NewsDisplayViewController!
    
    var currentChosen:Int = 0
    
    let tableHeight:CGFloat = 140
    
    var imageUrl = [String]()
    
    //@IBOutlet var menu : UIBarButtonItem!
    var hotImageIcon : UIButton!
    
    var newsArr: [AnyObject] = [AnyObject]()
    
    var weburl :[AnyObject] = [AnyObject]()
    
    var website = ""
    
    var isLoading:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentChosen = newsArr.count / 10
        updateNews(0)
    
    }
    
    //update the data of the news
    func updateNews(page: Int){
        var req = ARequest(prefix: "http://54.149.235.253:4000/news_list/all/0", method: requestType.GET)
        req.server = ""
        req.delegate = self
        req.sendRequest()
    }
    
    func gotResult(prefix: String, result: AnyObject) {
        if (prefix as NSString).substringFromIndex(36) == "/all/0" {
            
              for var index = 0; index < (result as [AnyObject]).count; index++ {
            
                var weburl = ((result as [AnyObject])[index] as [String:AnyObject])["news_url"] as String
                
                self.weburl.append(weburl)
                
                
            }
            
            //need update
            if newsArr.count == 0 || (newsArr[0] as [String: AnyObject])["title"] as String != ((result as [AnyObject])[0] as [String: AnyObject])["title"] as String{
                
                newsArr = result as [AnyObject]
                var newsInfo = ["news":newsArr]
                
            //save user info and update image files

                downloadNewsPictureImages(newsInfo)
                currentChosen = newsArr.count / 10

            }else{
                stopLoading()
            }
        }else if (prefix as NSString).substringToIndex(36) == "http://54.149.235.253:4000/news_list"{
            newsArr = newsArr + (result as [AnyObject])
            var newsInfo = ["news":newsArr]
            //save user info and update image files
            downloadNewsPictureImages(newsInfo)
            
        }
        
        //renew currentChosen
        currentChosen = newsArr.count / 10

    }
    
    // download the images from server
    func downloadNewsPictureImages(info: [String:AnyObject]){
        
        var count = 0
        var downloadCount = 0
        println(info)
        
        
        
        for var index = 0; index < (info["news"] as [AnyObject]).count; index++ {
            
            var imageURL = ((info["news"] as [AnyObject])[index] as [String:AnyObject])["news_pic"] as String
            
            if imageURL != ""  {
                
                
                self.imageUrl.append(imageURL)
                //loadpicture
                
            }//url is not empty
            else{
            
                self.imageUrl.append("")
            
            }
        }//end for 
        
        
          self.newsTable.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //neturn from news detail
    
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
            return tableHeight
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -30 && !isLoading{
            isLoading = true
            startLoading()
            updateNews(currentChosen)
        }
    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        isLoading = false
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if imageUrl.count != 0 && imageUrl.count > indexPath.row{
            
            var pic :UIImage!
            
            ImageLoader.sharedLoader.imageForUrl(imageUrl[indexPath.row], completionHandler:{(image: UIImage?, url: String) in
                if image != nil {
                    
                    pic = image
                }
                else{
                    
                    pic = UIImage(named: "img1.png")!
                    
                }
                
                var imgHeight = pic.size.width * self.tableHeight / self.view.frame.width
                var cellImage = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.tableHeight))
                // crop the part image in the center
                cellImage.image = pic.crop(CGRectMake(0, (pic.size.height - imgHeight) / 2, pic.size.width, imgHeight))
                cell.addSubview(cellImage)
                
                
                var img = UIImage()
                img = img.setGradientToImage(cellImage.frame, locationList: [0.0,1.0], colorList: [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.2], startPoint: CGPointMake(0, self.tableHeight), endPoint: CGPointMake(cellImage.frame.width + 200, -30))
                var coverImage = UIImageView(frame: cellImage.frame)
              
                coverImage.image = img
                cell.addSubview(coverImage)
                
                
                var title = UITextView(frame: CGRectMake(15, 10, self.view.frame.width - 100, 90))
                title.font = UIFont(name: "Palatino-Bold", size: 21)
                title.text = (self.newsArr[indexPath.row] as [String : AnyObject])["title"] as String
                title.textColor = UIColor.darkGrayColor()
                title.backgroundColor = UIColor.clearColor()
                title.textAlignment = NSTextAlignment.Left
                title.userInteractionEnabled = false
                cell.addSubview(title)
                
                
                var time = UILabel(frame: CGRectMake(20, self.tableHeight - 30, self.view.frame.width - 100, 20))
                time.font = UIFont(name: "Palatino-Bold", size: 14)
                time.text = (self.newsArr[indexPath.row] as [String : AnyObject])["date"] as? String
                var index = countElements(time.text!) - 7
                time.text = (time.text! as NSString).substringToIndex(index)
                time.textColor = UIColor.darkGrayColor()
                time.alpha = 0.8
                time.backgroundColor = UIColor.clearColor()
                time.textAlignment = NSTextAlignment.Left
                cell.addSubview(time)
                
                
                var line = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, 0.7))
                line.backgroundColor = UIColor.lightGrayColor()
                cell.addSubview(line)
                
                
                if indexPath.row == 0 {
                    coverImage.removeFromSuperview()
                    cellImage.frame.size = CGSizeMake(self.view.frame.width, self.view.frame.width * 0.67)
                    cellImage.image = pic
                    title.frame.origin = CGPointMake(15, self.view.frame.width * 0.67 - 90)
                    title.textColor = UIColor.whiteColor()
                    title.font = UIFont(name: "Palatino-Bold", size: 22)
                    
                    time.frame.origin = CGPointMake(20, self.view.frame.width * 0.67 - 30)
                    time.textColor = UIColor.whiteColor()
                    
                }
              
                
            })
        
     
        }
        return cell
    
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
        
        if indexPath.row < self.weburl.count {
            
        self.website = self.weburl[indexPath.row] as String
        
        
        }
        
        
       // gotonewsdetail
        
          self.performSegueWithIdentifier("gotonewsdetail", sender: self)
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotonewsdetail"{
            
            var controller: NewsDisplayViewController = segue.destinationViewController as NewsDisplayViewController
            controller.website = self.website
        }
    }
    
    
    func startLoading(){
        newsTable.userInteractionEnabled = false
        newsTable.setContentOffset(CGPointMake(0, -50), animated: true)
        loading.startAnimating()

    }
    
    func stopLoading(){
        newsTable.setContentOffset(CGPointMake(0, 0), animated: true)
        newsTable.userInteractionEnabled = true
        loading.stopAnimating()
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
