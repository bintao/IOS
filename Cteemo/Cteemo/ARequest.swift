
//
//  SendRequest.swift
//  Cteemo
//
//  Created by bintao on 15/1/29.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

protocol RequestResultDelegate: NSObjectProtocol{
    func gotResult(prefix:String ,result: [String: AnyObject])
}

//a request class
class ARequest: NSObject {
  
    
    var delegate:RequestResultDelegate!
    var info: [String: AnyObject]!
    var method: String!
    var prefix: String!
    var result: [String: AnyObject]!
    var token: String!
    
    
    var uploadRequest: NSURLSessionUploadTask?

    override init() {
        
    }
    
    init(prefix: String, method: String, data: [String: AnyObject]){
        super.init()
        self.method = method
        self.info = data
        self.prefix = prefix
    }
    // send req
    func sendRequest(){
        InteractingWithServer.connectASynchoronous(self.prefix, info: self.info, method: self.method, theRequest:self, token: self.token)
    }

    // upload photo
    func uploadPhoto(){
        
        var manager1 = Manager.sharedInstance
        // Specifying the Headers we need
        //manager.requestSerializer = [AFJSONRequestSerializer serializer]
        println(UserInfo.accessToken)
        manager1.session.configuration.HTTPAdditionalHeaders = [
            "token": UserInfo.accessToken
        ]
        
        var parameters = NSMutableDictionary()
        var filePath = NSURL(fileURLWithPath: DataManager.getUserIconPath())!
        
        var request = AFHTTPRequestSerializer().multipartFormRequestWithMethod("POST", URLString: "http://54.149.235.253:5000/upload_profile_icon", parameters: parameters, constructingBodyWithBlock: { (formData) -> Void in
            formData.appendPartWithFileURL(filePath, name: "upload", fileName: "upload", mimeType: "image/png", error: nil)
            return
            }, error: nil)
        
        
        var manager = AFURLSessionManager(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        manager.session.configuration.HTTPAdditionalHeaders = [
            "token": UserInfo.accessToken
        ]
        
        uploadRequest = manager.uploadTaskWithStreamedRequest(request, progress: nil) { (response, obj, error) -> Void in
            println(obj)
            println(error)
            println("dfdf")
        }
        uploadRequest?.resume()
        
    }
    
    func gotResult(result: [String: AnyObject]){
        
        self.result = result
        
        self.delegate.gotResult(self.prefix, result: result)
        
    }

}
