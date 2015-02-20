//
//  CustomPosterViewController.swift
//  Cteemo
//
//  Created by Wang Yu on 2/10/15.
//  Copyright (c) 2015 Kedan Li. All rights reserved.
//

import UIKit

class CustomPosterView: UIView {

    var current:UIImageView!
    var previous:UIImageView!
    var next:UIImageView!

    var pagec: UIPageControl!
    
    var images: [UIImage]!

    func setup(imgs: [UIImage]){
        
        var gestureReco = UIPanGestureRecognizer(target: self, action: "dragged:")
        self.addGestureRecognizer(gestureReco)
        
        images = imgs
        
        current = UIImageView(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
        current.image = images[0]
        previous = UIImageView(frame: CGRectMake(-self.frame.width, 0, self.frame.width, self.frame.height))
        previous.image = images[images.count - 1]
        next = UIImageView(frame: CGRectMake(self.frame.width, 0, self.frame.width, self.frame.height))
        next.image = images[1]
        self.addSubview(current)
        self.addSubview(next)
        self.addSubview(previous)

        pagec = UIPageControl()
        pagec.center = CGPointMake(self.center.x, self.frame.height - 30)
        pagec.currentPage = 0
        pagec.numberOfPages = images.count
        self.addSubview(pagec)
    
    }
    
    func dragged(sender: UIPanGestureRecognizer){
        var x = sender.translationInView(self).x
        current.transform = CGAffineTransformMakeTranslation(x, 0)
        next.transform = CGAffineTransformMakeTranslation(x, 0)
        previous.transform = CGAffineTransformMakeTranslation(x, 0)

        if sender.state == UIGestureRecognizerState.Cancelled || sender.state == UIGestureRecognizerState.Ended{
            self.userInteractionEnabled = false
            if x > 0{
                scrollRight()
            }else if x < 0{
                scrollLeft()
            }
        }
    }
    
    func scrollRight(){
        UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.current.transform = CGAffineTransformMakeTranslation(self.frame.width, 0)
            self.next.transform = CGAffineTransformMakeTranslation(self.frame.width, 0)
            self.previous.transform = CGAffineTransformMakeTranslation(self.frame.width, 0)
            }
            , completion: {
                (value: Bool) in
                self.userInteractionEnabled = true
            self.getPrevious()
        })

    }
    
    func scrollLeft(){
        UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.current.transform = CGAffineTransformMakeTranslation(-self.frame.width, 0)
            self.next.transform = CGAffineTransformMakeTranslation(-self.frame.width, 0)
            self.previous.transform = CGAffineTransformMakeTranslation(-self.frame.width, 0)

            }
            , completion: {
                (value: Bool) in
                self.userInteractionEnabled = true
                self.getNext()
        })
        
    }
    
    func getPrevious(){
        
        var num = pagec.currentPage - 1
        if num < 0{
            num = images.count - 1
        }
        pagec.currentPage = num
        
        next.image = current.image
        current.image = previous.image
        
        num = pagec.currentPage - 1
        if num < 0{
            num = images.count - 1
        }
        previous.image = images[num]
        
        self.current.transform = CGAffineTransformMakeTranslation(0, 0)
        self.next.transform = CGAffineTransformMakeTranslation(0, 0)
        self.previous.transform = CGAffineTransformMakeTranslation(0, 0)
        
    }
    
    func getNext(){
        
        var num = pagec.currentPage + 1
        if num >= pagec.numberOfPages{
            num = 0
        }
        pagec.currentPage = num
        
        previous.image = current.image
        current.image = next.image
        
        num = pagec.currentPage + 1
        if num >= pagec.numberOfPages{
            num = 0
        }
        next.image = images[num]
        
        self.current.transform = CGAffineTransformMakeTranslation(0, 0)
        self.next.transform = CGAffineTransformMakeTranslation(0, 0)
        self.previous.transform = CGAffineTransformMakeTranslation(0, 0)
        
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
