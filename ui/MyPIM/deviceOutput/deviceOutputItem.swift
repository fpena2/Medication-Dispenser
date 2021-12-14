//
//  deviceOutputItem.swift
//  MyPIM
//
//  Created by Boyan Tian on 12/1/21.
//

import SwiftUI
 
struct DeviceOutputItem: View {
   
    // Input Parameter passed by value
    let device: Device
   
    var body: some View {
        VStack(alignment: .leading) {
            Text(device.timestamp)
        }
        
        .font(.system(size: 14))
    }
}
