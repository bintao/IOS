
//
//  SendRequest.swift
//  Cteemo
//
//  Created by bintao on 15/1/29.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

protocol RequestResultDelegate: NSObjectProtocol{
    func gotResult(prefix:String ,result: [String: AnyObject])
}

//a request class
class ARequest: NSObject {
  
    
<<<<<<< HEAD
    var delegate:RequestResultDelegate!
=======
<<<<<<< HEAD

=======
<<<<<<< HEAD
    var delegate:RequestResultDelegate!
=======
<<<<<<< HEAD
    var method: String!
    
=======
>>>>>>> FETCH_HEAD
    var delegate:ResultDelegate!
>>>>>>> FETCH_HEAD
>>>>>>> FETCH_HEAD
    
    var info: [String: AnyObject]!
    var method: String!
    var prefix: String!
    var result: [String: AnyObject]!
    
    init(prefix: String, method: String, data: [String: AnyObject]){
        super.init()
        self.method = method
        self.info = data
        self.prefix = prefix
        
    }
    // send req
    func sendRequest(){
        InteractingWithServer.connectASynchoronous(self.prefix, info: self.info, method: self.method, theRequest:self)
    }
    
    func gotResult(result: [String: AnyObject]){
        
        self.result = result
        
        self.delegate.gotResult(self.prefix, result: result)
    }

}
