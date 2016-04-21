//
//  VtDirectionsViewController.swift
//  VTQuest
//
//  Created by Andrew Mogg on 10/22/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//
import UIKit

class VTDirectionsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var setFromLabel: UILabel!
    @IBOutlet var setToLabel: UILabel!
    @IBOutlet var directionsTypeSegmentedControl: UISegmentedControl!
    
    // Declare a property to contain the absolute file path for the maps.html file
    var mapsHtmlFilePath: String?
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    /*
    dataObjectToPass is the data object to pass to the downstream view controller (i.e., VTPlaceOnMapViewController)
    Create the array to hold 2 string values as specified at index 0 and 1.
    
    NOTE: To store values in an array using its index, you must create the array with the number of index values to be used.
    */
    var dataObjectToPass: [String] = ["googleMapQuery", "directionsType"]
    
    var fromPlaceSelected = ""
    var toPlaceSelected = ""
    
    var viewShownFirstTime = true
    
    /*
    -----------------------
    MARK: - View Life Cycle
    -----------------------
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Obtain the absolute file path to the maps.html file in the main bundle
        mapsHtmlFilePath = NSBundle.mainBundle().pathForResource("maps", ofType: "html")
        
        /*
        println("mapsHtmlFilePath = \(mapsHtmlFilePath)")
        
        This prints the following as the *** absolute path *** to the maps.html file.
        
        mapsHtmlFilePath = Optional("/Users/Balci/Library/Developer/CoreSimulator/Devices/230B3A00-3615-486F-A925-D601DB35F0FC/
        data/Containers/Bundle/Application/1BBEB6E1-FA8A-4179-BA6E-E85CC355679F/VTQuest.app/maps.html")
        */
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Obtain the number of the row in the middle of the VT place names list
        let numberOfVTPlaces = applicationDelegate.vtPlaceNames.count
        let numberOfRowToShow = Int(numberOfVTPlaces / 2)
        
        // Show the picker view of VT place names from the middle
        pickerView.selectRow(numberOfRowToShow, inComponent: 0, animated: false)
        
        // Deselect the earlier selected directions type
        directionsTypeSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
        
        if viewShownFirstTime {
            viewShownFirstTime = false
            // Do not clear "Selected VT place FROM" and "Selected VT place TO"
        } else {
            // Clear the earlier selections
            setFromLabel.text = ""
            setToLabel.text = ""
        }
    }
    
    /*
    ------------------------
    MARK: - IBAction Methods
    ------------------------
    */
    
    @IBAction func setFromButtonTapped(sender: UIButton) {
        
        let selectedRowNumber = pickerView.selectedRowInComponent(0)
        
        fromPlaceSelected = applicationDelegate.vtPlaceNames[selectedRowNumber]
        
        setFromLabel.text = fromPlaceSelected
    }
    
    @IBAction func setToButtonTapped(sender: UIButton) {
        
        let selectedRowNumber = pickerView.selectedRowInComponent(0)
        
        toPlaceSelected = applicationDelegate.vtPlaceNames[selectedRowNumber]
        
        setToLabel.text = toPlaceSelected
    }
    
    @IBAction func clearButtonTapped(sender: UIButton) {
        
        setFromLabel.text = ""
        setToLabel.text = ""
    }
    
    @IBAction func getDirectionsOnCampus(sender: UISegmentedControl) {
        
        // If the starting and/or destination VT place name is not selected, alert the user
        
        if setFromLabel.text == "" || setToLabel.text == "" ||
            setFromLabel.text == "Selected VT place FROM" ||
            setToLabel.text == "Selected VT place TO" {
                
                // Deselect the earlier selected directions type
                directionsTypeSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
                
                /*
                Create a UIAlertController object; dress it up with title, message, and preferred style;
                and store its object reference into local constant alertController
                */
                let alertController = UIAlertController(title: "Selection Missing!",
                    message: "Please select both From and To places for directions!",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                // Create a UIAlertAction object and add it to the alert controller
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                // Present the alert controller by calling the presentViewController method
                presentViewController(alertController, animated: true, completion: nil)
                
                return
        }
        
        //----------------------------------------------------------------------------------
        // Obtain the GPS coordinates (latitude,longitude) for the VT place selected as FROM
        //----------------------------------------------------------------------------------
        
        // Obtain the object reference to AnyObject for the VT place name selected as From
        var placeDictionary: AnyObject? = applicationDelegate.dict_vtPlaceName_Dict[fromPlaceSelected]
        
        // Typecast the object pointed to by placeDictionary as Dictionary
        var dict_vtPlaceAttribute_vtPlaceValue: [String: String] = placeDictionary! as! Dictionary
        
        // Obtain the "latitude,longitude" from the dictionary under the key "location"
        let placeFromCoordinates = dict_vtPlaceAttribute_vtPlaceValue["location"]!
        
        //----------------------------------------------------------------------------------
        // Obtain the GPS coordinates (latitude,longitude) for the VT place selected as TO
        //----------------------------------------------------------------------------------
        
        // Obtain the object reference to AnyObject for the VT place name selected as To
        placeDictionary = applicationDelegate.dict_vtPlaceName_Dict[toPlaceSelected]
        
        // Typecast the object pointed to by placeDictionary as Dictionary
        dict_vtPlaceAttribute_vtPlaceValue = placeDictionary! as! Dictionary
        
        // Obtain the "latitude,longitude" from the dictionary under the key "location"
        let placeToCoordinates = dict_vtPlaceAttribute_vtPlaceValue["location"]!
        
        // Obtain the absolute file path to the maps.html file in the main bundle
        mapsHtmlFilePath = NSBundle.mainBundle().pathForResource("maps", ofType: "html")
        
        
        var googleMapQuery: String = ""
        var directionsType: String = ""
        
        switch sender.selectedSegmentIndex {
            
        case 0:
            googleMapQuery = mapsHtmlFilePath! + "?start=\(placeFromCoordinates)&end=\(placeToCoordinates)&traveltype=DRIVING"
            directionsType = "Driving"
            
        case 1:
            googleMapQuery = mapsHtmlFilePath! + "?start=\(placeFromCoordinates)&end=\(placeToCoordinates)&traveltype=WALKING"
            directionsType = "Walking"
            
        case 2:
            googleMapQuery = mapsHtmlFilePath! + "?start=\(placeFromCoordinates)&end=\(placeToCoordinates)&traveltype=BICYCLING"
            directionsType = "Bicycling"
            
        case 3:
            googleMapQuery = mapsHtmlFilePath! + "?start=\(placeFromCoordinates)&end=\(placeToCoordinates)&traveltype=TRANSIT"
            directionsType = "Transit"
            
        default:
            return
        }
        
        // Prepare the data object to pass to the downstream view controller
        dataObjectToPass[0] = googleMapQuery
        dataObjectToPass[1] = directionsType
        
        // Perform the segue named CampusDirections
        performSegueWithIdentifier("CampusDirections", sender: self)
    }
    
    /*
    -------------------------
    MARK: - Prepare for Segue
    -------------------------
    */
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "CampusDirections" {
            
            // Obtain the object reference of the destination (downstream) view controller
            let vtDirectionsMapViewController: VTDirectionsMapViewController = segue.destinationViewController as! VTDirectionsMapViewController
            
            /*
            This view controller creates the dataObjectToPass and passes it (by value) to the downstream view controller
            VTDirectionsMapViewController by copying its content into VTDirectionsMapViewController's property dataObjectPassed.
            */
            vtDirectionsMapViewController.dataObjectPassed = dataObjectToPass
        }
    }
    
    /*
    ----------------------------------------
    MARK: - UIPickerView Data Source Methods
    ----------------------------------------
    */
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return applicationDelegate.vtPlaceNames.count
    }
    
    /*
    ------------------------------------
    MARK: - UIPickerView Delegate Method
    ------------------------------------
    */
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return applicationDelegate.vtPlaceNames[row]
    }
    
}