//
//  VTPlacesTableViewController.swift
//  VTQuest
//
//  Created by Andrew Mogg on 10/20/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//

import UIKit

class VTPlacesTableViewController: UITableViewController {
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // A dictionary with Key = letter, Value = an array of VT place names starting with that letter
    var dict_Letter_ArrayOfPlaceNames  = [String: AnyObject]()
    
    // An object reference pointing to an array containing the starting letters of VT place names
    var firstLettersOfVTPlaceNames = [String]()
    
    /*
    dataObjectToPass is the data object to pass to the downstream view controller.
    Create the array to hold 6 string values as specified from index 0 to 5
    
    NOTE: To store values in an array using its index, you must create the array with the
    number of index values to be used. Below, we specify which index will have which value.
    Creating the array this way significantly increases the understandanbility of the code.
    Of course, these descriptors will be replaced with actual values later when we populate the array.
    */
    var dataObjectToPass: [String] = ["abbreviation", "category", "description", "imageURL", "location", "building name"]
    
    /*
    -----------------------
    MARK: - View Life Cycle
    -----------------------
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*----------------------------------------------------------------------------------------
        Objective: We want to identify the first letters with which the VT place names start.
        We will list the letters as an index in the table view so that the user
        can select a letter to jump to the names starting with that letter.
        
        Create a changeable Dictionary with the following key-value pairs:
        KEY   = Alphabet letter from A to Z
        VALUE = Obj ref of an Array containing the VT place names that start with the letter = KEY
        ----------------------------------------------------------------------------------------*/
        
        // Obtain the name of the first VT place from the global data
        let firstVTPlaceName = applicationDelegate.vtPlaceNames[0]
        
        // Create an array with its first value being firstVTPlaceName
        var placeNamesForLetter = [String]()
        placeNamesForLetter.append(firstVTPlaceName)
        
        // Instantiate a character string object containing the letter A
        // and store its object reference into the local variable previousLetter
        var previousFirstLetter: Character = "A"
        
        // Store the number of VT place names into local variable noOfPlaces
        let noOfPlaces = applicationDelegate.vtPlaceNames.count
        
        // Since we already stored the first VT place name at index 0, we start index j with 1
        for (var j = 1; j < noOfPlaces; j++) {
            
            // Obtain the jth VT place name
            let placeName = applicationDelegate.vtPlaceNames[j]
            
            // Obtain the first character of the VT place name. An easy way of doing this:
            // Convert the placeName string into an array of characters and select the one at index 0.
            let currentFirstLetter: Character = Array(placeName.characters)[0]
            
            if currentFirstLetter == previousFirstLetter {
                
                placeNamesForLetter.append(placeName)
                
            } else {
                // Add array of VT place names starting with previousFirstLetter to the dictionary
                dict_Letter_ArrayOfPlaceNames[String(previousFirstLetter)] = placeNamesForLetter
                
                previousFirstLetter = currentFirstLetter
                
                // Empty the placeNamesForLetter array
                placeNamesForLetter.removeAll(keepCapacity: false)
                
                // Set the value at index 0 to placeName
                placeNamesForLetter.append(placeName)
            }
        }
        
        // Add array of VT place names starting with previousFirstLetter to the dictionary
        dict_Letter_ArrayOfPlaceNames[String(previousFirstLetter)] = placeNamesForLetter
        
        // Obtain the index letters to diplay for the user to select one to jump to its section
        firstLettersOfVTPlaceNames  = Array(dict_Letter_ArrayOfPlaceNames.keys)
        
