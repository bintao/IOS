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
    
    class func getNewsInfo()->[AnyObject]{
        if DataManager.checkIfFileExist("News.plist"){
            return (DataManager.getPlistFile("News.plist") as [String:AnyObject]!)["news"] as [AnyObject]
        }else {
            return [AnyObject]()
        }
    }
    
    
    class func getNewsImages(newsArr:[AnyObject])->[UIImage]{
        
        var imgArr = [UIImage]()
        
        for var index = 0; index < newsArr.count; index++ {
            
            var imgarr = (newsArr[index] as [String:AnyObject])["news_pic"] as String
            
            if imgarr != "" && DataManager.checkIfFileExist("\((imgarr as NSString).substringFromIndex(countElements(imgarr) - 10)).png"){
                imgArr.append(DataManager.getImageFromLocal("\((imgarr as NSString).substringFromIndex(countElements(imgarr) - 10)).png")!)
            }else{
                imgArr.append(UIImage(named: "img1.jpg")!)
            }
        }
        
        return imgArr
    }
    
    class func saveNewsInfoToLocal(info: [String: AnyObject]){

        /*
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
                    var imgarr = (localInfo[index] as [String:AnyObject])["news_pic"] as String
                    DataManager.deleFileInLocal("\((imgarr as NSString).substringFromIndex(countElements(imgarr) - 10)).png")
                }
            }
        }*/
        
    DataManager.savePlistFile(info, fileName: "News.plist")
        
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

    class func getPlistFile(fileName:String)->[String: AnyObject]?{
        
        let fileManager = NSFileManager()
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        path = path.stringByAppendingPathComponent(fileName)
        
        let dict = NSDictionary(contentsOfFile: path)
        
        return dict as [String: AnyObject]?
        
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
