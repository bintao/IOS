//
//  Login_AddPhoto.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/2.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

class Login_AddPhoto: UIViewController, UIScrollViewDelegate{

    @IBOutlet var circleCropper : UIImageView!
    @IBOutlet var resizer : UIScrollView!

    var sourceImage: UIImage!
    var imgView: UIImageView!
    
    // determine whether the image is processed
    var imageCutted = false
    
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
        self.performSegueWithIdentifier("returnWithPhoto", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "returnWithPhoto" && imageCutted{
            
            var controller: Login_SchoolAndPhoto = segue.destinationViewController as Login_SchoolAndPhoto
            
            controller.icon = self.sourceImage
        }
        
    }
    
    func cutImage(){
        
        println(resizer.zoomScale)
        
        sourceImage = sourceImage.crop(CGRectMake(resizer.contentOffset.x, resizer.contentOffset.y, resizer.frame.width / resizer.zoomScale, resizer.frame.height / resizer.zoomScale))
        sourceImage = sourceImage.roundCornersToCircle()

        imageCutted = true
    }
}
