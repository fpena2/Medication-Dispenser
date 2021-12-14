//
//  ContactItem.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//

import SwiftUI
 
struct ContactItem: View {
   
    // Input Parameter
    let contact: Contact
   
    var body: some View {
        HStack {
            // This public function is given in UtilityFunctions.swift
            getImageFromDocumentDirectory(filename: contact.photoFullFilename.components(separatedBy: ".")[0], fileExtension: contact.photoFullFilename.components(separatedBy: ".")[1], defaultFilename: "DefaultContactPhoto")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
           
            VStack(alignment: .leading) {
                Text(contact.firstName + " " + contact.lastName)
                Text(address(city: contact.addressCity, state: contact.addressState, Country: contact.addressCountry))
                HStack {
                    Image(systemName: "phone.circle")
                        .imageScale(.large)
                    Text(contact.phone)
                }
                
            }
            // Set font and size for the whole VStack content
            .font(.system(size: 14))
           
        }   // End of HStack
    }
    
    
    func address(city: String, state: String, Country: String) -> String{
        if city == "" {
            return "\(state), \(Country)"
        }
        if state == "" {
            return "\(city), \(Country)"
        }
        return "\(city), \(state), \(Country)"
    }
}
 
struct ContactItem_Previews: PreviewProvider {
    static var previews: some View {
        ContactItem(contact: contactPhotoStructList[0])
    }
}
