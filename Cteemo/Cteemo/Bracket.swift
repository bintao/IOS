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
    
    @IBOutlet weak var webview: UIWebView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let url = NSURL(string: "http://challonge.com/UIUC_Hearthstone/module?theme=100&multiplier=0.9&match_width_multiplier=1.2.png")
        let request = NSURLRequest(URL: url!)
        self.webview.loadRequest(request)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
      
        
    }
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
   
    
}

