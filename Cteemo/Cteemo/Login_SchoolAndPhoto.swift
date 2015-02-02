//
//  Login_SchoolAndPhoto.swift
//  Cteemo
//
//  Created by Kedan Li on 15/1/24.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit

class Login_SchoolAndPhoto: UIViewController, UITextFieldDelegate {

    @IBOutlet var bg : UIImageView!
    @IBOutlet var submit : UIButton!
    @IBOutlet var skip : UIButton!
    @IBOutlet var male : UIButton!
    @IBOutlet var female : UIButton!
    @IBOutlet var addPhoto : UIButton!

    @IBOutlet var lolID : UITextField!
    @IBOutlet var school : UITextField!


    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {

        self.performSegueWithIdentifier("searchSchool", sender: self)

        return false
    }
    
    @IBAction func returnToLoginSchoolAndPhoto(segue : UIStoryboardSegue) {
        
    }
}
