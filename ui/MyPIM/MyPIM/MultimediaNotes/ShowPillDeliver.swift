//
//  ShowPillDeliver.swift
//  MyPIM
//
//  Created by Boyan Tian on 11/9/21.
//

import SwiftUI
import MapKit

struct ShowPillDeliver: View {
    
    let device: Device
    
    var body: some View {
        
        Form {
            Section(header: Text("Photo")){
                getImageFromDocumentDirectory(filename: imageFileName(), fileExtension: "jpg", defaultFilename: "DefaultMultimediaNotePhoto")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 300, maxWidth: 500, alignment: .center)

            }
            
        }
        .customNavigationViewStyle()// End of Form
    }   // End of body
    
    func imageFileName() -> String {
        var image: String
        image = device.filename.components(separatedBy: ".")[0]
        return image
    }
}
