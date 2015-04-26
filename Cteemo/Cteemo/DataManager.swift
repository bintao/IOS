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
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var imagePath = paths.stringByAppendingPathComponent(name)
        
        UIImagePNGRepresentation(image).writeToFile(imagePath, atomically: true)
        
    }
    
    class func getImageFromLocal(name:String)->UIImage?{
        
        var image: UIImage!
        let fileManager = NSFileManager()
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var imagePath = paths.stringByAppendingPathComponent(name)
        if (fileManager.fileExistsAtPath(imagePath)) {
            let getImage = UIImage(contentsOfFile: imagePath)
            image = getImage
        }else{
            
        }
        return image
    }

    class func checkIfFileExist(fileName: String)->Bool{
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
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
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        var getImagePath = paths.stringByAppendingPathComponent(fileName)
        
        var manager = NSFileManager.defaultManager()
        
        manager.removeItemAtPath(getImagePath, error: nil)
    }
    
    class func removeFile(){
    }
    
    //for uploadImage
        
    class func getURLPath()->String{

        let fileManager = NSFileManager()
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        return paths
    }

    
}
