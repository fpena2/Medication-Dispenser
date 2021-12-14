//
//  ContactPhotosData.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//

import Foundation
import SwiftUI


// Global array of AlbumPhoto structs
var contactPhotoStructList = [Contact]()
var orderedSearchableContactsList = [String]()

/*
 ***********************************
 MARK: - Read ContactPhoto Data File
 ***********************************
 */
public func readAlbumPhotosDataFile() {
    
    var fileExistsInDocumentDirectory = false
    let jsonDataFullFilename = "ContactsData.json"
    
    // Obtain URL of the data file in document directory on user's device
    let urlOfJsonFileInDocumentDirectory = documentDirectory.appendingPathComponent(jsonDataFullFilename)
    
    do {
        _ = try Data(contentsOf: urlOfJsonFileInDocumentDirectory)
        
        // AlbumPhotosData.json file exists in the document directory
        fileExistsInDocumentDirectory = true
        
        contactPhotoStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: jsonDataFullFilename, fileLocation: "Document Directory")
        print("ContactPhotosData is loaded from document directory")
        
    } catch {
        fileExistsInDocumentDirectory = false
        /*
         AlbumPhotosData.json file does not exist in the document directory; Load it from the main bundle.
         This happens only once when the app is launched for the very first time.
         */
        
        contactPhotoStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: jsonDataFullFilename, fileLocation: "Main Bundle")
        print("ContactPhotosData is loaded from main bundle")
        
        
        for contact in contactPhotoStructList {
            let selectedContactAttributesForSearch = "\(contact.id)|\(contact.firstName)|\(contact.lastName)|\(contact.company)|\(contact.addressLine1)|\(contact.addressCity)|\(contact.addressState)|\(contact.addressCountry)"
            
            orderedSearchableContactsList.append(selectedContactAttributesForSearch)
            
        }
    }
    
    if fileExistsInDocumentDirectory {
        
        // Obtain URL of the file in document directory on the user's device
        let urlOfFileInDocDir = documentDirectory.appendingPathComponent("orderedSearchableContactsList")
        
        // Instantiate an NSArray object and initialize it with the contents of the file
        let arrayFromFile: NSArray? = NSArray(contentsOf: urlOfFileInDocDir)
        
        if let arrayObtained = arrayFromFile {
            // Store the unique id of the created array into the global variable
            orderedSearchableContactsList = arrayObtained as! [String]
        } else {
            print("orderedSearchableContactsList file is not found in document directory on the user's device!")
        }
    }
    else{
        /*
         ===============================================================
         |   Copy Contact Photo Files from Assets to Document Directory  |
         ===============================================================
         */
        for photo in contactPhotoStructList {
            
            // Example photo fullFilename = "D3C83FED-B482-425C-A3F8-6C90A636DFBF.jpg"
            let array = photo.photoFullFilename.components(separatedBy: ".")
            
            // array[0] = "D3C83FED-B482-425C-A3F8-6C90A636DFBF"
            // array[1] = "jpg"
            
            // Copy each photo file from Assets.xcassets to document directory
            copyImageFileFromAssetsToDocumentDirectory(filename: array[0], fileExtension: array[1])
        }
    }
}

/*
 **********************************************************
 MARK: - Write Contact Photos Data File to Document Directory
 **********************************************************
 */
public func writeAlbumPhotosDataFile() {
    
    // Obtain URL of the JSON file into which data will be written
    let urlOfJsonFileInDocumentDirectory: URL? = documentDirectory.appendingPathComponent("ContactsData.json")
    
    // Encode photoStructList into JSON and write it into the JSON file
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(contactPhotoStructList) {
        do {
            try encoded.write(to: urlOfJsonFileInDocumentDirectory!)
        } catch {
            fatalError("Unable to write encoded photo data to document directory!")
        }
    } else {
        fatalError("Unable to encode photo data!")
    }
    let urlOfFileInDocDirectory = documentDirectory.appendingPathComponent("orderedSearchableContactsList")

    (orderedSearchableContactsList as NSArray).write(to: urlOfFileInDocDirectory, atomically: true)
}


/*
 **************************************************************
 MARK: - Save Taken or Picked Photo Image to Document Directory
 **************************************************************
 */
public func savePhoto(firstName: String, lastName:String, company:String, phone:String, email:String, addressLine1:String, addressLine2:String, addressCity:String, addressState:String, addressZipcode:String, addressCountry:String) -> Contact {
    
    //----------------------------------------
    // Generate a new id and new full filename
    //----------------------------------------
    let newContactPhotoId = UUID()
    let newFullFilename = UUID().uuidString + ".jpg"
    
    
    
    //----------------------------------------------------------
    // Get Latitude and Longitude of Where Photo Taken or Picked
    //----------------------------------------------------------
    
    
    
    let newContact = Contact(id: newContactPhotoId, firstName: firstName, lastName: lastName, photoFullFilename: newFullFilename, company: company, phone: phone, email: email, addressLine1: addressLine1, addressLine2: addressLine2, addressCity: addressCity, addressState: addressState, addressZipcode: addressZipcode, addressCountry: addressCountry)
    
    /*AlbumPhoto(id: newAlbumPhotoId, title: title, category: category,
     fullFilename: newFullFilename,
     dateTime: currentDateTime,
     latitude: photoLocation.latitude,
     longitude: photoLocation.longitude,
     rating: rating) */
    
    
    
    //-------------------------------------------------------
    // Save Taken or Picked Photo Image to Document Directory
    //-------------------------------------------------------
    
    // Global variable pickedImage was obtained in ImagePicker.swift
    
    /*
     Convert pickedImage to a data object containing the
     image data in JPEG format with 100% compression quality
     */
    if let data = pickedImage.jpegData(compressionQuality: 1.0) {
        print(newFullFilename)
        let fileUrl = documentDirectory.appendingPathComponent(newFullFilename)
        try? data.write(to: fileUrl)
    } else {
        print("Unable to write photo image to document directory!")
    }
    
    return newContact
}
