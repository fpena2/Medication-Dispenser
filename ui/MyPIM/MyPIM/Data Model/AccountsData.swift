//
//  AccountsData.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//

import Foundation
import SwiftUI
 
// Global array of Country structs
var accountStructList = [Account]()
 
 
/*
 *********************************
 MARK: - Read Accounts Data Files
 *********************************
 */
public func readAccountsDataFiles() {
   
    let accountsDataFullFilename = "AccountsData.json"
   
    // Obtain URL of the CountriesData.json file in document directory on the user's device
    // Global constant documentDirectory is defined in UtilityFunctions.swift
    let urlOfJsonFileInDocumentDirectory = documentDirectory.appendingPathComponent(accountsDataFullFilename)
 
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
       
        /*
         --------------------------------------------------
         |   The app is being launched after first time   |
         --------------------------------------------------
         The CountriesData.json file exists in document directory on the user's device.
         Load it from Document Directory into countryStructList.
         */
       
        // The function is given in UtilityFunctions.swift
        accountStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: accountsDataFullFilename, fileLocation: "Document Directory")
        print("AccountsData is loaded from document directory")
       
    } catch {
       
        /*
         ----------------------------------------------------
         |   The app is being launched for the first time   |
         ----------------------------------------------------
         The CountriesData.json file does not exist in document directory on the user's device.
         Load it from main bundle (project folder) into countryStructList.
        
         This catch section will be executed only once when the app is launched for the first time
         since we write and read the files in document directory on the user's device after first use.
         */
       
        // The function is given in UtilityFunctions.swift
        accountStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: accountsDataFullFilename, fileLocation: "Main Bundle")
        print("AccountsData is loaded from main bundle")
       
    }   // End of do-catch
}
 
/*
 ********************************************************
 MARK: - Write Countries Data Files to Document Directory
 ********************************************************
 */
public func writeAccountsDataFiles() {
    /*
    --------------------------------------------------------------------------
    Write accountStructList into AccountsDate.json file in Document Directory
    --------------------------------------------------------------------------
    */
   
    // Obtain URL of the JSON file into which data will be written
    let urlOfJsonFileInDocumentDirectory: URL? = documentDirectory.appendingPathComponent("AccountsData.json")
 
    // Encode countryStructList into JSON and write it into the JSON file
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(accountStructList) {
        do {
            try encoded.write(to: urlOfJsonFileInDocumentDirectory!)
        } catch {
            fatalError("Unable to write encoded accounts data to document directory!")
        }
    } else {
        fatalError("Unable to encode accounts data!")
    }
}
