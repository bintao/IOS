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
    
    class func getNewsInfo()->[AnyObject]{
        return (DataManager.getPlistFile("News.plist") as [String:AnyObject])["news"] as [AnyObject]
    }
    
    class func saveNewsInfoToLocal(info: [String: AnyObject]){

        if checkIfFileExist("News.plist"){
            
            // clean old image file if exist
            var localInfo = getNewsInfo()
            
            for var index = 0; index < localInfo.count; index++ {
                
                // determine if the image is found in the old array
                var found:Bool = false
                
                for var index1 = 0; index1 < (info["news"] as [AnyObject]).count; index1++ {
                    if (localInfo[index] as [String:AnyObject])["news_pic"] as String == ((info["news"] as [AnyObject])[index1] as [String:AnyObject])["news_pic"] as String{
                        found = true
                        break;
                    }
                }
                if !found {
                    // delete the image in local
                    DataManager.deleFileInLocal("news\(index).png")
                }
            }
        }
        
    DataManager.savePlistFile(info, fileName: "News.plist")
        
        
        for var index = 0; index < (info["news"] as [AnyObject]).count; index++ {
            
            var imageURL = ((info["news"] as [AnyObject])[index] as [String:AnyObject])["news_pic"] as String
            
            if imageURL != "" && !checkIfFileExist("news\(index).png"){
                var imgName = "news\(index).png"
                ImageLoader.sharedLoader.imageForUrl(imageURL, completionHandler:{(image: UIImage?, url: String) in
                    println(image)
                    if image? != nil {
                        DataManager.saveImageToLocal(image!, name: imgName)
                    }
                    else {
                    }})

                
            }
        
        }

       
        
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
        println(image)
        let fileManager = NSFileManager()
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var imagePath = paths.stringByAppendingPathComponent(name)
        println(name
        )
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
    
    class func checkIfFileExist(fileName: String)->Bool{
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        var getImagePath = paths.stringByAppendingPathComponent(fileName)
        
        var checkValidation = NSFileManager.defaultManager()
        
        if (checkValidation.fileExistsAtPath(getImagePath))
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    class func deleFileInLocal(fileName: String){
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        var getImagePath = paths.stringByAppendingPathComponent(fileName)
        
        var manager = NSFileManager.defaultManager()
        
        manager.removeItemAtPath(getImagePath, error: nil)
    }
    
    class func removeFile(){
    }
    
    //for uploadImage
        
    class func getURLPath()->String{

        let fileManager = NSFileManager()
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        return paths
    }

    
}
