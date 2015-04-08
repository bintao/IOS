
//
//  NewsDisplayViewController.swift
//  Cteemo
//
//  Created by Kedan Li on 15/2/23.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

class NewsDisplayViewController: UIViewController{

    @IBOutlet var web: UIWebView!
    var website : String = ""
    override func viewDidLoad() {
        
        println(website)
        
        let url = NSURL(string: website.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil))
        let request = NSURLRequest(URL: url!)
        self.web.loadRequest(request)
        
     
    }
    
    
    override func viewDidAppear(animated: Bool) {
        println(website)
        
       
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    

}
