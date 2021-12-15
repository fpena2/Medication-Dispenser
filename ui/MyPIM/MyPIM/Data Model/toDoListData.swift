//
//  toDoListData.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/21/20.
//

import Foundation
import SwiftUI

var toDoStructList = [toDo]()

var orderedToDosList = [String]()

var titleOrderedToDoList = [toDo]()
var dueOrderedToDoList = [toDo]()
var priorityOrderedToDoList = [toDo]()

 
 
/*
 *********************************
 MARK: - Read TODOLIST Data Files
 *********************************
 */
public func readToDoListDataFiles() {
   
    var documentDirectoryHasFiles = false
    let toDosDataFullFilename = "ToDoListData.json"
   
    // Obtain URL of the CountriesData.json file in document directory on the user's device
    // Global constant documentDirectory is defined in UtilityFunctions.swift
    let urlOfJsonFileInDocumentDirectory = documentDirectory.appendingPathComponent(toDosDataFullFilename)
 
    do {
        /*
         Try to get the contents of the file. The left hand side is
         suppressed by using '_' since we do not use it at this time.
         Our purpose is just to check to see if the file is there or not.
         */
 
        _ = try Data(contentsOf: urlOfJsonFileInDocumentDirectory)
       
        /*
         If 'try' is successful, it means that the CountriesData.json
         file exists in document directory on the user's device.
         ---
         If 'try' is unsuccessful, it throws an exception and
         executes the code under 'catch' below.
         */
       
        documentDirectoryHasFiles = true
       
        /*
         --------------------------------------------------
         |   The app is being launched after first time   |
         --------------------------------------------------
         The CountriesData.json file exists in document directory on the user's device.
         Load it from Document Directory into movieReviewStructList.
         */
       
        // The function is given in UtilityFunctions.swift
        toDoStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: toDosDataFullFilename, fileLocation: "Document Directory")
        print("toDoStructList is loaded from document directory")
       
    } catch {
        documentDirectoryHasFiles = false
       
        /*
         ----------------------------------------------------
         |   The app is being launched for the first time   |
         ----------------------------------------------------
         The CountriesData.json file does not exist in document directory on the user's device.
         Load it from main bundle (project folder) into movieReviewStructList.
        
         This catch section will be executed only once when the app is launched for the first time
         since we write and read the files in document directory on the user's device after first use.
         */
       
        // The function is given in UtilityFunctions.swift
        toDoStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: toDosDataFullFilename, fileLocation: "Main Bundle")
        print("toDoStructList is loaded from main bundle")
       
        /*
         This list has two purposes:
        
            (1) preserve the order of countries according to user's liking, and
            (2) enable search of selected country attributes by the SearchBar in FavoritesList.
        
         Each list element consists of "id|name|alpha2code|capital|languages|currency".
         We chose these attributes separated by vertical lines to be included in the search.
         We separate them with "|" so that we can extract its components separately.
         For example, to obtain the id: list item.components(separatedBy: "|")[0]
         */
        for todo in toDoStructList {
            let selectedToDoAttributesForSearch = "\(todo.id)|\(todo.title)|\(todo.description)|\(todo.priority)|\(todo.completed)|\(todo.dueDateAndTime)"
           
            orderedToDosList.append(selectedToDoAttributesForSearch)
        }
       
    }   // End of do-catch
   
    /*
    ----------------------------------------
    Read orderedToDosList File
    ----------------------------------------
    */
    if documentDirectoryHasFiles {
        // Obtain URL of the file in document directory on the user's device
        let urlOfFileInDocDir = documentDirectory.appendingPathComponent("orderedToDosList")
       
        // Instantiate an NSArray object and initialize it with the contents of the file
        let arrayFromFile: NSArray? = NSArray(contentsOf: urlOfFileInDocDir)
       
        if let arrayObtained = arrayFromFile {
            // Store the unique id of the created array into the global variable
            orderedToDosList = arrayObtained as! [String]
        } else {
            print("orderedToDosList file is not found in document directory on the user's device!")
        }
    }
}
 
/*
 ********************************************************
 MARK: - Write TODOLIST Data Files to Document Directory
 ********************************************************
 */
public func writeReviewsDataFiles() {
    /*
    --------------------------------------------------------------------------
    Write movieReviewStructList into CountriesData.json file in Document Directory
    --------------------------------------------------------------------------
    */
   
    // Obtain URL of the JSON file into which data will be written
    let urlOfJsonFileInDocumentDirectory: URL = documentDirectory.appendingPathComponent("ToDoListData.json")
 
    // Encode movieReviewStructList into JSON and write it into the JSON file
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(toDoStructList) {
        do {
            try encoded.write(to: urlOfJsonFileInDocumentDirectory)
        } catch {
            fatalError("Unable to write encoded toDoStructList data to document directory!")
        }
    } else {
        fatalError("Unable to encode toDoStructList data!")
    }
   
    /*
    ------------------------------------------------------
    Write orderedSearchableMovieReviewsList into a file named
    orderedSearchableMovieReviewsList in Document Directory
    ------------------------------------------------------
    */
 

}


public func createSortedLists() {
    titleOrderedToDoList = toDoStructList.sorted(by: { $0.title < $1.title})
    
    dueOrderedToDoList = toDoStructList.sorted(by: { $0.dueDateAndTime < $1.dueDateAndTime})
    
    priorityOrderedToDoList = toDoStructList.sorted(by: { $0.priority < $1.priority})
}
