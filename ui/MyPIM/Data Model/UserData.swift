//
//  UserData.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//

import Combine

import SwiftUI

 

final class UserData: ObservableObject {

   
 
    @Published var accounts = accountStructList

    @Published var searchableOrderedContactsList = orderedSearchableContactsList
    
    @Published var contactsStructList = contactPhotoStructList
    
    @Published var userAuthenticated = false
    
    @Published var patientUser = false
    
    @Published var docUser = false
    
    @Published var multimediaNotesStructList = multimediaNoteStructList
    
    @Published var deviceOutputStructList = deviceStructList
    
    @Published var toDoStructsList = toDoStructList

    @Published var orderedToDoStringList = orderedToDosList

    @Published var toDoListSortedtitle = titleOrderedToDoList
    @Published var toDoListSortedDue = dueOrderedToDoList
    @Published var toDoListSortedPriority = priorityOrderedToDoList
    

}
