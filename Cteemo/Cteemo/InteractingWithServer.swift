//  InteractingWithServer.swift
//  NBillBoard
//
//  Created by Kedan Li on 14-10-1.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit

class InteractingWithServer: NSObject {
    

    
    class func getCurrentNet() -> String{
        
        var result: String?
        
        let reach = Reachability()
        var internetReachable = Reachability(hostName: "www.apple.com")
        var status: NetworkStatus = internetReachable.currentReachabilityStatus()
        
        
        if status == 0{
            result = "NO"
        }else if status == 1{
            result = "WIFI"
        }else if status == 2{
            result = "WLAN"
        }
        
        return result!
        
    }
    
    class func getServerAddress() -> String{
        
        return "http://54.149.235.253:5000"
        
    }
    
    class func login(email: String, password: String, returnView: UIViewController){
        
        let info :[String: AnyObject] = ["email": "bintao@cteemo.com", "password": "123"]

        InteractingWithServer.connectASynchoronous("/login", info: info, method:"POST", returnView: returnView, token: "")
    }
    
    class func getUserProfile(token: String){
        
        let info :[String: String] = [:]
        
        InteractingWithServer.connectASynchoronous("/profile", info: info, method:"GET", returnView: nil, token: token)
        
    }

    
    class func connectASynchoronous(suffix: String ,info:[String: AnyObject], method:String, returnView: UIViewController?, token:String){
        
        var result:[String: AnyObject] = [String: AnyObject]()
        
        var request = NSMutableURLRequest(URL: NSURL(string: InteractingWithServer.getServerAddress() + suffix)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        var error: NSError?
        
        // create some JSON data and configure the request
        var jsonData: NSData = NSJSONSerialization.dataWithJSONObject(info, options: NSJSONWritingOptions.PrettyPrinted, error: &error)!
        
        
        request.HTTPBody = jsonData//jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = method
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        println(token)
        
        if token != ""{
            request.addValue(token, forHTTPHeaderField: "token")
        }


        var queue = NSOperationQueue()
        
        println("request")

        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if data != nil && data.length > 0 && error == nil{
                
                if let httpResponse = response as? NSHTTPURLResponse {
                    
                    var error: NSError?
                    
                    var jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error)
                    result = jsonObject as [String: AnyObject]!
                    
                    println(result)
                    
                    if result["token"]? != nil{
                        result.updateValue(true, forKey: "success")
                    }else {
                        result.updateValue(false, forKey: "success")
                    }
                }
                
            }else if data == nil{
                println("empty responsef")
                
            }else if error != nil{
                println(error)
            }
            dispatch_async(dispatch_get_main_queue(), {
                
                println(suffix)

                if suffix == "/login" && method == "POST"{
                    (returnView as Login_LoginBySelfViewController).loginResult(result)
                }else if suffix == "/profile"{
                    
                }

            })
        })
                
    }

    /*
    class func connectSynchoronous(suffix: String ,info:[String: AnyObject], method:String)-> [String:AnyObject]{
        
        var result:[String: AnyObject] = [String: AnyObject]()
        
        var request = NSMutableURLRequest(URL: NSURL(string: InteractingWithServer.getServerAddress() + suffix)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        var error: NSError?
        
        // create some JSON data and configure the request
        var jsonData: NSData = NSJSONSerialization.dataWithJSONObject(info, options: NSJSONWritingOptions.PrettyPrinted, error: &error)!
        
        request.HTTPBody = jsonData//jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = method
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        var returnData = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: &error)!
        if (error == nil){
            
            var data = NSString(data: returnData, encoding: NSASCIIStringEncoding)
            
            //var returnData = httpResponse.textEncodingName!.dataUsingEncoding(NSUTF8StringEncoding)
            var jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(returnData, options: NSJSONReadingOptions.AllowFragments, error: &error)
            
            
            
            if jsonObject != nil{
                result = jsonObject as [String: AnyObject]
                
                println(result)
                
                if result["token"]? != nil{
                    result.updateValue(true, forKey: "success")
                }else {
                    result.updateValue(false, forKey: "success")
                }
                
            }else{
                result.updateValue(false, forKey: "success")
            }
            
        }else{
            result.updateValue(false, forKey: "success")
        }
        return result
    }

    */
    /*

    
class func checkCookie()->Bool{

var result:[String: AnyObject] = [String: AnyObject]()
result = InteractingWithServer.connectSynchoronous("/check_cookie", info: result, method:"POST")
return result["success"] as Bool

}

class func updateLocation(){

var result:[String: AnyObject] = [String: AnyObject]()
let info :[String: AnyObject] = ["latitude": LocationInfo.getCurrentLocation()!.coordinate.latitude, "longitude": LocationInfo.getCurrentLocation()!.coordinate.longitude]
InteractingWithServer.connectASynchoronous("/update_location", info: info, method:"POST")

}

class func addBase(coordinate: CLLocationCoordinate2D)->String{
var result:[String: AnyObject] = [String: AnyObject]()
let info :[String: AnyObject] = ["latitude": coordinate.latitude, "longitude": coordinate.longitude]

result = InteractingWithServer.connectSynchoronous("/add_base", info: info, method:"POST")

if result["success"] as Bool{
return result["baseID"] as String
}else {
return "failed"
}

}

class func connectSynchoronous(suffix: String ,info:[String: AnyObject], method:String)-> [String:AnyObject]{

var result:[String: AnyObject] = [String: AnyObject]()

var request = NSMutableURLRequest(URL: NSURL(string: InteractingWithServer.getServerAddress() + suffix)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)

var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil

var error: NSError?

// create some JSON data and configure the request
var jsonData: NSData = NSJSONSerialization.dataWithJSONObject(info, options: NSJSONWritingOptions.PrettyPrinted, error: &error)!

request.HTTPBody = jsonData//jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
request.HTTPMethod = method
request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//println(request.description)
var returnData = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: &error)!
if (error == nil){

var data = NSString(data: returnData, encoding: NSASCIIStringEncoding)

//println(data)
//var returnData = httpResponse.textEncodingName!.dataUsingEncoding(NSUTF8StringEncoding)
var jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(returnData, options: NSJSONReadingOptions.AllowFragments, error: &error)


if jsonObject != nil{
result = jsonObject as [String: AnyObject]

//println(result)

if result["success"] as Bool{

}else {
result.updateValue(false, forKey: "success")
result.updateValue(result["comment"] as String, forKey: "error")
}
}else{
result.updateValue(false, forKey: "success")
}

}else{
result.updateValue(false, forKey: "success")
}
return result
}
    */

}
