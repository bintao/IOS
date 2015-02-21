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
        return DataManager.getPlistFile("UserInformation.plist")
    }
    
    class func saveUserInfoToLocal(info: [String: AnyObject]){
        DataManager.savePlistFile(info, fileName: "UserInformation.plist")
    }
    
    class func getTeamInfo()->[String: AnyObject]{
        return DataManager.getPlistFile("UserTeam.plist")
    }
    
    class func saveTeamInfoToLocal(info: [String: AnyObject]){
        DataManager.savePlistFile(info, fileName: "UserTeam.plist")
    }
    
    class func getLOLInfo()->[String: AnyObject]{
        return DataManager.getPlistFile("LOLInfo.plist")
    }
    
    class func saveLOLInfoToLocal(info: [String: AnyObject]){
        savePlistFile(info, fileName: "LOLInfo.plist")
    }
    
    class func getNewsInfo()->[String: AnyObject]{
        return DataManager.getPlistFile("News.plist")
    }
    
    class func saveNewsInfoToLocal(info: [String: AnyObject]){
        savePlistFile(info, fileName: "News.plist")
    }


    //get User Icon
    class func getUserIconFromLocal()->UIImage?{
        return DataManager.getImageFromLocal("icon.png")
    }
    class func getLolIconFromLocal()->UIImage?{
        return  DataManager.getImageFromLocal("lolicon.png")
    }
    class func getTeamIconFromLocal()->UIImage?{
        return  DataManager.getImageFromLocal("teamicon.png")
    }

    class func saveTeamIconFromLocal(icon: UIImage){
        DataManager.saveImageToLocal(icon, name: "teamicon.png")
    }
    class func saveLolIconFromLocal(icon: UIImage){
        DataManager.saveImageToLocal(icon, name: "lolicon.png")
    }
    class func saveUserIconFromLocal(icon: UIImage){
        DataManager.saveImageToLocal(icon, name: "icon.png")
        
    }
    
    
    class func saveImageToLocal(image: UIImage, name: String){
        
        let fileManager = NSFileManager()
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var imagePath = paths.stringByAppendingPathComponent(name)
        UIImagePNGRepresentation(image).writeToFile(imagePath, atomically: true)
        
    }
    
    class func getImageFromLocal(name:String)->UIImage?{
        
        var image: UIImage!
        let fileManager = NSFileManager()
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var imagePath = paths.stringByAppendingPathComponent(name)
        if (fileManager.fileExistsAtPath(imagePath)) {
            let getImage = UIImage(contentsOfFile: imagePath)
            image = getImage
        }else{
            
        }
        return image
    }

    class func getPlistFile(fileName:String)->[String: AnyObject]{
        
        
        let fileManager = NSFileManager()
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        path = path.stringByAppendingPathComponent(fileName)
        
        let dict = NSDictionary(contentsOfFile: path)
        
        return dict as [String: AnyObject]
        
    }
    
    class func savePlistFile(info: [String: AnyObject], fileName: String){
        let fileManager = NSFileManager()
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        path = path.stringByAppendingPathComponent(fileName)
        
        let dict : NSDictionary = info
        dict.writeToFile(path, atomically: true)
    }
    
    
    //for uploadImage
        
    class func getURLPath()->String{

        let fileManager = NSFileManager()
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        return paths
    }

    
}
