//
//  Login_AddPhoto.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/2.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

class Team_AddPhoto: UIViewController, UIScrollViewDelegate{

    @IBOutlet var circleCropper : UIImageView!
    @IBOutlet var resizer : UIScrollView!

    var sourceImage: UIImage!
    var imgView: UIImageView!
    
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        imgView = UIImageView(image: sourceImage)
        self.resizer.addSubview(imgView)
        self.resizer.contentSize = imgView.frame.size
        
        // set the minzoom scale to make it safe
        if imgView.frame.width <= imgView.frame.height{
            resizer.minimumZoomScale = resizer.frame.width / imgView.frame.width
        }else{
            resizer.minimumZoomScale = resizer.frame.height / imgView.frame.height
        }
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        println(resizer.contentOffset)
        return self.imgView
    }
    
    @IBAction func submitPhoto(sender : UIButton) {
        
        cutImage()
        self.performSegueWithIdentifier("returnToTeamWithPhoto", sender: self)
    }
    
    func cutImage(){
        
        println(resizer.zoomScale)
        
        sourceImage = sourceImage.crop(CGRectMake(resizer.contentOffset.x / resizer.zoomScale, resizer.contentOffset.y / resizer.zoomScale, resizer.frame.width / resizer.zoomScale, resizer.frame.height / resizer.zoomScale))
        sourceImage = sourceImage.roundCornersToCircle()
        sourceImage = sourceImage.changeImageSize(CGSizeMake(200, 200))
        // save user icon
        TeamInfoGlobal.teamicon = sourceImage
        TeamInfoGlobal.saveTeamIcon()
    }
}
