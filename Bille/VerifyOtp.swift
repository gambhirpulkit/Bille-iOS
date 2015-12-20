//
//  VerifyOtp.swift
//  Bille
//
//  Created by Pulkit Gambhir on 12/13/15.
//  Copyright © 2015 Pulkit Gambhir. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class VerifyOtp : UIViewController {
    
    var userId : String = ""
    
    @IBOutlet weak var txtOtp: UITextField!
    
    @IBAction func verifyOtp(sender: UIButton) {
        
        if ( txtOtp.text! == "" ) {
            
            let alert = UIAlertController(title: "Wait!", message:"Please enter OTP.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in
                // PERFORM ACTION
                })
            self.presentViewController(alert, animated: true){}
            
            
        }
        else {
            print(userId + "userid")
 
            
            let param = ["u_id": userId, "otp": txtOtp.text! ]
            print("parama" + param["u_id"]! + param["otp"]!)
            
            Alamofire.request(.POST, url!, parameters: param).validate().responseJSON { (responseData) -> Void in
                switch responseData.result {
                case .Success:
                    let swiftyJsonVar = JSON(responseData.result.value!)
                
                    print("jsonResponse" ,swiftyJsonVar);
                    let resData = swiftyJsonVar["error"].stringValue
                    //print(resData[0]["phone"])
                    print(resData)
                    if (resData == "false") {
                        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        prefs.setObject(self.userId, forKey: "USERID")
                        prefs.setInteger(1, forKey: "ISLOGGEDIN")
                        prefs.synchronize()
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    else {
                        
                        let alert = UIAlertController(title: "Incorrect code!", message:"Please enter correct code.", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in
                            // PERFORM ACTION
                            })
                        self.presentViewController(alert, animated: true){}
                        
                    }
                    
                    
                case .Failure(let error):
                    
                    let alert = UIAlertController(title: "No internet connection", message:"Check your internet connection and try again.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in
                        // PERFORM ACTION
                        })
                    self.presentViewController(alert, animated: true){}
                    print(error)
                }
                
            }
        
    }
    
}
    
    var config = configUrl()
    var url : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        url = config.url + "otp_verify.php"
        print(url! + "url")
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
}