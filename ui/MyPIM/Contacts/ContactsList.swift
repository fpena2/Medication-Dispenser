//
//  ContactsList.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//

import SwiftUI
 
struct ContactsList: View {
   
    // Subscribe to changes in UserData
    @EnvironmentObject var userData: UserData
   
    @State private var searchItem = ""
   
    var body: some View {
        NavigationView {
            List {
                SearchBar(searchItem: $searchItem, placeholder: "Search Contacts")
               
                ForEach(userData.searchableOrderedContactsList.filter {self.searchItem.isEmpty ? true : $0.localizedStandardContains(self.searchItem)}, id: \.self)
                { item in
                    NavigationLink(destination: ContactDetail(contact: self.searchItemContact(searchListItem: item)))
                    {
                        ContactItem(contact: self.searchItemContact(searchListItem: item))
                    }
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
               
            }   // End of List
            .navigationBarTitle(Text("Contacts"), displayMode: .inline)
           
            // Place the Edit button on left of the navigation bar
            .navigationBarItems(leading: EditButton(), trailing:
                NavigationLink(destination: AddContact()) {
                    Image(systemName: "plus")
                })
           
        }   // End of NavigationView
            .customNavigationViewStyle()  // Given in NavigationStyle.swift
    }
   
    func searchItemContact(searchListItem: String) -> Contact {
        /*
         searchListItem = "id|name|alpha2code|capital|languages|currency"
         country id = searchListItem.components(separatedBy: "|")[0]
         */
        // Find the index number of countriesList matching the country attribute 'id'
        print(searchListItem.components(separatedBy: "|")[0])
        let index = userData.contactsStructList.firstIndex(where: {$0.id.uuidString == searchListItem.components(separatedBy: "|")[0]})!
       
        return userData.contactsStructList[index]
    }
   
    /*
     -------------------------------
     MARK: - Delete Selected contact
     -------------------------------
     */
    func delete(at offsets: IndexSet) {
        /*
        'offsets.first' is an unsafe pointer to the index number of the array element
        to be deleted. It is nil if the array is empty. Process it as an optional.
        */
        if let index = offsets.first {
            userData.contactsStructList.remove(at: index)
            userData.searchableOrderedContactsList.remove(at: index)
        }
        // Set the global variable point to the changed list
        contactPhotoStructList = userData.contactsStructList
       
        // Set the global variable point to the changed list
        orderedSearchableContactsList = userData.searchableOrderedContactsList
    }
   
    /*
     -----------------------------
     MARK: - Move Selected contact
     -----------------------------
     */
    func move(from source: IndexSet, to destination: Int) {
 
        userData.contactsStructList.move(fromOffsets: source, toOffset: destination)
        userData.searchableOrderedContactsList.move(fromOffsets: source, toOffset: destination)
       
        // Set the global variable point to the changed list
        contactPhotoStructList = userData.contactsStructList
       
        // Set the global variable point to the changed list
        orderedSearchableContactsList = userData.searchableOrderedContactsList
    }
}
 
struct ContactsList_Previews: PreviewProvider {
    static var previews: some View {
        ContactsList()
    }
}
