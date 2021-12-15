//
//  AddContact.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//

 
import SwiftUI
import CoreData
 
struct AddContact: View {
    
    // Enable this View to be dismissed to go back when the Save button is tapped
    @EnvironmentObject var userData: UserData
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showContactAddedAlert = false
    
    // Contact Entity
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var company = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var address1 = ""
    @State private var address2 = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zipCode = ""
    @State private var country = ""
    
    // Album Cover Photo
    @State private var showImagePicker = false
    @State private var photoImageData: Data? = nil
    @State private var photoTakeOrPickIndex = 1     // Pick from Camera
    
    var photoTakeOrPickChoices = ["Camera", "Photo Library"]
    
    var body: some View {
        Form {
            Group {
                Section(header: Text("Pick Photo From Photo Library")) {
                    VStack {
                        Picker("Take or Pick Photo", selection: $photoTakeOrPickIndex) {
                            ForEach(0 ..< photoTakeOrPickChoices.count, id: \.self) {
                                Text(self.photoTakeOrPickChoices[$0])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        
                        Button(action: {
                            self.showImagePicker = true
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up.on.square")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("Get Photo").bold()
                                    .padding()
                            }
                        }
                    }   // End of VStack
                }
                Section(header: Text("Contact Photo")) {
                    photoImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100.0, height: 100.0)
                    Spacer()
                }
            }   // End of Group
            
            Group{
                Section(header: Text("First Name")){
                    HStack {
                        TextField("Enter First Name", text: $firstName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                        // Button to clear the text field
                        Button(action: {
                            self.firstName = ""
                        }) {
                            Image(systemName: "multiply.square")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }   // End of HStack
                }
                
                Section(header: Text("Last Name")){
                    HStack {
                        TextField("Enter Last Name", text: $lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                        // Button to clear the text field
                        Button(action: {
                            self.lastName = ""
                        }) {
                            Image(systemName: "multiply.square")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }   // End of HStack
                }
                
                Section(header: Text("Company Name")){
                    HStack {
                        TextField("Enter Company Name", text: $company)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                        // Button to clear the text field
                        Button(action: {
                            self.company = ""
                        }) {
                            Image(systemName: "multiply.square")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }   // End of HStack
                }
                
                Section(header: Text("Phone Number")){
                    HStack {
                        Image(systemName: "phone.circle")
                        TextField("Enter Phone Number", text: $phone)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                        // Button to clear the text field
                        Button(action: {
                            self.phone = ""
                        }) {
                            Image(systemName: "multiply.square")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }   // End of HStack
                }
                
                Section(header: Text("Email Address")){
                    HStack {
                        Image(systemName: "envelope")
                        TextField("Enter Email Address", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                        // Button to clear the text field
                        Button(action: {
                            self.email = ""
                        }) {
                            Image(systemName: "multiply.square")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }   // End of HStack
                }
                
                Section(header: Text("Address Line 1")){
                    HStack {
                        TextField("Enter Address Line 1", text: $address1)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                        // Button to clear the text field
                        Button(action: {
                            self.address1 = ""
                        }) {
                            Image(systemName: "multiply.square")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }   // End of HStack
                }
                
                Section(header: Text("Address Line 2 (OPTIONAL)")){
                    HStack {
                        TextField("Enter Address Line 2", text: $address2)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                        // Button to clear the text field
                        Button(action: {
                            self.address2 = ""
                        }) {
                            Image(systemName: "multiply.square")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }   // End of HStack
                }
                
                Section(header: Text("City Name")){
                    HStack {
                        TextField("Enter City Name", text: $city)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                        // Button to clear the text field
                        Button(action: {
                            self.city = ""
                        }) {
                            Image(systemName: "multiply.square")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }   // End of HStack
                }
                
                Section(header: Text("State (OPTIONAL FOR NON-USA ADDRESSES")){
                    HStack {
                        TextField("Enter State", text: $state)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                        // Button to clear the text field
                        Button(action: {
                            self.state = ""
                        }) {
                            Image(systemName: "multiply.square")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }   // End of HStack
                    
                }
                
                Section(header: Text("ZiP Code")){
                    HStack {
                        TextField("Enter Zip Code", text: $zipCode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                        // Button to clear the text field
                        Button(action: {
                            self.zipCode = ""
                        }) {
                            Image(systemName: "multiply.square")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }   // End of HStack
                }
            }
             
            Group{
                Section(header: Text("Country Name")){
                    HStack {
                        TextField("Enter Country Name", text: $country)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                        // Button to clear the text field
                        Button(action: {
                            self.country = ""
                        }) {
                            Image(systemName: "multiply.square")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }   // End of HStack
                }
            }
        
    }   // End of Form
        .alert(isPresented: $showContactAddedAlert, content: { self.contactAddedAlert })
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .autocapitalization(.words)
        .disableAutocorrection(true)
        .font(.system(size: 14))
        .navigationBarTitle(Text("New Contact"), displayMode: .inline)
        .navigationBarItems(trailing:
                                Button(action: {
                                    self.saveNewContact()
                                    self.showContactAddedAlert = true
                                }) {
                                    Image(systemName: "plus")
                                })
        
        .sheet(isPresented: self.$showImagePicker) {
            /*
             🔴 We pass $showImagePicker and $photoImageData with $ sign into PhotoCaptureView
             so that PhotoCaptureView can change them. The @Binding keywork in PhotoCaptureView
             indicates that the input parameter is passed by reference and is changeable (mutable).
             */
            PhotoCaptureView(showImagePicker: self.$showImagePicker,
                             photoImageData: self.$photoImageData,
                             cameraOrLibrary: self.photoTakeOrPickChoices[self.photoTakeOrPickIndex])
        }
        
    }   // End of body
    
    var photoImage: Image {
        
        if let imageData = self.photoImageData {
            // The public function is given in UtilityFunctions.swift
            let imageView = getImageFromBinaryData(binaryData: imageData, defaultFilename: "DefaultContactPhoto")
            return imageView
        } else {
            return Image("DefaultContactPhoto")
        }
    }
    
    /*
     ------------------------
     MARK: - Contact Added Alert
     ------------------------
     */
    var contactAddedAlert: Alert {
        Alert(title: Text("Contact Added!"),
              message: Text("New contact is added to your contacts list."),
              dismissButton: .default(Text("OK")) {
                // Dismiss this View and go back
                self.presentationMode.wrappedValue.dismiss()
              })
    }
    
    func saveNewContact(){
        
        
        let newContact = savePhoto(firstName: firstName, lastName: lastName, company: company, phone: phone, email: email, addressLine1: address1, addressLine2: address2, addressCity: city, addressState: state, addressZipcode: zipCode, addressCountry: country)
        
        userData.contactsStructList.append(newContact)
        contactPhotoStructList = userData.contactsStructList
        
        let newContactAttributesForSearch = "\(newContact.id)|\(newContact.firstName)|\(newContact.lastName)|\(newContact.company)|\(newContact.addressLine1)|\(newContact.addressCity)|\(newContact.addressState)|\(newContact.addressCountry)"
        
        userData.searchableOrderedContactsList.append(newContactAttributesForSearch)
        orderedSearchableContactsList = userData.searchableOrderedContactsList
        
        self.presentationMode.wrappedValue.dismiss()
    }
}
