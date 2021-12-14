//
//  MultimediaNotesList.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//

import SwiftUI
 
struct multimediaList: View {
      
    // Subscribe to changes in UserData
    @EnvironmentObject var userData: UserData
  
    var body: some View {
        NavigationView {
            List {
                ForEach(userData.multimediaNotesStructList) { aNote in
                    NavigationLink(destination: MultimediaNoteDetail(multimedia: aNote)) {
                        MultimediaNoteItem(multimedia: aNote)
                    }
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
              
            }   // End of List
            .navigationBarTitle(Text("Pill Delivery Schedule"), displayMode: .inline)
          
            // Place the Edit button on left and Add (+) button on right of the navigation bar
            .navigationBarItems(leading: EditButton(), trailing:
                                    NavigationLink(destination: addNote()) {
                    Image(systemName: "plus")
                })
          
        }   // End of NavigationView
        // Use single column navigation view for iPhone and iPad
        .navigationViewStyle(StackNavigationViewStyle())
    }
  
    /*
     ----------------------------------
     MARK: - Delete Selected Notes
     ----------------------------------
     */
    func delete(at offsets: IndexSet) {
        /*
        'offsets.first' is an unsafe pointer to the index number of the array element
        to be deleted. It is nil if the array is empty. Process it as an optional.
        */
        if let index = offsets.first {
            userData.multimediaNotesStructList.remove(at: index)
        }
        // Set the global variable point to the changed list
        multimediaNoteStructList = userData.multimediaNotesStructList
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
        uploadData()
    }
  
    /*
     --------------------------------
     MARK: - Move Selected Notes
     --------------------------------
     */
    func move(from source: IndexSet, to destination: Int) {
 
        userData.multimediaNotesStructList.move(fromOffsets: source, toOffset: destination)
      
        // Set the global variable point to the changed list
        multimediaNoteStructList = userData.multimediaNotesStructList
    }
}
 
struct multimediaList_Previews: PreviewProvider {
    static var previews: some View {
        multimediaList()
    }
}
