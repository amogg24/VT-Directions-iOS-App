//
//  AppDelegate.swift
//  VTQuest
//
//  Created by Andrew Mogg on 10/20/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    /*
    Create and initialize the Dictionary which will be available globally to all classes in our project.
    KEY     = VT place (building) name
    VALUE   = Object reference of another dictionary containing data about the VT place (building)
    */
    var dict_vtPlaceName_Dict = [String: AnyObject]()
    
    // Create and initialize the Array which will be available globally to all classes in our project
    var vtPlaceNames = [String]()
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Obtain the URL of the LocationData.plist file residing on a server computer
        let locationDataFileURL: NSURL? = NSURL(string: "http://manta.cs.vt.edu/VTQuest/LocationData.plist")
        
        // NSDictionary manages an *unordered* collection of key-value pairs. Instantiate an
        // NSDictionary object and initialize it with the contents of the LocationData.plist file.
        let dictionaryFromFile: NSDictionary? = NSDictionary(contentsOfURL: locationDataFileURL!)
        
        if let dictionaryForLocationDataPlistFile = dictionaryFromFile {
            
            // Typecast the created dictionary of type NSDictionary as Dictionary type
            // and assign it to the class property named dict_vtPlaceName_Dict
            self.dict_vtPlaceName_Dict = dictionaryForLocationDataPlistFile as! Dictionary
            
            /*
            allKeys returns a new array containing the dictionary’s keys as of type AnyObject.
            Therefore, typecast the AnyObject type keys to be of type String.
            The keys in the array are *unordered*; therefore, they need to be sorted.
            */
            self.vtPlaceNames = dictionaryForLocationDataPlistFile.allKeys as! [String]
            
            // Sort the VT place names within itself in alphabetical order
            self.vtPlaceNames.sortInPlace { $0 < $1 }
            
        } else {
            
            // Unable to get the file from the server over the network
            showErrorMessageFor("LocationData.plist")
            return false
        }
        
        return true
    }
    
    /*
    -----------------------------
    MARK: - Display Error Message
    -----------------------------
    */
    
    func showErrorMessageFor(fileName: String) {
        
        /*
        Create a UIAlertController object; dress it up with title, message, and preferred style;
        and store its object reference into local constant alertController
        */
        let alertController = UIAlertController(title: "Unable to Access the File: \(fileName)",
            message: "Possible causes: (a) No network connection, (b) Accessed file is misplaced, or (c) Server is down.",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.window!.makeKeyAndVisible()
        
        // Present the alert controller by calling the presentViewController method
        // of the window object's rootViewController
        self.window!.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
