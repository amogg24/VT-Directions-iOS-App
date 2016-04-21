//
//  DirectionsViewController.swift
//  VTQuest
//
//  Created by Andrew Mogg on 10/22/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//

import UIKit

class DirectionsViewController: UIViewController {
    
    @IBOutlet var directionsTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet var fromAddressTextField: UITextField!
    
    @IBOutlet var toAddressTextField: UITextField!
    
    // Declare a property to contain the absolute file path for the maps.html file
    var mapsHtmlFilePath: String?
    
    var googleMapQuery = ""
    var directionsType = ""
    
    // dataObjectToPass is the data object to pass to the downstream view controller (i.e., DirectionsMapViewController)
    var dataObjectToPass: [String] = ["googleMapQuery", "directionsType"]
    
    /*
    -----------------------
    MARK: - View Life Cycle
    -----------------------
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Obtain the absolute file path to the maps.html file in the main bundle
        mapsHtmlFilePath = NSBundle.mainBundle().pathForResource("maps", ofType: "html")
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Deselect the earlier selected directions type
        directionsTypeSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
    }
    
    /*
    ------------------------
    MARK: - IBAction Methods
    ------------------------
    */
    // This method is invoked when the user taps Done on the keyboard
    @IBAction func keyboardDone(sender: UITextField) {
        
        // Deactivate the calling Text Field object and remove the Keyboard
        sender.resignFirstResponder()
    }
    
    // This method is invoked when the user taps anywhere on the background
    @IBAction func backgroundTouch(sender: UIControl) {
        
        // Deactivate the Text Field objects and remove the Keyboard
        fromAddressTextField.resignFirstResponder()
        toAddressTextField.resignFirstResponder()
    }
    
    // This method is invoked when the user selects a directions type to get such directions
    @IBAction func getDirectionsFromAddressToAddress(sender: UISegmentedControl) {
        
        // If no address is entered, alert the user
        if fromAddressTextField.text == "" || toAddressTextField.text == "" {
            
            // Deselect the selected directions type
            directionsTypeSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
            
            /*
            Create a UIAlertController object; dress it up with title, message, and preferred style;
            and store its object reference into local constant alertController
            */
            let alertController = UIAlertController(title: "Selection Missing!",
                message: "Please enter both From and To addresses for directions!",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            // Create a UIAlertAction object and add it to the alert controller
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            // Present the alert controller by calling the presentViewController method
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        // A Google map query parameter cannot have spaces. Therefore, replace each space with +
        let addressFrom = fromAddressTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "+", options: [], range: nil)
        let addressTo   = toAddressTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "+", options: [], range: nil)
        
        switch directionsTypeSegmentedControl.selectedSegmentIndex {
            
        case 0:
            googleMapQuery = mapsHtmlFilePath! + "?start=\(addressFrom)&end=\(addressTo)&traveltype=DRIVING"
            directionsType = "Driving"
            
        case 1:
            googleMapQuery = mapsHtmlFilePath! + "?start=\(addressFrom)&end=\(addressTo)&traveltype=WALKING"
            directionsType = "Walking"
            
        case 2:
            googleMapQuery = mapsHtmlFilePath! + "?start=\(addressFrom)&end=\(addressTo)&traveltype=BICYCLING"
            directionsType = "Bicycling"
            
        case 3:
            googleMapQuery = mapsHtmlFilePath! + "?start=\(addressFrom)&end=\(addressTo)&traveltype=TRANSIT"
            directionsType = "Transit"
            
        default:
            
            /*
            Create a UIAlertController object; dress it up with title, message, and preferred style;
            and store its object reference into local constant alertController
            */
            let alertController = UIAlertController(title: "Directions Type Unselected!",
                message: "Please select a directions type!",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            // Create a UIAlertAction object and add it to the alert controller
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            // Present the alert controller by calling the presentViewController method
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        // Perform the segue named Address
        performSegueWithIdentifier("Directions", sender: self)
    }
    
    /*
    -------------------------
    MARK: - Prepare for Segue
    -------------------------
    */
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "Directions" {
            
            // Obtain the object reference of the destination (downstream) view controller
            let directionsMapViewController: DirectionsMapViewController = segue.destinationViewController as! DirectionsMapViewController
            
            dataObjectToPass[0] = googleMapQuery
            dataObjectToPass[1] = directionsType
            
            /*
            This view controller creates the dataObjectToPass and passes it (by value) to the downstream view controller
            DirectionsMapViewController by copying its content into AddressMapViewController's property dataObjectPassed.
            */
            directionsMapViewController.dataObjectPassed = dataObjectToPass
        }
    }
    
}
