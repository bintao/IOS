//
//  ViewController.swift
//  Meeet Up
//
//  Created by Kedan Li on 14/11/19.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController, UITabBarDelegate {
    
    @IBOutlet var tabbar: UITabBar!
    
    @IBOutlet var news: UIView!
    @IBOutlet var team: UIView!
    @IBOutlet var tournament: UIView!
    @IBOutlet var me: UIView!

    var tabbarShouldAppear = true

    var content : UIViewController!
    var uploadRequest: NSURLSessionUploadTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabbar.transform = CGAffineTransformMakeTranslation(0, self.tabbar.frame.height)
        self.tabbar.alpha = 0
       
        
//        var parameters = NSMutableDictionary()
//        parameters["upload"] = UIImagePNGRepresentation(UserInfo.icon)
//        var filePath = NSURL(fileURLWithPath: DataManager.getUserIconPath())!
//        
//        println(UserInfo.accessToken)
//        
//        var manager = AFHTTPRequestOperationManager(baseURL: NSURL(string: "http://54.149.235.253:5000/"))
//        
//        manager.POST("upload_profile_icon", parameters: parameters, constructingBodyWithBlock: { (data) -> Void in
//            data.appendPartWithFileURL(filePath, name: "upload", error: nil)
//            return
//        }, success: { (op, obj) -> Void in
//            println(obj)
//        }) { (op, err) -> Void in
//            println(err)
//        }
        var manager1 = Manager.sharedInstance
        // Specifying the Headers we need
        //manager.requestSerializer = [AFJSONRequestSerializer serializer]
        println(UserInfo.accessToken)
        manager1.session.configuration.HTTPAdditionalHeaders = [
            "token": "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQyMzg4NDg4OCwiaWF0IjoxNDIzNTI0ODg4fQ.IjU0ZDQyOGZiMDU1MWRjMWYxMTdjOTZhNiI.--n9JSm00dvVZng9g8eDlD3-cRgxFITYIHG-qxruDrc"
        ]
        
        var parameters = NSMutableDictionary()
        var filePath = NSURL(fileURLWithPath: DataManager.getUserIconPath())!
        
        var request = AFHTTPRequestSerializer().multipartFormRequestWithMethod("POST", URLString: "http://54.149.235.253:5000/upload_profile_icon", parameters: parameters, constructingBodyWithBlock: { (formData) -> Void in
            formData.appendPartWithFileURL(filePath, name: "upload", fileName: "upload", mimeType: "image/png", error: nil)
            return
            }, error: nil)
        
        
        var manager = AFURLSessionManager(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        manager.session.configuration.HTTPAdditionalHeaders = [
            "token": "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQyMzg4NDg4OCwiaWF0IjoxNDIzNTI0ODg4fQ.IjU0ZDQyOGZiMDU1MWRjMWYxMTdjOTZhNiI.--n9JSm00dvVZng9g8eDlD3-cRgxFITYIHG-qxruDrc"
        ]
        
        uploadRequest = manager.uploadTaskWithStreamedRequest(request, progress: nil) { (response, obj, error) -> Void in
            println(obj)
            println(error)
        }
        uploadRequest?.resume()
        
//        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//        NSProgress *progress = nil;
//        
//        NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//        NSLog(@"Error: %@", error);
//        } else {
//        NSLog(@"%@ %@", response, responseObject);
//        }
//        }];
//        
//        [uploadTask resume];
        
        
        
//        manager.POST("upload_image", parameters: parameters, constructingBodyWithBlock: { (formData: AFMultipartFormData) -> Void in
//            formData.appendPartWithFileURL(filePath, name: "upload", error: nil)
//        }, success: { (operation, obj) -> Void in
//            println(obj)
//            println("success")
//        }, failure: { (operation, error) -> Void in
//            println(error)
//        })
        
        
        
        
        
        
        
//        [manager POST:@"http://example.com/resources.json" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileURL:filePath name:@"image" error:nil];
//        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@", responseObject);
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        }];
//        

<<<<<<< HEAD
        
        var manager = Manager.sharedInstance
        // Specifying the Headers we need
        
        manager.session.configuration.HTTPAdditionalHeaders = [
            "token": "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQyMzg4NDg4OCwiaWF0IjoxNDIzNTI0ODg4fQ.IjU0ZDQyOGZiMDU1MWRjMWYxMTdjOTZhNiI.--n9JSm00dvVZng9g8eDlD3-cRgxFITYIHG-qxruDrc"//UserInfo.accessToken
        ]
        
        
