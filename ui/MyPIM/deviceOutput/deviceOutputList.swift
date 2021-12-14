//
//  deviceOutputList.swift
//  MyPIM
//
//  Created by Boyan Tian on 12/1/21.
//

import SwiftUI
 
struct deviceList: View {
      
    // Subscribe to changes in UserData
    @EnvironmentObject var userData: UserData
  
    var body: some View {
        NavigationView {
            List {
                ForEach(userData.deviceOutputStructList, id:\.self) { aOutput in
                    NavigationLink(destination: DeviceOutputDetail(device: aOutput)) {
                        DeviceOutputItem(device: aOutput)
                    }
                    }
            }   // End of List
            .navigationBarTitle(Text("Pill delivery history"), displayMode: .inline)
            .toolbar {
                Button("check") {
                    removeFile()
                    downloadAioutputJson()
                }
            }
          
          
        }   // End of NavigationView
        // Use single column navigation view for iPhone and iPad
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
