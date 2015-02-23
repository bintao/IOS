//
//  bracket.swift
//  Cteemo
//
//  Created by bintao on 15/2/23.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

class Bracket: UIViewController {
    
    @IBOutlet weak var cen: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
     
        self.spawnImage()
        
    }
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    func spawnImage() {
        var url = "http://images.challonge.com/UIUC.png"
        
        ImageLoader.sharedLoader.imageForUrl(url, completionHandler:{(image: UIImage?, url: String) in
            println(url)
            if image? != nil {
                
                let imageView = SOXPanRotateZoomImageView(image: image)
                
                imageView.center = self.cen.center
                self.view.addSubview(imageView)
                
            }
            else {
                let image = UIImage(named: "error.png")!
                let imageView = SOXPanRotateZoomImageView(image: image)
                imageView.center = self.view.center
                self.view.addSubview(imageView)
            }}
        )
        
    }

    
}

