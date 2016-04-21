//
//  VTPlaceInfoViewController.swift
//  VTQuest
//
//  Created by Andrew Mogg on 10/20/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//


import UIKit

class VTPlaceInfoViewController: UIViewController {
    
    // Object references to the UI objects instantiated in the Storyboard
    @IBOutlet var buildingName:             UILabel!
    @IBOutlet var imageView:                UIImageView!
    @IBOutlet var buildingCodeName:         UILabel!
    @IBOutlet var buildingCategoryName:     UILabel!
    @IBOutlet var buildingDescription:      UITextView!
    @IBOutlet var mapTypeSegmentedControl:  UISegmentedControl!
    
    // Declare a property to contain the absolute file path for the maps.html file
    var mapsHtmlFilePath: String?
    
    /*
    The upstream view controller VTPlacesTableViewController creates the dataObjectToPass
    and passes it to this view controller by copying its content into dataObjectPassed.
    */
    var dataObjectPassed = [String]()
    
    /*
    dataObjectToPass is the data object to pass to the downstream view controller (i.e., VTPlaceOnMapViewController)
    Create the array to hold 2 string values as specified at index 0 and 1.
    
    NOTE: To store values in an array using its index, you must create the array with the number of index values to be used.
    */
    var dataObjectToPass: [String] = ["googleMapQuery", "placeName"]
    
    /*
    -----------------------
    MARK: - View Life Cycle
    -----------------------
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // print(dataObjectPassed)
        
        buildingCodeName.text = dataObjectPassed[0]
        
        buildingCategoryName.text = dataObjectPassed[1]
        
        buildingDescription.text = dataObjectPassed[2]
        
        buildingName.text = dataObjectPassed[5]
        
        let imageURL: String = dataObjectPassed[3]
        
        let url = NSURL(string: imageURL)
        
        var errorInReadingImageData: NSError?
        
        var imageData: NSData?
        
        do {
            imageData = try NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            
        } catch let error as NSError {
            
            errorInReadingImageData = error
            imageData = nil
        }
        
        if let vtBuildingImage = imageData {
            
            imageView.image = UIImage(data: vtBuildingImage)
            
        } else {
            if errorInReadingImageData != nil {
                // println("Error in reading VT building photo image: \(errorInReadingImageData!.localizedDescription)")
                // Since we know that some buildings do not have images and this error will occur, we will take the action below.
            }
            // If there is no photo available for the building, display the image named imageUnavailable.png
            imageView.image = UIImage(named: "imageUnavailable.png")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Set the segmented control to show no selection before the view appears
        mapTypeSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
    }
    
    /*
    --------------------
    MARK: - Set Map Type
    --------------------
    */
    // This method is invoked when the user selects a map type to display
    @IBAction func setMapType(sender: UISegmentedControl) {
        
        let placeCoordinates = dataObjectPassed[4]
        let placeName = dataObjectPassed[5]
        
        // A Google map query parameter cannot have spaces. Therefore, replace each space with +
        let placeNameWithNoSpaces = placeName.stringByReplacingOccurrencesOfString(" ", withString: "+", options: [], range: nil)
        
        // Obtain the absolute file path to the maps.html file in the main bundle
        mapsHtmlFilePath = NSBundle.mainBundle().pathForResource("maps", ofType: "html")
        
        // Extract latitude and longitude from the string value and place them in an array
        var latitudeLongitude: Array = placeCoordinates.componentsSeparatedByString(",")
        
        let latitude    = latitudeLongitude[0]
        let longitude   = latitudeLongitude[1]
        
        var googleMapQuery: String = ""
        
        switch sender.selectedSegmentIndex {
            
        case 0:   // Roadmap map type selected
            googleMapQuery = mapsHtmlFilePath! + "?n=\(placeNameWithNoSpaces)&lat=\(latitude)&lng=\(longitude)&zoom=16&maptype=ROADMAP"
            
        case 1:   // Satellite map type selected
            googleMapQuery = mapsHtmlFilePath! + "?n=\(placeNameWithNoSpaces)&lat=\(latitude)&lng=\(longitude)&zoom=16&maptype=SATELLITE"
            
        case 2:   // Hybrid map type selected
            googleMapQuery = mapsHtmlFilePath! + "?n=\(placeNameWithNoSpaces)&lat=\(latitude)&lng=\(longitude)&zoom=16&maptype=HYBRID"
            
        case 3:   // Terrain map type selected
            googleMapQuery = mapsHtmlFilePath! + "?n=\(placeNameWithNoSpaces)&lat=\(latitude)&lng=\(longitude)&zoom=16&maptype=TERRAIN"
            
        default:
            return
        }
        
        // Prepare the data object to pass to the downstream view controller
        dataObjectToPass[0] = googleMapQuery
        dataObjectToPass[1] = placeName
        
        // Perform the segue named vtPlaceOnMap
        performSegueWithIdentifier("vtPlaceOnMap", sender: self)
    }
    
    /*
    -------------------------
    MARK: - Prepare for Segue
    -------------------------
    */
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "vtPlaceOnMap" {
            
            // Obtain the object reference of the destination (downstream) view controller
            let vtPlaceOnMapViewController: VTPlaceOnMapViewController = segue.destinationViewController as! VTPlaceOnMapViewController
            
            /*
            This view controller creates the dataObjectToPass and passes it (by value) to the downstream view controller
            VTPlaceOnMapViewController by copying its content into VTPlaceOnMapViewController's property dataObjectPassed.
            */
            vtPlaceOnMapViewController.dataObjectPassed = dataObjectToPass
        }
    }
    
}