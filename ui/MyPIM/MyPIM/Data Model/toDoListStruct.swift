//
//  toDoListStruct.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/21/20.
//

import SwiftUI
 
public struct toDo: Hashable, Codable, Identifiable {
   
    public var id: UUID           // Storage Type: String, Use Type (format): UUID
    var title: String
    var description: String
    var priority: String
    var completed: Bool
    var dueDateAndTime: String
}

