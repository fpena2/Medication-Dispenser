//
//  AddToDo.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/21/20.
//

import SwiftUI

struct addToDo: View {
    
    // Subscribe to changes in UserData
    @EnvironmentObject var userData: UserData
    
    /*
     Display this view as a Modal View and enable it to dismiss itself
     to go back to the previous view in the navigation hierarchy.
     */
    @Environment(\.presentationMode) var presentationMode
    
    
    let priorityLevel = ["Low", "Normal", "High"]
    
    let completed = ["Yes", "No"]
    
    @State private var selectedIndex = 0    // Shopping
    @State private var selectedIndex1 = 0
    
    @State private var taskTitle = ""
    
    @State private var taskDescription = ""
    
    @State private var date = ""
    
    @State private var complete = false
    
    @State private var dueDateAndTime = Date()
    
    // Alerts
    @State private var showAccountAddedAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("TASK TITLE")) {
                
                TextField("Enter task title", text: $taskTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
            }
            
            Section(header: Text("TASK Description")) {
                
                TextField("Enter task description", text: $taskDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
            }
            
            Section(header: Text("Task Priority Level")) {
                Picker("", selection: $selectedIndex) {
                    ForEach(0 ..< priorityLevel.count, id: \.self) {
                        Text(self.priorityLevel[$0])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Task Priority Level")) {
                Picker("", selection: $selectedIndex1) {
                    ForEach(0 ..< completed.count, id: \.self) {
                        Text(self.completed[$0])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Task Due Date And Time")) {
                HStack {
                    Text("Due Date and Time")
                    DatePicker(
                        "", selection: $dueDateAndTime,
                        in: dateClosedRange,
                        displayedComponents: [.hourAndMinute, .date]
                    )
                }
            }
            
            
        }   // End of Form
        .font(.system(size: 14))
        .alert(isPresented: $showAccountAddedAlert, content: { self.accountAddedAlert })
        .navigationBarTitle(Text("Add Task"), displayMode: .inline)
        // Place the Add (+) button on right of the navigation bar
        .navigationBarItems(trailing:
                                Button(action: {
                                    self.addNewTask()
                                    self.showAccountAddedAlert = true
                                }
                                ) {
                                    Text("Save")
                                })
        
    }   // End of body
    
    
    
    
    var dateAndTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full     // e.g., Monday, June 29, 2020
        formatter.timeStyle = .short    // e.g., 5:19 PM
        return formatter
    }
    
    var dateClosedRange: ClosedRange<Date> {
        // Set minimum date to 20 years earlier than the current year
        let minDate = Calendar.current.date(byAdding: .year, value: -20, to: Date())!
        
        // Set maximum date to 10 years later than the current year
        let maxDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())!
        return minDate...maxDate
    }
    
    
    
    
    
    /*
     ----------------------------------
     MARK: - New Voice Memo Added Alert
     ----------------------------------
     */
    var accountAddedAlert: Alert {
        Alert(title: Text("Task Added!"),
              message: Text("New Task is added to your To-Do-list."),
              dismissButton: .default(Text("OK")) {
                
                // Dismiss this Modal View and go back to the previous view in the navigation hierarchy
                self.presentationMode.wrappedValue.dismiss()
              })
    }
    
    
    /*
     --------------------------
     MARK: - Add New Task
     --------------------------
     */
    func addNewTask() {
        let dateraw = "\(dueDateAndTime)"
        print(dateraw)
        let raw = dateraw.components(separatedBy: " ")
        let raw1 = raw[0]
        let raw2 = raw[1].dropLast(3)
        self.date = "\(raw1) at \(raw2)"
        
        print("\(dueDateAndTime)")
        
        if self.completed[selectedIndex1] == "Yes" {
            self.complete = true
        }
        else {
            self.complete = false
        }
        
        let newTask = toDo(id: UUID(), title: self.taskTitle, description: self.taskDescription, priority: self.priorityLevel[selectedIndex], completed: self.complete, dueDateAndTime: self.date)
        // Append the new voice memo to the list
        userData.toDoStructsList.append(newTask)
        // Set the global variable point to the changed list
        toDoStructList = userData.toDoStructsList
        
        createSortedLists()
        
        // Dismiss this View and go back
        self.presentationMode.wrappedValue.dismiss()
    }
    
}
