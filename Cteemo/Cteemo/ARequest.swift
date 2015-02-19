
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
    func gotResult(prefix:String ,result: AnyObject)
}

enum requestType {
    case GET
    case POST
    case DELETE
}

//a request class
class ARequest: NSObject {
  
    
    var delegate:RequestResultDelegate?
    
    var parameters: [String: AnyObject]?
    var method: requestType!
    var prefix: String!
    var result: AnyObject?
    
    var server = "http://54.149.235.253:5000/"
    
    var uploadRequest: NSURLSessionUploadTask?

    override init() {
        
    }
    
    init(prefix: String, method: requestType){
        super.init()
        self.method = method
        self.prefix = prefix
        
    }
    
    init(prefix: String , method: requestType, parameters: [String: AnyObject]?){
        super.init()
        self.method = method
        self.parameters = parameters
        self.prefix = prefix
    
    }
    // send request without token
    func sendRequest(){
        
        if requestType.GET == method {
            var req = Alamofire.request(.GET, server + prefix, parameters: parameters)
                .responseJSON { (_, _, JSON, _) in
                    if JSON != nil{
                        self.gotResult(JSON!)
                    }
            }
        }else if requestType.POST == method{
        
            var req = Alamofire.request(.POST, server + prefix, parameters: parameters)
                .responseJSON { (_, _, JSON, _) in
                    if JSON != nil{
                        self.gotResult(JSON!)
                    }
            }
        }else if requestType.DELETE == method{
            var req = Alamofire.request(.DELETE, server + prefix, parameters: parameters)
                .responseJSON { (_, _, JSON, _) in
                    if JSON != nil{
                        self.gotResult(JSON!)
                    }
            }

        }
    }

    // send request with token
    func sendRequestWithToken(token: String){
        
        var manager = Manager.sharedInstance
        // Specifying the Headers we need
        
        manager.session.configuration.HTTPAdditionalHeaders = [
            "token": token
        ]
        
        sendRequest()
        
    }
    // upload photo
    func uploadPhoto(){
        
        var manager1 = Manager.sharedInstance
        //manager.requestSerializer = [AFJSONRequestSerializer serializer]
        manager1.session.configuration.HTTPAdditionalHeaders = [
            "token": UserInfoGlobal.accessToken!
        ]
        
        var parameters = NSMutableDictionary()
        var filePath = NSURL(fileURLWithPath: DataManager.getUserIconPath())!
        
        var request = AFHTTPRequestSerializer().multipartFormRequestWithMethod("POST", URLString: "http://54.149.235.253:5000/upload_profile_icon", parameters: parameters, constructingBodyWithBlock: { (formData) -> Void in
            formData.appendPartWithFileURL(filePath, name: "upload", fileName: "upload", mimeType: "image/png", error: nil)
            return
            }, error: nil)
        
        
        var manager = AFURLSessionManager(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        manager.session.configuration.HTTPAdditionalHeaders = [
            "token": UserInfoGlobal.accessToken!
        ]
        
        uploadRequest = manager.uploadTaskWithStreamedRequest(request, progress: nil) { (response, obj, error) -> Void in
            
            if obj != nil{
                self.gotResult(obj)
            }
        }
        uploadRequest?.resume()
    }

    
    func gotResult(result: AnyObject){
        
        self.result = result
        
        if self.delegate != nil{
            self.delegate!.gotResult(self.prefix, result: result)
        }
        
    }

}
