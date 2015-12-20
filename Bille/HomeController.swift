//
//  HomeController.swift
//  Bille
//
//  Created by Pulkit Gambhir on 12/13/15.
//  Copyright © 2015 Pulkit Gambhir. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Haneke
import CoreLocation

class HomeController : UIViewController, UITableViewDelegate, UITableViewDataSource,  CLLocationManagerDelegate {
    var config = configUrl()
    var url : String?
    var flag = 0
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchView: UIView!
    
    var nameArr = [String]()
    var imgArr = [String]()
    
    var latString : String = ""
    var longString : String = ""
    
    let locationManager = CLLocationManager()

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {

            // self.usernameLabel.text = prefs.valueForKey("USERNAME") as? String
            
            let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
            
            searchView.addGestureRecognizer(tap)
            
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            

        }
       // tableView.reloadData()

   }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.performSegueWithIdentifier("goto_search", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // println(links.count)
        //print(nameArr.count)
        return nameArr.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("homeCell", forIndexPath: indexPath)
        
        //let linksCell = links[indexPath.row] as TestData
        
        //  println(linksCell.name)
        
        if let linkLabel = cell.viewWithTag(1) as? UILabel {
            linkLabel.text = nameArr[indexPath.row]
        }
        let img: NSURL = NSURL(string: imgArr[indexPath.row])!
        if let linkImg = cell.viewWithTag(2) as? UIImageView {
            linkImg.image = UIImage(named: "placeholder.png")
            
            linkImg.hnk_setImageFromURL(img)
            //print(imgArr[indexPath.row])
        }
        
        return cell
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //self.location = locations[0] as CLLocation
        let location = locations.last!
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        print(String(center.latitude))
        print(center.longitude)
        
        url = config.url + "location_list_offers.php"
        
        let param = ["latitude" : String(center.latitude), "longitude" : String(center.longitude)]
        
        Alamofire.request(.POST, url!, parameters: param).responseJSON { (responseData) -> Void in
            let swiftyJsonVar = JSON(responseData.result.value!)
            
            switch responseData.result {
            case .Success:
                
                
                print("jsonResponse" ,swiftyJsonVar);
                
                for (key,subJson):(String, SwiftyJSON.JSON) in swiftyJsonVar["featured"] {
                    //Do something you want
                    if let title = subJson["name"].string {
                        self.nameArr.append(title)
                        print(self.nameArr[Int(key)!])
                    }
                    if let imageUrl = subJson["slider"].string {
                        self.imgArr.append(imageUrl)
                        
                    }
                    
                }
                self.tableView.reloadData()
                
            case .Failure(let error):
                
                let alert = UIAlertController(title: "No internet connection", message:"Check your internet connection and try again.", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in
                    // PERFORM ACTION
                    })
                self.presentViewController(alert, animated: true){}
                print(error)
            }
            
        }
        tableView.reloadData()

        
        self.locationManager.stopUpdatingLocation()
        
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error: " + error.localizedDescription)
        print("featured bc")
        
        url = config.url + "featured_offers.php"
        
        let param = ["" :""]
        
        Alamofire.request(.POST, url!, parameters: param).responseJSON { (responseData) -> Void in
            let swiftyJsonVar = JSON(responseData.result.value!)
            
            switch responseData.result {
            case .Success:
                
                
                print("jsonResponse" ,swiftyJsonVar);
                
                for (key,subJson):(String, SwiftyJSON.JSON) in swiftyJsonVar["featured"] {
                    //Do something you want
                    if let title = subJson["name"].string {
                        self.nameArr.append(title)
                        print(self.nameArr[Int(key)!])
                    }
                    if let imageUrl = subJson["slider"].string {
                        self.imgArr.append(imageUrl)
                        
                    }
                    
                }
                self.tableView.reloadData()
                
            case .Failure(let error):
                
                let alert = UIAlertController(title: "No internet connection", message:"Check your internet connection and try again.", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in
                    // PERFORM ACTION
                    })
                self.presentViewController(alert, animated: true){}
                print(error)
            }
            
        }
        tableView.reloadData()
    }
    
    
}
