
//
//  IntroViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/4/3.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

//
//  ViewController.swift
//  IntroView
//
//  Created by Kedan Li on 14/11/10.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet var scroller: UIScrollView!
    
    @IBOutlet var back: UIView!
    
    @IBOutlet var controller: UIPageControl!
    
    
    var start: UIButton!

    var firstView: first!
    var secondView: second!
    var thirdView: third!
    
    
    var currentPageNum = 0;
    
    func startApp() {
        performSegueWithIdentifier("returnFromIntro", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        start = nil
        
        scroller.contentSize = CGSizeMake(view.frame.width * 3, view.frame.height)
        scroller.showsHorizontalScrollIndicator = false
        
        var gestureReco = UIPanGestureRecognizer(target: self, action: "dragged:")
        back.addGestureRecognizer(gestureReco)
        
        firstView = NSBundle.mainBundle().loadNibNamed("1View", owner: self, options: nil)[0] as first
        firstView.alpha = 0
        scroller.addSubview(firstView)
        
        secondView = NSBundle.mainBundle().loadNibNamed("2View", owner: self, options: nil)[0] as second
        secondView.center.x = secondView.center.x + view.frame.width
        scroller.addSubview(secondView)
        
        thirdView = NSBundle.mainBundle().loadNibNamed("3View", owner: self, options: nil)[0] as third
        thirdView.center.x = thirdView.center.x + view.frame.width * 2
        scroller.addSubview(thirdView)
        
        scroller.backgroundColor = UIColor(red: 213/255.0, green: 231/255.0, blue: 239/255.0, alpha: 1)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        firstView.setup()
        secondView.setup()
        thirdView.setup()
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.firstView.alpha = 1
        })
    }
    
    func dragged(recognizer : UIPanGestureRecognizer) {
        
        let translation = recognizer.translationInView(self.view)
        scroller.setContentOffset(CGPointMake(view.frame.width * CGFloat(currentPageNum) - translation.x, 0), animated: false)
        
        if recognizer.state == UIGestureRecognizerState.Cancelled || recognizer.state == UIGestureRecognizerState.Failed || recognizer.state == UIGestureRecognizerState.Ended{
            determineCurrentPage()
        }
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var index = scroller.contentOffset.x
        if index >= 0 && index < view.frame.width{
            firstView.moveEverythingAccordingToIndex(index)
        }
        if index >= 0 && index < view.frame.width * 2{
            secondView.moveEverythingAccordingToIndex(index)
        }
        if index >= view.frame.width && index < view.frame.width * 3{
            thirdView.moveEverythingAccordingToIndex(index)
        }
        
        // for button
        if index >= view.frame.width * 2{
            if start == nil{
                start = UIButton(frame: self.view.convertRect(self.thirdView.start.frame, fromView: thirdView))
                start.setImage(UIImage(named: "Start App "), forState: UIControlState.Normal)
                start.addTarget(self, action: "startApp", forControlEvents: UIControlEvents.TouchUpInside)
                self.view.addSubview(start)
            }
        }else{
            if start != nil{
                start.removeFromSuperview()
                start = nil
            }
        }
        
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    }
    
    func determineCurrentPage(){
        if scroller.contentOffset.x > view.frame.width / 2 + view.frame.width * CGFloat(currentPageNum) && currentPageNum < 2{
            currentPageNum++
        }else if scroller.contentOffset.x < view.frame.width * CGFloat(currentPageNum - 1) + view.frame.width / 2 && currentPageNum > 0{
            currentPageNum--
        }
        controller.currentPage = currentPageNum
        scroller.setContentOffset(CGPointMake(view.frame.width * CGFloat(currentPageNum), 0), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

class first: UIView{
    
    
    @IBOutlet var cloudUp: UIImageView!
    @IBOutlet var cloudDown: UIImageView!
    @IBOutlet var circle: UIImageView!
    @IBOutlet var lab: UIImageView!
    
    
    func setup() {
        
        circle.frame.size = CGSizeMake(superview!.frame.width / 1.2, superview!.frame.width / 1.2)
        circle.center = self.superview!.center
        
        cloudUp.frame.size = CGSizeMake(superview!.frame.width / 1.6, superview!.frame.width / 2)
        cloudUp.center = CGPointMake(self.frame.width, cloudDown.frame.height / 2 + 20)
        cloudDown.frame.size = CGSizeMake(superview!.frame.width / 2, superview!.frame.width / 2.5)
        cloudDown.center = CGPointMake(circle.frame.origin.x, circle.frame.origin.y)
        
        lab.frame.size = CGSizeMake(circle.frame.width, circle.frame.width / 5)
        lab.center = CGPointMake(circle.center.x, circle.frame.origin.y + circle.frame.height + 10 + lab.frame.height / 2)
        
    }
    
    func moveEverythingAccordingToIndex(index: CGFloat){
        
        var stay = CGAffineTransformMakeTranslation(index, 0)
        var up = CGAffineTransformMakeTranslation(index, -index / 3)
        var down = CGAffineTransformMakeTranslation(index, index / 3)
        var speed4 = CGAffineTransformMakeTranslation(index / 4, index / 10)
        var speed5 = CGAffineTransformMakeTranslation(-index / 5, index / 5)
        

        var speed1 = CGAffineTransformMakeTranslation(-index / 5, 0)
        cloudDown.transform = speed1
        
        var speed2 = CGAffineTransformMakeTranslation(index / 3, 0)
        cloudUp.transform = speed2
        
        var speed3 = CGAffineTransformMake(1 - index / 200, 0, 0, 1 - index / 200, 0, index * index / 1000)
        lab.transform = speed3
        
        if index <= self.frame.width / 2{
            superview!.backgroundColor = UIColor(red: 213/255.0, green: 231/255.0, blue: 239/255.0, alpha: 1)
        }else if index > self.frame.width / 2 && index < self.frame.width - 10{
            let total = self.frame.width / 2 - 10
            let current = index - self.frame.width / 2
            superview!.backgroundColor = UIColor(red: (213 - current / total * 80) / 255.0, green: (231 - current / total * 44)/255.0, blue: (239 - current / total * 23)/255.0, alpha: 1)
        }else{
            superview!.backgroundColor = UIColor(red: 133/255.0, green: 187/255.0, blue: 216/255.0, alpha: 1)
        }
        
    }
    
}

class second: UIView{
    
    
    @IBOutlet var circle: UIImageView!
    @IBOutlet var cloudUp: UIImageView!
    @IBOutlet var cloudDown: UIImageView!
    @IBOutlet var cloudDown2: UIImageView!
    @IBOutlet var lab: UIImageView!
    @IBOutlet var star: UIImageView!
    @IBOutlet var icon1: UIImageView!
    @IBOutlet var icon2: UIImageView!

    func setup(){
        
        self.backgroundColor = UIColor.clearColor()
        
        cloudUp.frame.size = CGSizeMake(superview!.frame.width / 2.5, superview!.frame.width / 3)
        cloudUp.center = CGPointMake(self.frame.width, cloudDown.frame.height / 2)
        cloudDown.frame.size = CGSizeMake(superview!.frame.width / 3, superview!.frame.width / 5)
        cloudDown.center = CGPointMake(0, frame.height - cloudDown.frame.height / 2 - 20)
        cloudDown2.frame.size = CGSizeMake(superview!.frame.width / 3, superview!.frame.width / 5)
        cloudDown2.center = CGPointMake(frame.width, frame.height - cloudDown.frame.height / 2 - 20)
        
        circle.frame.size = CGSizeMake(superview!.frame.width / 1.2, superview!.frame.width / 1.2)
        circle.center = self.superview!.center
        
        star.frame = CGRectMake(circle.frame.origin.x , circle.frame.origin.y - 80 + circle.frame.height, 80, 80)
        
        lab.frame.size = CGSizeMake(circle.frame.width, circle.frame.width / 5)
        lab.center = CGPointMake(circle.center.x, circle.frame.origin.y + circle.frame.height + 10 + lab.frame.height / 2)
        lab.transform = CGAffineTransformMake(0, 0, 0, 0, 0, 1000)
        
        icon1.frame = CGRectMake(circle.frame.origin.x, circle.frame.origin.y + circle.frame.height / 4, circle.frame.width / 4, circle.frame.width / 4)
        icon1.alpha = 0
        icon2.frame = CGRectMake(circle.center.x + circle.frame.height / 4, circle.center.y, circle.frame.width / 4, circle.frame.width / 4)
        icon2.alpha = 0

    }
    
    //0 - width * 2
    
    func moveEverythingAccordingToIndex(index: CGFloat){
        
        var speed1 = CGAffineTransformMakeTranslation(-index / 5, 0)
        cloudDown.transform = speed1
        
        var speed2 = CGAffineTransformMakeTranslation(index / 2, 0)
        cloudUp.transform = speed2
        
        if index <= self.frame.width / 2{
            lab.transform = CGAffineTransformMake(0, 0, 0, 0, 0, 1000)
        }else if index > self.frame.width / 2 && index < self.frame.width{
            let total = self.frame.width / 2
            let current = index - self.frame.width / 2
            lab.transform = CGAffineTransformMake(current / total, 0, 0, current / total, 0, 1 / (current / total) / (current / total))
        }else if index <= self.frame.width{
            lab.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0)
        }else if index > self.frame.width && index <= self.frame.width * 1.5{
            let total = self.frame.width * 0.5
            let current = index - self.frame.width
            lab.transform = CGAffineTransformMake(1 - current / total, 0, 0, 1 - current / total, 0, 1 / ( 1 - current / total) / (1 - current / total))
        }else{
            lab.transform = CGAffineTransformMake(0, 0, 0, 0, 0, 1000)
        }
        
        
        if index <= self.frame.width * 0.5{
            star.transform = CGAffineTransformMakeScale(0, 0)
        }else if index > self.frame.width * 0.5 && index <= self.frame.width * 0.7{
            let total = self.frame.width * 0.2
            let current = index - self.frame.width * 0.5
            star.transform = CGAffineTransformMakeScale(current / total * 1.2, current / total * 1.2)
        }else if index > self.frame.width * 0.7 && index <= self.frame.width * 0.8{
            let total = self.frame.width * 0.1
            let current = index - self.frame.width * 0.7
            star.transform = CGAffineTransformMakeScale(1.2 - current / total * 0.2, 1.2 - current / total * 0.2)
        }else{
            star.transform = CGAffineTransformMakeScale(1, 1)
        }
        
        if index <= self.frame.width * 0.7{
            icon1.alpha = 0
        }else if index > self.frame.width * 0.7 && index <= self.frame.width * 0.8{
            let total = self.frame.width * 0.1
            let current = index - self.frame.width * 0.7
            icon1.alpha = current / total
        }else{
            icon1.alpha = 1
        }
        
        if index <= self.frame.width * 0.8{
            icon2.alpha = 0
        }else if index > self.frame.width * 0.8 && index <= self.frame.width * 0.9{
            let total = self.frame.width * 0.1
            let current = index - self.frame.width * 0.8
            icon2.alpha = current / total
        }else{
            icon2.alpha = 1
        }

    }
    
}

class third: UIView{
    
    @IBOutlet var lab: UIImageView!
    @IBOutlet var icons: UIView!
    @IBOutlet var circle: UIImageView!
    @IBOutlet var start: UIButton!

    func setup(){
        
        self.backgroundColor = UIColor.clearColor()
        
        circle.frame.size = CGSizeMake(superview!.frame.width / 1.2, superview!.frame.width / 1.2)
        circle.center = CGPointMake(superview!.center.x, superview!.center.y - 50)
                
        lab.frame.size = CGSizeMake(circle.frame.width, circle.frame.width / 3.5)
        lab.center = CGPointMake(circle.center.x, circle.frame.origin.y + circle.frame.height + 10 + lab.frame.height / 2)
        lab.transform = CGAffineTransformMake(0, 0, 0, 0, 0, 1000)
        
        icons.center = CGPointMake(circle.frame.origin.x + circle.frame.width / 4, circle.frame.origin.y + circle.frame.width / 4)
        icons.alpha = 0
        
        start.frame.size = CGSizeMake((circle.frame.width - 50), (circle.frame.width - 50) * 0.4)
        start.center = CGPointMake(circle.center.x, superview!.frame.height - circle.frame.width * 0.2 - 20)
        start.transform = CGAffineTransformMakeScale(0, 0)
        
    }
    
    // width - width * 3
    func moveEverythingAccordingToIndex(index: CGFloat){
        
        if index <= self.frame.width * 1.7{
            icons.alpha = 0
        }else if index > self.frame.width * 1.6 && index <= self.frame.width * 1.8{
            let total = self.frame.width * 0.2
            let current = index - self.frame.width * 1.6
            icons.alpha = current / total
        }else{
            icons.alpha = 1
        }

        if index <= self.frame.width * 1.5{
            lab.transform = CGAffineTransformMake(0, 0, 0, 0, 0, 1000)
        }else if index > self.frame.width * 1.5 && index < self.frame.width * 2{
            let total = self.frame.width * 0.5
            let current = index - self.frame.width * 1.5
            lab.transform = CGAffineTransformMake(current / total, 0, 0, current / total, 0, 1 / (current / total) / (current / total))
        }else{
            lab.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0)
        }
        
        if index <= self.frame.width * 1.9{
            start.transform = CGAffineTransformMakeScale(0, 0)
        }else if index > self.frame.width * 1.9 && index < self.frame.width * 2{
            let total = self.frame.width * 0.1
            let current = index - self.frame.width * 1.9
            start.transform = CGAffineTransformMakeScale(current / total, current / total)
        }else{
            start.transform = CGAffineTransformMake(1, 0, 0, 1, index - self.frame.width * 2, 0)
        }
    }
    
}
