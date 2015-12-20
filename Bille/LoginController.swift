//
//  LoginController.swift
//  Bille
//
//  Created by Pulkit Gambhir on 12/13/15.
//  Copyright © 2015 Pulkit Gambhir. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPwd: UITextField!
    
    
    @IBAction func loginBtn(sender: AnyObject) {
        
        if ( txtEmail.text! == "" ||  txtPwd.text! == "" ) {
            
            let alert = UIAlertController(title: "Sign Up Failed!", message:"Please enter all fields", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in
                // PERFORM ACTION
                })
            self.presentViewController(alert, animated: true){}
            
            
        }
        else {
          
            //  let param = ["tag": "login", "email": "pulkit1@gmail.com", "password":"aa"]
            let param = ["tag": "login", "email": txtEmail.text!, "password": txtPwd.text!]
            print(txtEmail.text!)
            
            
            Alamofire.request(.POST, url!, parameters: param).responseJSON { (responseData) -> Void in
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                print("jsonResponse" ,swiftyJsonVar);
                let resData = swiftyJsonVar["error"].stringValue
                //print(resData[0]["phone"])
                if(resData == "false") {
                    let userId = swiftyJsonVar["user"]["id"].stringValue
                    print(userId)
                    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    prefs.setObject(userId, forKey: "USERID")
                    prefs.setInteger(1, forKey: "ISLOGGEDIN")
                    prefs.synchronize()
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }
                else {
                    let alert = UIAlertController(title: "Sign Up Failed!", message: "Email/phone already exists.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in
                        // PERFORM ACTION
                        })
                    self.presentViewController(alert, animated: true){}
                }
                
            }
            
            
        }
        
    }
    
    
    var config = configUrl()
    var url : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        url = config.url + "login.php"
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    
}