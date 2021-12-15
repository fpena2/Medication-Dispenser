//
//  AccountStruct.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//


import SwiftUI
 
struct Account: Hashable, Codable, Identifiable {
   
    var id: UUID        // Storage Type: String, Use Type (format): UUID
    var title: String
    var category: String
    var url: String
    var username: String
    var password: String
    var notes: String
}
