//
//  MultimediaNoteItem.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//

import SwiftUI
 
struct MultimediaNoteItem: View {
   
    // Input Parameter passed by value
    let multimedia: Multimedia
   
    var body: some View {
        VStack(alignment: .leading) {
            Text(multimedia.title)
            Text(multimedia.dateTime)
        }
        .font(.system(size: 14))
    }
}
