//
//  MainView.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//

import SwiftUI
 
struct MainView: View {
    var body: some View {
        TabView {
            multimediaList()
                .tabItem {
                    Image(systemName: "doc.richtext")
                    Text("Schedule")
                }
            deviceList()
                .tabItem {
                    Image(systemName: "folder.badge.gearshape")
                    Text("History")
                }
            
            Settings()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
           
        }   // End of TabView
            .font(.headline)
            .imageScale(.medium)
            .font(Font.title.weight(.regular))
    }
}
 
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
