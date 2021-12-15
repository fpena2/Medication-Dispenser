//
//  ToDoList.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/21/20.
//

import SwiftUI

struct toDoList: View {
    
    // Subscribe to changes in UserData
    @EnvironmentObject var userData: UserData
    @State private var selectedSortTypeIndex = 0
    let sortTypes = ["Title", "Due Data", "Priority"]
    
    var body: some View {
        
        
        NavigationView {
            VStack {
           

                    Picker("Colors", selection: $selectedSortTypeIndex) {
                        ForEach(0 ..< sortTypes.count, id: \.self) {
                            Text(self.sortTypes[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.bottom)
                List {
                
                switch selectedSortTypeIndex {
                case 0:
                    ForEach(userData.toDoListSortedtitle) { aToDo in
                        NavigationLink(destination: ToDoDetail(todo: aToDo)) {
                            ToDoItem(todo: aToDo)
                        }
                    }
                    .onDelete(perform: delete)
                    
                case 1:
                    ForEach(userData.toDoListSortedDue) { aToDo in
                        NavigationLink(destination: ToDoDetail(todo: aToDo)) {
                            ToDoItem(todo: aToDo)
                        }
                    }
                    .onDelete(perform: delete1)
                case 2:
                    ForEach(userData.toDoListSortedPriority) { aToDo in
                        NavigationLink(destination: ToDoDetail(todo: aToDo)) {
                            ToDoItem(todo: aToDo)
                        }
                    }
                    .onDelete(perform: delete2)
                    
                default:
                    fatalError("out of range")
                }
                
            }   // End of List
            }
            .navigationBarTitle(Text("To-Do Task Details"), displayMode: .inline)
            
            // Place the Edit button on left and Add (+) button on right of the navigation bar
            .navigationBarItems(leading: EditButton(), trailing:
                                    NavigationLink(destination: addToDo()) {
                                        Image(systemName: "plus")
                                    })
            
        }   // End of NavigationView
        // Use single column navigation view for iPhone and iPad
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    /*
     ----------------------------------
     MARK: - Delete Selected Task
     ----------------------------------
     */
    func delete(at offsets: IndexSet) {
        /*
         'offsets.first' is an unsafe pointer to the index number of the array element
         to be deleted. It is nil if the array is empty. Process it as an optional.
         */
        if let index = offsets.first {
            userData.toDoListSortedtitle.remove(at: index)

        }
        // Set the global variable point to the changed list
        toDoStructList = userData.toDoListSortedtitle
        createSortedLists()

    }
    func delete1(at offsets: IndexSet) {
        /*
         'offsets.first' is an unsafe pointer to the index number of the array element
         to be deleted. It is nil if the array is empty. Process it as an optional.
         */
        if let index = offsets.first {
            userData.toDoListSortedDue.remove(at: index)

        }
        // Set the global variable point to the changed list
        toDoStructList = userData.toDoListSortedDue
        createSortedLists()
    }
    func delete2(at offsets: IndexSet) {
        /*
         'offsets.first' is an unsafe pointer to the index number of the array element
         to be deleted. It is nil if the array is empty. Process it as an optional.
         */
        if let index = offsets.first {
            userData.toDoListSortedPriority.remove(at: index)

        }
        // Set the global variable point to the changed list
        toDoStructList = userData.toDoListSortedPriority
        createSortedLists()
    }
    
    
}

