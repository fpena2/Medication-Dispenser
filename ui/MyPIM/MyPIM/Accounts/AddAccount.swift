//
//  AddAccount.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//

import SwiftUI

struct addAccount: View {
    
    // Subscribe to changes in UserData
    @EnvironmentObject var userData: UserData
    
    /*
     Display this view as a Modal View and enable it to dismiss itself
     to go back to the previous view in the navigation hierarchy.
     */
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showPassword = false
    
    let accountCategories = ["Bank", "Computer", "CreditCard", "Other", "Email", "Membership", "Shopping"]
    
    @State private var selectedIndex = 3    // Shopping
    
    
    @State private var accountTitle = ""
    @State private var accountNotes = "Enter notes here"
    @State private var accountUrl = ""
    @State private var accountUsername = ""
    @State private var accountPassword = ""
    
    // Alerts
    @State private var showAccountAddedAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Select Account Category")) {
                Picker("", selection: $selectedIndex) {
                    ForEach(0 ..< accountCategories.count, id: \.self) {
                        Text(self.accountCategories[$0])
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
            
            Section(header: Text("Account Title")) {
                HStack {
                    TextField("Enter Account Title", text: $accountTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    
                    Button(action: {
                        self.accountTitle = ""
                    }) {
                        Image(systemName: "clear")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                    }
                }
                .frame(minWidth: 300, maxWidth: 500)  // End of HStack
            }
            
            Section(header: Text("Account URL")) {
                HStack {
                    TextField("Enter Account Title", text: $accountUrl)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    
                    Button(action: {
                        self.accountUrl = ""
                    }) {
                        Image(systemName: "clear")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                    }
                }
                .frame(minWidth: 300, maxWidth: 500)  // End of HStack
            }
            
            Section(header: Text("Account Username")) {
                HStack {
                    TextField("Enter Account Username", text: $accountUsername)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    
                    Button(action: {
                        self.accountUsername = ""
                    }) {
                        Image(systemName: "clear")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                    }
                }
                .frame(minWidth: 300, maxWidth: 500)  // End of HStack
            }
            
            Section(header: Text("Account Password")) {
                HStack {
                    if self.showPassword {
                        TextField("Enter Account Title", text: $accountPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        SecureField("Enter Account Title", text: $accountPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    
                    
                    Button(action: {
                        self.showPassword.toggle()
                    }) {
                        Image(systemName: self.showPassword ? "eye" : "eye.fill")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                    }
                }
                .frame(minWidth: 300, maxWidth: 500)  // End of HStack
            }
            
            Section(header: Text("Account Notes")) {
                TextEditor(text: $accountNotes)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(.words)
                    .frame(width: 300.0, height: 72.0).padding()
                
            }
            
            
        }   // End of Form
        .font(.system(size: 14))
        .alert(isPresented: $showAccountAddedAlert, content: { self.accountAddedAlert })
        .navigationBarTitle(Text("New Account"), displayMode: .inline)
        // Place the Add (+) button on right of the navigation bar
        .navigationBarItems(trailing:
                                Button(action: {
                                    self.addNewAccount()
                                    self.showAccountAddedAlert = true
                                }
                                ) {
                                    Image(systemName: "plus")
    })
    
}   // End of body


/*
 ----------------------------------
 MARK: - New Account Added Alert
 ----------------------------------
 */
var accountAddedAlert: Alert {
    Alert(title: Text("Account Added!"),
          message: Text("New account is added to your accounts list."),
          dismissButton: .default(Text("OK")) {
            
            // Dismiss this Modal View and go back to the previous view in the navigation hierarchy
            self.presentationMode.wrappedValue.dismiss()
          })
}


/*
 --------------------------
 MARK: - Add New Account
 --------------------------
 */
func addNewAccount() {
    
    // Create a new instance of account struct and dress it up
    let newAccount = Account(id: UUID(), title: self.accountTitle, category: self.accountCategories[selectedIndex], url: self.accountUrl, username: self.accountUsername, password: self.accountPassword, notes: self.accountNotes)
    
    
    // Append the new account to the list
    userData.accounts.append(newAccount)
    
    // Set the global variable point to the changed list
    accountStructList = userData.accounts
    
    
    // Dismiss this View and go back
    self.presentationMode.wrappedValue.dismiss()
}

}

struct addAcount_Previews: PreviewProvider {
    static var previews: some View {
        addAccount()
    }
}

