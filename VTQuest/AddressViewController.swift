//
//  AddressViewController.swift
//  VTQuest
//
//  Created by Andrew Mogg on 10/22/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//

import UIKit
import CoreLocation

class AddressViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var mapTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet var addressTextField: UITextField!
    
    // Declare a property to contain the absolute file path for the maps.html file
    var mapsHtmlFilePath: String?
    
    var googleMapQuery = ""
    
    var addressEnteredToShowOnMap = ""
    
    // dataObjectToPass is the data object to pass to the downstream view controller (i.e., AddressMapViewController)
    var dataObjectToPass: [String] = ["googleMapQuery", "adressEnteredToShowOnMap"]
    
    // Instantiate a CLLocationManager object
    var locationManager = CLLocationManager()
    
    var userAuthorizedLocationMonitoring = false
    
    /*
    -----------------------
    MARK: - View Life Cycle
    -----------------------
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        IMPORTANT NOTE: Current GPS location cannot be determined under the iOS Simulator
        on your laptop or desktop computer because those computers do NOT have a GPS antenna.
        Therefore, do NOT expect the code herein to work under the iOS Simulator!
        
        You must deploy your location-aware app to an iOS device to be able to test it properly.
        
        To develop a location-aware app:
        
        (1) Link to CoreLocation.framework in your Xcode project
        (2) Include "import CoreLocation" to use its classes.
        (3) Study documentation on CLLocation, CLLocationManager, and CLLocationManagerDelegate
        */
        
        /*
        The user can turn off location services on an iOS device in Settings.
        First, you must check to see of it is turned off or not.
        */
        
        if !CLLocationManager.locationServicesEnabled() {
            
            /*
            Create a UIAlertController object; dress it up with title, message, and preferred style;
            and store its object reference into local constant alertController
            */
            let alertController = UIAlertController(title: "Location Services Disabled!",
                message: "Turn Location Services On in your device settings to be able to use location services!",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            // Create a UIAlertAction object and add it to the alert controller
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            // Present the alert controller by calling the presentViewController method
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        /*
        Monitoring the user's current location is a serious privacy issue!
        You are required to get the user's permission in two ways:
        
        (1) requestWhenInUseAuthorization:
        (a) Ask your locationManager to request user's authorization while the app is being used.
        (b) Add a new row in the Info.plist file for NSLocationWhenInUseUsageDescription, for which you specify, e.g.,
        "VTQuest requires monitoring your location only when you are using the app!"
        
        (2) requestAlwaysAuthorization:
        (a) Ask your locationManager to request user's authorization even when the app is not being used.
        (b) Add a new row in the Info.plist file for NSLocationAlwaysUsageDescription, for which you specify, e.g.,
        "VTQuest requires monitoring your location even when you are not using your app!"
        
        You select and use only one of these two options depending on your app's requirement.
        */
        
        // We will use Option 1: Request user's authorization while the app is being used.
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied {
            userAuthorizedLocationMonitoring = false
        } else {
            userAuthorizedLocationMonitoring = true
        }
        
        // Obtain the absolute file path to the maps.html file in the main bundle
        mapsHtmlFilePath = NSBundle.mainBundle().pathForResource("maps", ofType: "html")
        
        // Set Roadmap as the default map type
        mapTypeSegmentedControl.selectedSegmentIndex = 0
    }
    
    /*
    ------------------------
    MARK: - IBAction Methods
    ------------------------
    */
    @IBAction func keyboardDone(sender: UITextField) {
        
        // Deactivate the Address Text Field object and remove the Keyboard
        sender.resignFirstResponder()
    }
    
    @IBAction func backgroundTouch(sender: UIControl) {
        
        // Deactivate the Address Text Field object and remove the Keyboard
        addressTextField.resignFirstResponder()
    }
    
    // This method is invoked when the user taps the "Show the Address on Map" button
    @IBAction func showAddressOnMap(sender: UIButton) {
        
        addressEnteredToShowOnMap = addressTextField.text!
        
        // If no address is entered, alert the user
        if addressEnteredToShowOnMap.isEmpty {
            
            /*
            Create a UIAlertController object; dress it up with title, message, and preferred style;
            and store its object reference into local constant alertController
            */
            let alertController = UIAlertController(title: "Address Missing!",
                message: "Please enter an address to show on map!",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            // Create a UIAlertAction object and add it to the alert controller
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            // Present the alert controller by calling the presentViewController method
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        // A Google map query parameter cannot have spaces. Therefore, replace each space with +
        let addressToShowOnMap = addressEnteredToShowOnMap.stringByReplacingOccurrencesOfString(" ", withString: "+", options: [], range: nil)
        
        switch mapTypeSegmentedControl.selectedSegmentIndex {
            
        case 0:   // Roadmap map type selected
            googleMapQuery = mapsHtmlFilePath! + "?place=\(addressToShowOnMap)&maptype=ROADMAP&zoom=16"
            
        case 1:   // Satellite map type selected
            googleMapQuery = mapsHtmlFilePath! + "?place=\(addressToShowOnMap)&maptype=SATELLITE&zoom=16"
            
        case 2:   // Hybrid map type selected
            googleMapQuery = mapsHtmlFilePath! + "?place=\(addressToShowOnMap)&maptype=HYBRID&zoom=16"
            
        case 3:   // Terrain map type selected
            googleMapQuery = mapsHtmlFilePath! + "?place=\(addressToShowOnMap)&maptype=TERRAIN&zoom=16"
            
        default:
            
            /*
            Create a UIAlertController object; dress it up with title, message, and preferred style;
            and store its object reference into local constant alertController
            */
            let alertController = UIAlertController(title: "Map Type Unselected!",
                message: "Please select a map type to show the address!",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            // Create a UIAlertAction object and add it to the alert controller
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            // Present the alert controller by calling the presentViewController method
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        // Perform the segue named Address
        performSegueWithIdentifier("Address", sender: self)
    }
    
    // This method is invoked when the user taps the "Show my Current Location on Map" button
    @IBAction func showCurrentLocationOnMap(sender: UIButton) {
        
        if !userAuthorizedLocationMonitoring {
            
            // User does not authorize location monitoring
            
            /*
            Create a UIAlertController object; dress it up with title, message, and preferred style;
            and store its object reference into local constant alertController
            */
            let alertController = UIAlertController(title: "Authorization Denied!",
                message: "Unable to determine current location!",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            // Create a UIAlertAction object and add it to the alert controller
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            // Present the alert controller by calling the presentViewController method
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        // Set the current view controller to be the delegate of the location manager object
        locationManager.delegate = self
        
        // Set the location manager's distance filter to kCLDistanceFilterNone implying that
        // a location update will be sent regardless of movement of the device
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        // Set the location manager's desired accuracy to be the best
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Start the generation of updates that report the user’s current location.
        // Implement the CLLocationManager Delegate Methods below to receive and process the location info.
        
        locationManager.startUpdatingLocation()
    }
    
    /*
    ------------------------------------------
    MARK: - CLLocationManager Delegate Methods
    ------------------------------------------
    */
    // Tells the delegate that a new location data is available
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        /*
        The objects in the given locations array are ordered with respect to their occurrence times.
        Therefore, the most recent location update is at the end of the array; hence, we access the last object.
        */
        let lastObjectAtIndex = locations.count - 1
        let currentLocation: CLLocation = locations[lastObjectAtIndex] as CLLocation
        
        // Obtain current location's latitude in degrees
        let latitudeValue = currentLocation.coordinate.latitude
        
        // Obtain current location's longitude in degrees
        let longitudeValue = currentLocation.coordinate.longitude
        
        // Stops the generation of location updates since we do not need it anymore
        manager.stopUpdatingLocation()
        
        switch mapTypeSegmentedControl.selectedSegmentIndex {
            
        case 0:   // Roadmap map type selected
            googleMapQuery = mapsHtmlFilePath! + "?n=Current+Location&lat=\(latitudeValue)&lng=\(longitudeValue)&maptype=ROADMAP&zoom=16"
            
        case 1:   // Satellite map type selected
            googleMapQuery = mapsHtmlFilePath! + "?n=Current+Location&lat=\(latitudeValue)&lng=\(longitudeValue)&maptype=SATELLITE&zoom=16"
            
        case 2:   // Hybrid map type selected
            googleMapQuery = mapsHtmlFilePath! + "?n=Current+Location&lat=\(latitudeValue)&lng=\(longitudeValue)&maptype=HYBRID&zoom=16"
            
        case 3:   // Terrain map type selected
            googleMapQuery = mapsHtmlFilePath! + "?n=Current+Location&lat=\(latitudeValue)&lng=\(longitudeValue)&maptype=TERRAIN&zoom=16"
            
        default:
            
            /*
            Create a UIAlertController object; dress it up with title, message, and preferred style;
            and store its object reference into local constant alertController
            */
            let alertController = UIAlertController(title: "Map Type Unselected!",
                message: "Please select a map type to show the address!",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            // Create a UIAlertAction object and add it to the alert controller
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            // Present the alert controller by calling the presentViewController method
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        addressEnteredToShowOnMap = "Current Location"
        
        // Perform the segue named Address
        performSegueWithIdentifier("Address", sender: self)
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        // Stops the generation of location updates since error occurred
        manager.stopUpdatingLocation()
        
        /*
        Create a UIAlertController object; dress it up with title, message, and preferred style;
        and store its object reference into local constant alertController
        */
        let alertController = UIAlertController(title: "Unable to Locate!",
            message: "An error occurred while trying to determine your location: \(error.localizedDescription)",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        // Present the alert controller by calling the presentViewController method
        presentViewController(alertController, animated: true, completion: nil)
        
        return
    }
    
    /*
    -------------------------
    MARK: - Prepare for Segue
    -------------------------
    */
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "Address" {
            
            // Obtain the object reference of the destination (downstream) view controller
            let addressMapViewController: AddressMapViewController = segue.destinationViewController as! AddressMapViewController
            
            dataObjectToPass[0] = googleMapQuery
            dataObjectToPass[1] = addressEnteredToShowOnMap
            
            /*
            This view controller creates the dataObjectToPass and passes it (by value) to the downstream view controller
            AddressMapViewController by copying its content into AddressMapViewController's property dataObjectPassed.
            */
            addressMapViewController.dataObjectPassed = dataObjectToPass
        }
    }
    
}