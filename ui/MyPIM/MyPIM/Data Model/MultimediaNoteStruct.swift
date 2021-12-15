//
//  MultimediaNoteStruct.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//
 
import SwiftUI
 
public struct Multimedia: Hashable, Codable, Identifiable {
   
    public var id: UUID           // Storage Type: String, Use Type (format): UUID
    var title: String
    var textualNote: String
    var dateTime: String
    var startDate: String
    var startTime: String
    var eventCount: String
    var label: String
    var schedule: String
    var checkuse: String
}
