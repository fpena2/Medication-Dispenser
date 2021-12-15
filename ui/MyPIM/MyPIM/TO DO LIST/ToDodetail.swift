//
//  ToDodetail.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/21/20.
//

import SwiftUI
import MapKit

struct ToDoDetail: View {
    
    // Input Parameter
    let todo: toDo
    
    var body: some View {
        // A Form cannot have more than 10 Sections.
        // Group the Sections if more than 10.
        Form {
            
            Section(header: Text("Name")) {
                Text(todo.title)
            }
            
            Section(header: Text("To-Do List Task Title")) {
                Text(todo.description)
            }
            
            Section(header: Text("To-Do List Task Description")) {
                Text(todo.priority)
            }
            
            Section(header: Text("To-Do List Task Priority Level")) {
                Text(String(todo.completed))
            }
            
            Section(header: Text("To-Do List Task Due Date And Time")) {
                Text(todo.dueDateAndTime)
            }
            
        }   // End of Form
        .navigationBarTitle(Text("To-Do List"), displayMode: .inline)
        .font(.system(size: 14))
        
    }   // End of body

}


