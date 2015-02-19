//
//  DataManager.swift
//  WalkingEmpire
//
//  Created by Kedan Li on 14/11/22.
//  Copyright (c) 2014年 Kedan Li. All rights reserved.
//

import UIKit

class DataManager: NSObject {
   
    // initialize plist
    class func initializeUserInfo(){
        
        let fileManager = NSFileManager()
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        path = path.stringByAppendingPathComponent("UserInformation.plist")
        var resource = NSBundle.mainBundle().pathForResource("UserInformation", ofType: "plist") as String?
        
        var dict = NSDictionary(contentsOfFile: resource!)
            fileManager.copyItemAtPath(resource!, toPath: path, error: nil)

        path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        path = path.stringByAppendingPathComponent("UserTeam")
        resource = NSBundle.mainBundle().pathForResource("UserTeam", ofType: "plist") as String?
        dict = NSDictionary(contentsOfFile: resource!)
        fileManager.copyItemAtPath(resource!, toPath: path, error: nil)
        
        path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        path = path.stringByAppendingPathComponent("LOLInfo")
        resource = NSBundle.mainBundle().pathForResource("LOLInfo", ofType: "plist") as String?
        dict = NSDictionary(contentsOfFile: resource!)
        fileManager.copyItemAtPath(resource!, toPath: path, error: nil)
    }
    
    
    class func getUserInfo()->[String: AnyObject]{
        
        let fileManager = NSFileManager()
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        path = path.stringByAppendingPathComponent("UserInformation.plist")
        
        let dict = NSDictionary(contentsOfFile: path)

        return dict as [String: AnyObject]
        
    }
    
    class func saveUserInfoToLocal(info: [String: AnyObject?]){
        
        let fileManager = NSFileManager()
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        path = path.stringByAppendingPathComponent("UserInformation.plist")
        
        var data = [String: AnyObject]()
        let arr = info.keys.array
        for var index = 0; index < info.count; index++ {
            if info[arr[index]]? != nil{
                data[arr[index]] = info[arr[index]]!;
            }else{
                data[arr[index]] = nil
            }
        }
        
        let dict : NSDictionary = data
        dict.writeToFile(path, atomically: true)


    }
    
    class func getTeamInfo()->[String: AnyObject]{
        
        let fileManager = NSFileManager()
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        path = path.stringByAppendingPathComponent("UserTeam.plist")
        
        let dict = NSDictionary(contentsOfFile: path)
        
        return dict as [String: AnyObject]
        
    }
    
    class func saveTeamInfoToLocal(info: [String: AnyObject?]){
        
        let fileManager = NSFileManager()
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        path = path.stringByAppendingPathComponent("UserTeam.plist")
        
        var data = [String: AnyObject]()
        let arr = info.keys.array
        for var index = 0; index < info.count; index++ {
            if info[arr[index]]? != nil{
                data[arr[index]] = info[arr[index]]!;
            }else{
                data[arr[index]] = nil
            }
        }
        
        let dict : NSDictionary = data
        dict.writeToFile(path, atomically: true)
        
    }
    
    class func getLOLInfo()->[String: AnyObject]{
        
        let fileManager = NSFileManager()
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        path = path.stringByAppendingPathComponent("LOLInfo.plist")
        
        let dict = NSDictionary(contentsOfFile: path)
        
        return dict as [String: AnyObject]
        
    }
    
    class func saveLOLInfoToLocal(info: [String: AnyObject?]){
       
        println(info)
        let fileManager = NSFileManager()
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        path = path.stringByAppendingPathComponent("LOLInfo.plist")
        
        
        var data = [String: AnyObject]()
        let arr = info.keys.array
        for var index = 0; index < info.count; index++ {
            if info[arr[index]]? != nil{
                data[arr[index]] = info[arr[index]]!;
            }else{
                data[arr[index]] = nil
            }
        }
        
        let dict : NSDictionary = data
        dict.writeToFile(path, atomically: true)
        
    }

    class func saveUserIconFromLocal(icon: UIImage){

        let fileManager = NSFileManager()
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var imagePath = paths.stringByAppendingPathComponent("icon.png")
        UIImagePNGRepresentation(icon).writeToFile(imagePath, atomically: true)
    }

    class func getUserIconPath()->String{
        let fileManager = NSFileManager()
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var imagePath = paths.stringByAppendingPathComponent("icon.png")
        
        return imagePath
    }
    //get User Icon
    class func getUserIconFromLocal()->UIImage?{
        var image: UIImage!
        let fileManager = NSFileManager()
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var imagePath = paths.stringByAppendingPathComponent("icon.png")
        if (fileManager.fileExistsAtPath(imagePath)) {
            let getImage = UIImage(contentsOfFile: imagePath)
            image = getImage
        }else{
            
        }
        
        return image
    }

    
    //get User Icon
    class func getTeamIconFromLocal()->UIImage{
        var image: UIImage!
        let fileManager = NSFileManager()
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var imagePath = paths.stringByAppendingPathComponent("teamicon.png")
        if (fileManager.fileExistsAtPath(imagePath)) {
            let getImage = UIImage(contentsOfFile: imagePath)
            image = getImage
        }else{
            
        }
        return image
    }
    
    
    class func saveTeamIconFromLocal(icon: UIImage){
        
        let fileManager = NSFileManager()
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var imagePath = paths.stringByAppendingPathComponent("teamicon.png")
        UIImagePNGRepresentation(icon).writeToFile(imagePath, atomically: true)
    }

}
