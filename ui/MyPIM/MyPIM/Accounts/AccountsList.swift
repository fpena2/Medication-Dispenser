//
//  AccountsList.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//

import SwiftUI
 
struct accountList: View {
      
    // Subscribe to changes in UserData
    @EnvironmentObject var userData: UserData
  
    var body: some View {
        NavigationView {
            List {
                ForEach(userData.accounts) { account in
                    NavigationLink(destination: accountDetails(account: account)) {
                        accountItem(account: account)
                    }
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
              
            }   // End of List
            .navigationBarTitle(Text("Accounts"), displayMode: .inline)
          
            // Place the Edit button on left and Add (+) button on right of the navigation bar
            .navigationBarItems(leading: EditButton(), trailing:
                NavigationLink(destination: addAccount()) {
                    Image(systemName: "plus")
                })
          
        }   // End of NavigationView
        // Use single column navigation view for iPhone and iPad
        .navigationViewStyle(StackNavigationViewStyle())
    }
  
    /*
     ----------------------------------
     MARK: - Delete Selected Account
     ----------------------------------
     */
    func delete(at offsets: IndexSet) {
        /*
        'offsets.first' is an unsafe pointer to the index number of the array element
        to be deleted. It is nil if the array is empty. Process it as an optional.
        */
        if let index = offsets.first {
            userData.accounts.remove(at: index)
        }
        // Set the global variable point to the changed list
        accountStructList = userData.accounts
       
    }
  
    /*
     --------------------------------
     MARK: - Move Selected Account
     --------------------------------
     */
    func move(from source: IndexSet, to destination: Int) {
 
        userData.accounts.move(fromOffsets: source, toOffset: destination)
      
        // Set the global variable point to the changed list
        accountStructList = userData.accounts
    }
}
 
struct accountList_Previews: PreviewProvider {
    static var previews: some View {
        accountList()
    }
}
