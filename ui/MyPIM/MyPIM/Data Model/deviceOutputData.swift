//
//  deviceOutputData.swift
//  MyPIM
//
//  Created by Boyan Tian on 12/1/21.
//


import Foundation
import SwiftUI
import CoreLocation
import AVFoundation

// Global array of AlbumPhoto structs
var deviceStructList = [Device]()

/*
 *********************************
 MARK: - Read Movies Data Files
 *********************************
 */
public func readDevicesDataFiles() {
    let notesDataFullFilename = "aiOutput.json"
   
    // Obtain URL of the MoviesData.json file in document directory on the user's device
    // Global constant documentDirectory is defined in UtilityFunctions.swift
    let urlOfJsonFileInDocumentDirectory = documentDirectory.appendingPathComponent(notesDataFullFilename)
 
    do {
        /*
         Try to get the contents of the file. The left hand side is
         suppressed by using '_' since we do not use it at this time.
         Our purpose is just to check to see if the file is there or not.
         */
 
        _ = try Data(contentsOf: urlOfJsonFileInDocumentDirectory)
       
        /*
         If 'try' is successful, it means that the MoviesData.json
         file exists in document directory on the user's device.
         ---
         If 'try' is unsuccessful, it throws an exception and
         executes the code under 'catch' below.
         */

       
        /*
         --------------------------------------------------
         |   The app is being launched after first time   |
         --------------------------------------------------
         The MoviesData.json file exists in document directory on the user's device.
         Load it from Document Directory into movieStructList.
         */
       
        // The function is given in UtilityFunctions.swift
        deviceStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: notesDataFullFilename, fileLocation: "Document Directory")
        print("MoviesData is loaded from document directory")
       
    } catch {
        /*
         ----------------------------------------------------
         |   The app is being launched for the first time   |
         ----------------------------------------------------
         The MoviesData.json file does not exist in document directory on the user's device.
         Load it from main bundle (project folder) into movieStructList.
        
         This catch section will be executed only once when the app is launched for the first time
         since we write and read the files in document directory on the user's device after first use.
         */
       
        // The function is given in UtilityFunctions.swift
        deviceStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: notesDataFullFilename, fileLocation: "Main Bundle")
        print("MoviesData is loaded from main bundle")
    }   // End of do-catch
}
