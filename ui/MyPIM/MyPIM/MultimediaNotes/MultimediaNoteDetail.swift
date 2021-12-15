//
//  MultimediaNoteDetail.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//

import SwiftUI
import MapKit

struct MultimediaNoteDetail: View {
    
    // Input Parameter
    let multimedia: Multimedia
    
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var audioPlayer: AudioPlayer
    
    var body: some View {
        
        Form {
            Section(header: Text("Pill name")) {
                Text(multimedia.title)
            }
            

            Section(header: Text("Instruction Note")) {
                Text(multimedia.textualNote)
            }
            
            
            Section(header: Text("Date And Time When Note Was Take")) {
                Text(multimedia.dateTime)
            }
            
            Section(header: Text("Start Date")) {
                Text(multimedia.startDate)
            }
            Section(header: Text("Start Time")) {
                Text(multimedia.startTime)
            }
            Section(header: Text("event Count")) {
                Text(multimedia.eventCount)
            }
            Section(header: Text("channel")) {
                Text(multimedia.label)
            }
            
            
        }   // End of Form
    }   // End of body
    
}
