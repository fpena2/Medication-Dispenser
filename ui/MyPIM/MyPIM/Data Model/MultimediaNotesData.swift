//
//  MultimediaNotesData.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//

import Foundation
import SwiftUI
import CoreLocation
import AVFoundation

// Global array of AlbumPhoto structs
var multimediaNoteStructList = [Multimedia]()
var audioSession = AVAudioSession()

/*
 Each orderedSearchableMoviesList element contains
 selected movie attributes separated by vertical lines
 for inclusion in the search by the Search Bar in FavoritesList:
      "id|name|alpha2code|capital|languages|currency"
 */
var orderedSearchableMoviesList = [String]()
 
/*
 *********************************
 MARK: - Read Movies Data Files
 *********************************
 */
public func readMoviesDataFiles() {
    let notesDataFullFilename = "Schedule.json"
   
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
        multimediaNoteStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: notesDataFullFilename, fileLocation: "Document Directory")
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
        multimediaNoteStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: notesDataFullFilename, fileLocation: "Main Bundle")
        print("MoviesData is loaded from main bundle")
    }   // End of do-catch
}


/*
 **********************************************************
 MARK: - Write Notes Data File to Document Directory
 **********************************************************
 */
public func writeMultimediaNotesDataFile() {
    
    // Obtain URL of the JSON file into which data will be written
    let urlOfJsonFileInDocumentDirectory: URL? = documentDirectory.appendingPathComponent("Schedule.json")
    
    // Encode photoStructList into JSON and write it into the JSON file
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(multimediaNoteStructList) {
        do {
            try encoded.write(to: urlOfJsonFileInDocumentDirectory!)
        } catch {
            fatalError("Unable to write encoded photo data to document directory!")
        }
    } else {
        fatalError("Unable to encode photo data!")
    }
}

/*
******************************************
MARK: - Get Permission for Voice Recording
******************************************
*/
public func getPermissionForVoiceRecording() {
   
    // Create a shared audio session instance
    audioSession = AVAudioSession.sharedInstance()
   
    //---------------------------
    // Enable Built-In Microphone
    //---------------------------
   
    // Find the built-in microphone.
    guard let availableInputs = audioSession.availableInputs,
          let builtInMicrophone = availableInputs.first(where: { $0.portType == .builtInMic })
    else {
        print("The device must have a built-in microphone.")
        return
    }
    do {
        try audioSession.setPreferredInput(builtInMicrophone)
    } catch {
        print("Unable to Find the Built-In Microphone!")
    }
   
    //--------------------------------------------------
    // Set Audio Session Category and Request Permission
    //--------------------------------------------------
   
    do {
        try audioSession.setCategory(.playAndRecord, mode: .default)
       
        // Activate the audio session
        try audioSession.setActive(true)
       
        // Request permission to record user's voice
        audioSession.requestRecordPermission() { allowed in
            DispatchQueue.main.async {
                if allowed {
                    // Permission is recorded in the Settings app on user's device
                } else {
                    // Permission is recorded in the Settings app on user's device
                }
            }
        }
    } catch {
        print("Setting category or getting permission failed!")
    }
}




/*
 **************************************************************
 MARK: - Save Taken or Picked Photo Image to Document Directory
 **************************************************************
 */
public func saveNotePhoto(title:String, textualNote:String, audioFullFilename:String, dataTime:String, startDate:String, startTime:String, eventCount:String, label:String, schedule: String, checkuse: String) -> Multimedia {
    
    
    //----------------------------------------
    // Generate a new id and new full filename
    //----------------------------------------
    let newNotePhotoId = UUID()
    
    
    
    //----------------------------------------------------------
    // Get Latitude and Longitude of Where Photo Taken or Picked
    //----------------------------------------------------------
    
    
    let newNote = Multimedia(id: newNotePhotoId, title: title, textualNote: textualNote, dateTime: dataTime, startDate: startDate, startTime: startTime, eventCount: eventCount, label: label, schedule: schedule, checkuse: checkuse)
    
    return newNote
}


public func checkReady(deliveryTime: String, channel: String) -> Bool {
    var indictor = 0
    for aNote in multimediaNoteStructList {
        print(aNote)
        print(deliveryTime)
        print(channel)
        if aNote.checkuse == deliveryTime && aNote.label == channel {
            print("nice, perfect, good")
            indictor = 1
            break
        }
        else {
            print("failed fkkkkkkkkk")
        }
    }
    if indictor == 1 {
        print("find conflict")
        return true
    }
    else {
        print("no conflict")
        return false
    }
    
}

public func checkPastDate() -> Bool{
    var indictor = 0
    
    let date = Date()
    
    // Instantiate a DateFormatter object
    let dateFormatter = DateFormatter()
    
    // Set the date format to yyyy-MM-dd at HH:mm:ss
    dateFormatter.dateFormat = "yyyy-MM-dd' at 'HH:mm:ss"
    
    // Format the Date object as above and convert it to String
    let currentDateTime = dateFormatter.string(from: date)
    
    var startDateAndTime: String
    
    for aNote in multimediaNoteStructList {
        print(aNote)
        print(Date())
        print(aNote.startTime)
        print(aNote.startDate)
        //  First date is smaller then the second date
        
        
        
        startDateAndTime = aNote.startDate + " at " + aNote.startTime
        print(startDateAndTime)
        print(currentDateTime)
        
        if startDateAndTime.compare(currentDateTime) == .orderedAscending {
            indictor = 1
        }
    }
    if indictor == 1 {
        print("past due")
        return true
    }
    else {
        print("its k")
        return false
    }
    
}