//        var request = A
//        [ASIFormDataRequest requestWithURL:url];
//        [request setPostValue:self.username forKey:@"username"];
//        [request setPostValue:self.password forKey:@"password"];
//        [request startAsynchronous];

        Alamofire.upload(.POST, "http://54.149.235.253:5000/upload_profile_icon", NSData())
            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                println(totalBytesWritten)
                println(bytesWritten)
            }
            .responseJSON { (_, _, JSON, error) in
                println(error)
                println(JSON)
        }
        
        let url = NSURL(string: "http://54.149.235.253:5000/upload_profile_icon")!
        var request = NSURLRequest(URL: url)
        
        let parameters = ["upload": UIImagePNGRepresentation(UserInfo.icon)]
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: parameters)
        
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            println(error)
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
            println("done")
        })
        task.resume()
        
        
        //manager.session.configuration.HTTPAdditionalHeaders = ["Content-Type" : "multipart/form-data"]
        

=======
        var manager2 = Manager.sharedInstance
        // Specifying the Headers we need
        //manager.requestSerializer = [AFJSONRequestSerializer serializer]
        manager2.session.configuration.HTTPAdditionalHeaders = [
            "token": UserInfo.accessToken
        ]

//        var requ = NSURLRequest(URL: NSURL(string: "http://54.149.235.253:5000/upload_profile_icon")!)
//        var encoding =  Alamofire.ParameterEncoding.URL
//        let param = ["upload": UIImagePNGRepresentation(UserInfo.icon)]
//        (requ, _) = encoding.encode(requ, parameters: param)
//        
//        alamoRequest = Alamofire.Manager.sharedInstance.request(requ).response { (request, response, data, error) in
//            println(data)
//            println(response)
//            println(error)
//            println("sdds")
//        }

        /*
        Alamofire.upload(.POST, "http://54.149.235.253:5000/upload_profile_icon", UIImagePNGRepresentation(UserInfo.icon)
                ).progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                    println(totalBytesWritten)
                    println(bytesWritten)
                }
                .responseJSON { (_, _, JSON, _) in
                    println(JSON)
            }

        
        Alamofire.request(.POST, "http://54.149.235.253:5000/upload_profile_icon", parameters: param)
            .response { (request, response, data, error) in
                println(request)
                println(response)
                println(error)
                print("sdds")

            
        }*/
>>>>>>> FETCH_HEAD
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        
        if !UserInfo.userIsLogined(){
            FBSession.activeSession().closeAndClearTokenInformation()
            self.performSegueWithIdentifier("login", sender: self)
           

        }else{
            
            if tabbarShouldAppear {
                showTabb()
                self.view.bringSubviewToFront(self.tabbar)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if item.title! == "News"{
            self.view.bringSubviewToFront(news)
            news.alpha = 0
            displayView(news)
            self.view.bringSubviewToFront(tabbar)
        }else if item.title! == "Tournament"{
            self.view.bringSubviewToFront(tournament)
            tournament.alpha = 0
            displayView(tournament)
            self.view.bringSubviewToFront(tabbar)
        }else if item.title! == "Team"{
            self.view.bringSubviewToFront(team)
            team.alpha = 0
            displayView(team)
            self.view.bringSubviewToFront(tabbar)
        }else if item.title! == "Me"{
            self.view.bringSubviewToFront(me)
            me.alpha = 0
            displayView(me)
            self.view.bringSubviewToFront(tabbar)
        }
    }
    
    func displayView(content: UIView){
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            content.alpha = 1
            
            }
            , completion: {
                (value: Bool) in
                
        })
        
    }
    
   // display the new view controller
    func displayContentController(content: UIViewController){
        self.addChildViewController(content)
        content.didMoveToParentViewController(self)          // 3
        content.view.alpha = 0
        self.view.addSubview(content.view)
        
        //reset the tab bar to front
        self.view.bringSubviewToFront(self.tabbar)

        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.content.view.alpha = 1
            
            }
            , completion: {
                (value: Bool) in
                
        })
        
    }
    
 
    //hide tab bar
    
    func hideTabb(){
        tabbarShouldAppear = false
        if tabbar.alpha > 0{
        UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.tabbar.alpha = 0
            self.tabbar.transform = CGAffineTransformMakeTranslation(0, self.tabbar.frame.height)
            }
            , completion: {
                (value: Bool) in
                
        })
        }
    }
    //display the tab bar
    func showTabb(){
        tabbarShouldAppear = true

        if tabbar.alpha < 1{
        
            UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
            self.tabbar.alpha = 1
            self.tabbar.transform = CGAffineTransformMakeTranslation(0, 0)
            }
            , completion: {
                (value: Bool) in
                
            })
        }
    }
    
    func logout(){
        hideTabb()
        UserInfo.cleanUserData()
        FBSession.activeSession().closeAndClearTokenInformation()
        self.performSegueWithIdentifier("login", sender: self)
    }

    
    @IBAction func returnToMain(segue : UIStoryboardSegue) {
        
    }
    
}

