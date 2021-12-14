//
//  deviceOutput.swift
//  MyPIM
//
//  Created by Boyan Tian on 12/1/21.
//

import SwiftUI
 
public struct Device: Hashable, Codable {
    var filename: String
    var timestamp: String
    var status: String
    var notes: String
    var lastPill: String
    var unidentifiedObjects: Int
    var pillsReleased: [String]
    var pillsRemoved: [String]
}
