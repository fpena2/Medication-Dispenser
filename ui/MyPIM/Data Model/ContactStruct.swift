//
//  ContactStruct.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//

import SwiftUI
 
public struct Contact: Hashable, Codable, Identifiable {
   
    public var id: UUID         // Unique id of album photo. Storage Type: String, Data Type: UUID
    var firstName: String       // Album photo title
    var lastName: String
    var photoFullFilename: String
    var company: String
    var phone: String
    var email: String
    var addressLine1: String
    var addressLine2: String
    var addressCity: String
    var addressState: String
    var addressZipcode: String
    var addressCountry: String
}


