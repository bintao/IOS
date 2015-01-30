
//
//  SendRequest.swift
//  Cteemo
//
//  Created by bintao on 15/1/29.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

protocol ResultDelegate:NSObjectProtocol{
    func gotResult(prefix:String ,result: [String: AnyObject])
}

//a request class
class ARequest: NSObject {
  
    

    var delegate:ResultDelegate!
    
    var info: [String: AnyObject]!
    var method: String!
    var prefix: String!
    var returnView: UIViewController!
    var result: [String: AnyObject]!
    
    init(prefix: String, method: String, data: [String: AnyObject], returnView: UIViewController){
        super.init()
        self.method = method
        self.info = data
        self.returnView = returnView
        self.prefix = prefix
        
    }
    
    func sendRequest(){
        InteractingWithServer.connectASynchoronous(self.prefix, info: self.info, method: self.method, theRequest:self)
    }
    
    func gotResult(result: [String: AnyObject]){
        
        self.result = result
        
        self.delegate.gotResult(self.prefix, result: result)
    }

}
