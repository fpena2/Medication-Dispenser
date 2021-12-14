//
//  ToDoItem.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/21/20.
//

import SwiftUI

struct ToDoItem: View {
    
    // Input Parameter passed by value
    let todo: toDo
    
    var body: some View {
        if todo.priority == "Normal" {
            HStack {
                
                if todo.completed == false {
                    Image(systemName: "square")
                        .imageScale(.large)
                        .font(Font.title.weight(.regular))
                        .foregroundColor(.blue)
                }
                
                if todo.completed == true {
                    Image(systemName: "checkmark.square")
                        .imageScale(.large)
                        .font(Font.title.weight(.regular))
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading) {
                    Text(todo.title).foregroundColor(.green)
                    Text(todo.dueDateAndTime).foregroundColor(.green)
                    
                }
                .font(.system(size: 14))
                
            }   // End of HStack
        }
        
        if todo.priority == "High" {
            HStack {
                
                if todo.completed == false {
                    Image(systemName: "square")
                        .imageScale(.large)
                        .font(Font.title.weight(.regular))
                        .foregroundColor(.blue)
                }
                
                if todo.completed == true {
                    Image(systemName: "checkmark.square")
                        .imageScale(.large)
                        .font(Font.title.weight(.regular))
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading) {
                    Text(todo.title).foregroundColor(.red)
                    Text(todo.dueDateAndTime).foregroundColor(.red)
                    
                }
                .font(.system(size: 14))
                
            }   // End of HStack
        }
        
        if todo.priority == "Low" {
            HStack {
                
                if todo.completed == false {
                    Image(systemName: "square")
                        .imageScale(.large)
                        .font(Font.title.weight(.regular))
                        .foregroundColor(.blue)
                }
                
                if todo.completed == true {
                    Image(systemName: "checkmark.square")
                        .imageScale(.large)
                        .font(Font.title.weight(.regular))
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading) {
                    Text(todo.title)
                    Text(todo.dueDateAndTime)
                    
                }
                .font(.system(size: 14))
                
            }   // End of HStack
        }
        
    }
}