        // Sort the index letters within itself in alphabetical order
        firstLettersOfVTPlaceNames.sortInPlace { $0 < $1 }
    }
    
    /*
    ------------------------------------------------
    MARK: - UITableView Data Source Protocol Methods
    ------------------------------------------------
    */
    
    // We are implementing a Grouped table view style at runtime
    
    //---------------------------------------
    // Return Number of Sections in Table View
    //---------------------------------------
    
    // Asks the data source to return the number of sections in the table view
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        // number of table sections = number of letters
        return firstLettersOfVTPlaceNames.count
    }
    
    //--------------------------------
    // Return Number of Rows in Section
    //--------------------------------
    
    // Number of rows in a given section (index letter) = Number of VT place names starting with that letter
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Obtain the index letter for the given section number
        let indexLetter = firstLettersOfVTPlaceNames[section]
        
        // Obtain the object reference to the array containing the place names starting with that index letter
        let arrayOfPlaceNames: AnyObject? = dict_Letter_ArrayOfPlaceNames[indexLetter]
        
        // Unwrap and typecast the object pointed to by arrayOfPlaceNames as an array of String values
        let listOfPlaceNames = arrayOfPlaceNames! as! [String]
        
        // Number of place names starting with the index letter = Number of rows in that index letter section
        return listOfPlaceNames.count
    }
    
    //----------------------------
    // Set Title for Section Header
    //----------------------------
    
    // Asks the data source to return the section title for a given section number
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        
        return firstLettersOfVTPlaceNames[section]
    }
    
    //-------------------------------------
    // Prepare and Return a Table View Cell
    //-------------------------------------
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("VTPlaces", forIndexPath: indexPath) as UITableViewCell
        
        let sectionNumber = indexPath.section
        let rowNumber = indexPath.row
        
        // Create and initialize a dictionary
        var dict_vtPlaceAttribute_vtPlaceValue = [String: String]()
        
        // Obtain the index letter for the given section number
        let indexLetter = firstLettersOfVTPlaceNames[sectionNumber]
        
        // Obtain the object reference to the array containing the place names starting with that index letter
        let arrayOfPlaceNames: AnyObject? = dict_Letter_ArrayOfPlaceNames[indexLetter]
        
        // Unwrap and typecast the object pointed to by arrayOfPlaceNames as an array of String values
        var listOfPlaceNames = arrayOfPlaceNames! as! [String]
        
        // Obtain the place name at the row number
        let selectedPlaceName = listOfPlaceNames[rowNumber]
        
        // Set the cell title to be the selected place name
        cell.textLabel!.text = selectedPlaceName
        
        // Set the cell image to VT logo
        cell.imageView!.image = UIImage(named: "vtLogo.png")
        
        // Obtain the object reference to AnyObject for the selected place name
        let aDictionary: AnyObject? = applicationDelegate.dict_vtPlaceName_Dict[selectedPlaceName]
        
        // Typecast the object pointed to by aDictionary as a Dictionary
        dict_vtPlaceAttribute_vtPlaceValue = aDictionary! as! Dictionary
        
        // Obtain the value for the category for the selected place name
        let vtPlaceCategory = dict_vtPlaceAttribute_vtPlaceValue["category"]
        
        // Set table view cell (row) subtitle to VT place category
        // Select Subtitle from the table view cell Style menu in Storyboard for this to work
        cell.detailTextLabel?.text = vtPlaceCategory
        
        return cell
    }
    
    //----------------------------
    // Return Section Index Titles
    //----------------------------
    
    /*
    Asks the data source to return all of the section titles, i.e., letters from A to Z to display them as an
    index on the right side of the table view so that the user can tap on a letter to jump to its section.
    */
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        
        return firstLettersOfVTPlaceNames
    }
    
    /*
    --------------------------------------------
    MARK: - UITableView Delegate Protocol Method
    --------------------------------------------
    */
    
    //---------------------------------------------
    // Selection of a VT Place (Building) Name (Row)
    //---------------------------------------------
    
    // Tapping a row, VT Place (Building) Name, displays information about that place (building)
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let sectionNumber = indexPath.section
        let rowNumber = indexPath.row
        
        // Obtain the index letter for the given section number
        let indexLetter = firstLettersOfVTPlaceNames[sectionNumber]
        
        // Obtain the object reference to the array containing the place names starting with the index letter
        let arrayOfPlaceNames: AnyObject? = dict_Letter_ArrayOfPlaceNames[indexLetter]
        
        // Unwrap and typecast the object pointed to by arrayOfPlaceNames as an array of String values
        var listOfPlaceNames = arrayOfPlaceNames! as! [String]
        
        // Obtain the place name at the row number
        let selectedPlaceName = listOfPlaceNames[rowNumber]
        
        // Obtain the object reference to AnyObject for the selected place name
        let placeDictionary: AnyObject? = applicationDelegate.dict_vtPlaceName_Dict[selectedPlaceName]
        
        // Typecast the object pointed to by placeDictionary as Dictionary
        var dict_vtPlaceAttribute_vtPlaceValue: [String: String] = placeDictionary! as! Dictionary
        
        // Prepare the data object to pass to the downstream view controller
        dataObjectToPass[0] = dict_vtPlaceAttribute_vtPlaceValue["abbreviation"]!
        dataObjectToPass[1] = dict_vtPlaceAttribute_vtPlaceValue["category"]!
        dataObjectToPass[2] = dict_vtPlaceAttribute_vtPlaceValue["description"]!
        dataObjectToPass[3] = dict_vtPlaceAttribute_vtPlaceValue["image"]!
        dataObjectToPass[4] = dict_vtPlaceAttribute_vtPlaceValue["location"]!
        dataObjectToPass[5] = selectedPlaceName
        
        // Perform the segue named vtPlaceInfo
        performSegueWithIdentifier("vtPlaceInfo", sender: self)
    }
    
    /*
    -------------------------
    MARK: - Prepare for Segue
    -------------------------
    */
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "vtPlaceInfo" {
            
            // Obtain the object reference of the destination (downstream) view controller
            let vtPlaceInfoViewController: VTPlaceInfoViewController = segue.destinationViewController as! VTPlaceInfoViewController
            
            /*
            This view controller creates the dataObjectToPass and passes it (by value) to the downstream view controller
            VTPlaceInfoViewController by copying its content into VTPlaceInfoViewController's property dataObjectPassed.
            */
            vtPlaceInfoViewController.dataObjectPassed = dataObjectToPass
        }
    }
    
}