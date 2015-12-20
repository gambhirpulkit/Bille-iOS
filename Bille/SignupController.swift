//
//  ViewController.swift
//  Bille
//
//  Created by Pulkit Gambhir on 12/13/15.
//  Copyright © 2015 Pulkit Gambhir. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignupController: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var txtPwd: UITextField!
    
    var userData : String?
    
    @IBAction func signupBtn(sender: UIButton) {
        
        if ( txtEmail.text! == "" || txtName.text! == "" || txtPhone.text! == "" || txtPwd.text! == "" ) {
            
            let alert = UIAlertController(title: "Sign Up Failed!", message:"Please enter all fields", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in
               // PERFORM ACTION
                })
            self.presentViewController(alert, animated: true){}
            

        }
        else {
        
       //  let param = ["tag": "login", "email": "pulkit1@gmail.com", "password":"aa"]
        let param = ["tag": "register", "name": txtName.text!, "email": txtEmail.text!, "phone":txtPhone.text!, "password": txtPwd.text!]
        print(txtEmail.text!)
        
        
        Alamofire.request(.POST, url!, parameters: param).responseJSON { (responseData) -> Void in
            let swiftyJsonVar = JSON(responseData.result.value!)
            
            print("jsonResponse" ,swiftyJsonVar);
             let resData = swiftyJsonVar["error"].stringValue
            //print(resData[0]["phone"])
            if(resData == "false") {
            self.userData = swiftyJsonVar["user"]["id"].stringValue
            print(self.userData)
                self.performSegueWithIdentifier("goto_otp", sender: self)
                
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if(segue.identifier == "goto_otp") {
            print("testSegue" + userData!)
            let destSegue = segue.destinationViewController as! VerifyOtp
            destSegue.userId = userData!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

