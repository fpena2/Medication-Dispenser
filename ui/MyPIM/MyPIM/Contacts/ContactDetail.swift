//
//  ContactDetail.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//

import SwiftUI
import MapKit

struct ContactDetail: View {
    
    // Input Parameter
    let contact: Contact
    
    var body: some View {
        // A Form cannot have more than 10 Sections.
        // Group the Sections if more than 10.
        Form {
            
            Section(header: Text("Name")) {
                Text(contact.firstName + " " + contact.lastName)
            }
            Section(header: Text("Photo")) {
                // This public function is given in UtilityFunctions.swift
                getImageFromDocumentDirectory(filename: contact.photoFullFilename.components(separatedBy: ".")[0], fileExtension: contact.photoFullFilename.components(separatedBy: ".")[1], defaultFilename: "DefaultContactPhoto")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 300, maxWidth: 500, alignment: .center)
            }
            
            Section(header: Text("Company Name")) {
                Text(contact.company)
            }
            
            Section(header: Text("Phone Number")) {
                HStack {
                    Image(systemName: "phone.circle")
                        .imageScale(.large)
                    Text(contact.phone)
                }
            }
            
            Section(header: Text("Email Address")) {
                HStack {
                    Image(systemName: "envelope")
                        .imageScale(.large)
                    Text(contact.email)
                }
            }
            
            Section(header: Text("Postal Address")) {
                VStack (alignment: .leading){
                    Text(contact.addressLine1)
                    if contact.addressLine2 != "" {
                        Text(contact.addressLine2)
                    }
                    Text(addressdetail(city: contact.addressCity, state: contact.addressState, zipcode: contact.addressZipcode))
                    Text(contact.addressCountry)
                }
            }
            
        }   // End of Form
        .navigationBarTitle(Text("Country Details"), displayMode: .inline)
        .font(.system(size: 14))
        
    }   // End of body
    func addressdetail(city: String, state: String, zipcode: String) -> String{
        if city == "" {
            return "\(state) \(zipcode)"
        }
        if state == "" {
            return "\(city), \(zipcode)"
        }
        return "\(city), \(state) \(zipcode)"
    }
}

struct ContactDetail_Previews: PreviewProvider {
    static var previews: some View {
        ContactDetail(contact: contactPhotoStructList[0])
    }
}
