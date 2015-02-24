
//
//  NewsDisplayViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/23.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

class NewsDisplayViewController: UIViewController, UIScrollViewDelegate{

    var parentView:NewsViewController!
    
    var newsInfo = [String: AnyObject]()
    var backImg = UIImage()
    var transformPoint = CGPoint()

    var scroller : UIScrollView!
    var backImage : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(parentView.newsTable.frame.origin.y)
        
        backImage = UIImageView(frame: CGRectMake(0, parentView.newsTable.frame.origin.y, parentView.view.frame.width, parentView.view.frame.width * backImg.size.height / backImg.size.width))
        backImage.image = backImg
        self.view.addSubview(backImage)
        
        var upBoard = UIView(frame: CGRectMake(0, 0, backImage.frame.width, (backImage.frame.height - 120) / 2))
        upBoard.backgroundColor = UIColor.whiteColor()
        backImage.addSubview(upBoard)
        
        var downBoard = UIView(frame: CGRectMake(0, (backImage.frame.height - 120) / 2 + 120, backImage.frame.width, (backImage.frame.height - 120) / 2))
        downBoard.backgroundColor = UIColor.whiteColor()
        backImage.addSubview(downBoard)
        
        scroller = UIScrollView(frame: CGRectMake(0, backImage.frame.origin.y + backImage.frame.height, parentView.view.frame.width, self.view.frame.height - (backImage.frame.origin.y + backImage.frame.height - 60)))
        scroller.delegate = self
        scroller.contentSize = CGSizeMake(scroller.frame.width, 1000)
        self.view.addSubview(scroller)
        
        
        backImage.transform = CGAffineTransformMakeTranslation(0, transformPoint.y - backImage.center.y - parentView.newsTable.frame.origin.y)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.backImage.transform = CGAffineTransformMakeTranslation(0, 0)
                (self.backImage.subviews[0] as UIView).center = CGPointMake((self.backImage.subviews[0] as UIView).center.x, (self.backImage.subviews[0] as UIView).center.y - (self.backImage.subviews[0] as UIView).frame.height)
            (self.backImage.subviews[1] as UIView).center = CGPointMake((self.backImage.subviews[1] as UIView).center.x, (self.backImage.subviews[1] as UIView).center.y + (self.backImage.subviews[1] as UIView).frame.height)
            }
            , completion: {
                (value: Bool) in
                
        })
        
    }
        
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0{
            backImage.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1 + -scrollView.contentOffset.y / 100,1 + -scrollView.contentOffset.y / 100), CGAffineTransformMakeTranslation(0, (-scrollView.contentOffset.y / 100) * backImage.frame.height / 3))
        }
    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        backImage.transform = CGAffineTransformMakeScale(1, 1)
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
