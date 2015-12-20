//
//  LogoutController.swift
//  Bille
//
//  Created by Pulkit Gambhir on 12/20/15.
//  Copyright © 2015 Pulkit Gambhir. All rights reserved.
//

import Foundation
import UIKit

class LogoutController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
    }
    
}