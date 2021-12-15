//
//  deviceOutputDetails.swift
//  MyPIM
//
//  Created by Boyan Tian on 12/1/21.
//

import SwiftUI
import MapKit

struct DeviceOutputDetail: View {
    
    // Input Parameter
    let device: Device
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        
        Form {
            Section(header: Text("device ID")) {
                Text(deviceNumber())
            }
            Section(header: Text("Timestamp")) {
                Text(device.timestamp)
            }
            Section(header: Text("Show Pill Deliver")) {
                NavigationLink(destination: showResults) {
                    HStack {
                        Image(systemName: "photo.circle")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)
                        Text("Pill Deliver Image")
                    }
                }
                .frame(minWidth: 300, maxWidth: 500)
            }
            
            Section(header: Text("Status")) {
                Text(device.status)
            }
            Section(header: Text("Notes")) {
                Text(device.notes)
            }
            Section(header: Text("Last Pill")) {
                Text(device.lastPill)
            }
            Section(header: Text("unidentified Objects")) {
                Text(String(device.unidentifiedObjects))
            }
            Section(header: Text("Pills Released")) {
                Text(pillsRel())
            }
            Section(header: Text("pills Removed")) {
                Text(pillsRem())
            }
        }   // End of Form
    }   // End of body
    
    func pillsRem() -> String {
        var pills: String
        print(device.pillsRemoved.count)
        if device.pillsRemoved.count == 1 {
            pills = device.pillsRemoved[0]
        }
        else {
            pills = device.pillsRemoved[0] + " " + device.pillsRemoved[1]
        }
        return pills
    }
    func pillsRel() -> String {
        var pills: String
        if device.pillsReleased.count == 1 {
            pills = device.pillsReleased[0]
            return pills
        }
        else {
            pills = device.pillsReleased[0] + " " + device.pillsReleased[1]
            return pills
        }
        
    }

    
    var showResults: some View {
       
        // Global variable movieFound is given in MovieApiData.swift
        downloadData(imageName: device.filename)
        return AnyView(ShowPillDeliver(device: device))
    }
    
    func deviceNumber() -> String {
        var deviceNum: String
        deviceNum = device.filename.components(separatedBy: "_")[0]
        return deviceNum
    }
}
