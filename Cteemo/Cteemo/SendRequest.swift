
//
//  SendRequest.swift
//  Cteemo
//
//  Created by bintao on 15/1/29.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import Foundation

import UIKit

class SendRequest: NSObject {
    
    class func connectASynchoronous(suffix: String ,info:[String: AnyObject], method:String, returnView: UIViewController?){
        
        var result:[String: AnyObject] = [String: AnyObject]()
        
        var request = NSMutableURLRequest(URL: NSURL(string: InteractingWithServer.getServerAddress() + suffix)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 15)
        
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        var error: NSError?
        
        // create some JSON data and configure the request
        var jsonData: NSData = NSJSONSerialization.dataWithJSONObject(info, options: NSJSONWritingOptions.PrettyPrinted, error: &error)!
        
        request.HTTPBody = jsonData//jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = method
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        //println(request.description)
        
        var queue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            println(data)
            if data != nil && data.length > 0 && error == nil{
                
                if let httpResponse = response as? NSHTTPURLResponse {
                    
                    var error: NSError?
                    
                    var jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error)
                    result = jsonObject as [String: AnyObject]!
                    
                    if result["token"]? != nil{
                        result.updateValue(true, forKey: "success")
                    }else {
                        result.updateValue(false, forKey: "success")
                    }
                }
                
            }
            
        })
        
    }
}
