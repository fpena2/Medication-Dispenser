//
//  Settings.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//

import SwiftUI

struct Settings: View {
    
    @State private var showEnteredValues = false
    @State private var passwordEntered = ""
    @State private var passwordVerified = ""
    @State private var showUnmatchedPasswordAlert = false
    @State private var showPasswordSetAlert = false
    @State private var selectedIndex = 5
    @State private var answerEntered = ""
    
    let questionList = ["In what city or town did your mother and father meet?", "In what city or town were you born?", "What did you want to be when you grew up?", "What do you remember most from your childhood?", "What is the name of the boy or girl that you first kissed?", "What is the name of the first school you attended?", "What is the name of your favorite childhood friend?", "What is the name of your first pet?", "What is your mother's maiden name?", "What was your favorite place to visit as a child?"]
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
                
                Form {
                    Section(header: Text("SHOW / HIDE ENTERED VALUES")) {
                        Toggle(isOn: $showEnteredValues) {
                            Text("Show Entered Values")
                        }
                    }
                    Section(header: Text("SECURITY QUESTION")) {
                        Picker("Selected:", selection: $selectedIndex) {
                            ForEach(0 ..< questionList.count, id: \.self) {
                                Text(questionList[$0])
                            }
                        }
                        .frame(minWidth: 300, maxWidth: 500)
                    }
                    
                    
                    Section(header: Text("ENTER ANSWER TO SELECTED SECURITY QUESTION")) {
                        if self.showEnteredValues {
                            HStack {
                                TextField("Enter Answer", text: $answerEntered)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .disableAutocorrection(true)
                                
                                // Button to clear the text field
                                Button(action: {
                                    self.answerEntered = ""
                                }) {
                                    Image(systemName: "clear")
                                        .imageScale(.medium)
                                        .font(Font.title.weight(.regular))
                                }
                            }// End of HStack
                            .frame(minWidth: 300, maxWidth: 500)
                        }
                        
                        else {
                            HStack {
                                SecureField("Enter Answer", text: $answerEntered)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .disableAutocorrection(true)
                                
                                // Button to clear the text field
                                Button(action: {
                                    self.answerEntered = ""
                                }) {
                                    Image(systemName: "clear")
                                        .imageScale(.medium)
                                        .font(Font.title.weight(.regular))
                                }
                            }// End of HStack
                            .frame(minWidth: 300, maxWidth: 500)
                        }
                        
                    }
                    
                    Section(header: Text("ENTER PASSWORD")) {
                        
                        if self.showEnteredValues {
                            HStack {
                                TextField("Enter Password", text: $passwordEntered)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                
                                Button(action: {
                                    self.passwordEntered = ""
                                }) {
                                    Image(systemName: "clear")
                                        .imageScale(.medium)
                                        .font(Font.title.weight(.regular))
                                }
                            }
                            .frame(minWidth: 300, maxWidth: 500)
                        }
                        else {
                            HStack {
                                SecureField("Enter Password", text: $passwordEntered)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                Button(action: {
                                    self.passwordEntered = ""
                                }) {
                                    Image(systemName: "clear")
                                        .imageScale(.medium)
                                        .font(Font.title.weight(.regular))
                                }
                            }
                            .frame(minWidth: 300, maxWidth: 500)
                        }
                    }
                    
                    Section(header: Text("VERIFY PASSWORD")) {
                        HStack {
                            if self.showEnteredValues {
                                TextField("Verify Password", text: $passwordVerified)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                            } else {
                                SecureField("Verify Password", text: $passwordVerified)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            Button(action: {
                                self.passwordVerified = ""
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }
                        .frame(minWidth: 300, maxWidth: 500)
                    }
                    
                    Section(header: Text("SET PASSWORD")) {
                        Button(action: {
                            if !passwordEntered.isEmpty {
                                if passwordEntered == passwordVerified {
                                    /*
                                     UserDefaults provides an interface to the user’s defaults database,
                                     where you store key-value pairs persistently across launches of your app.
                                     */
                                    // Store the password in the user’s defaults database under the key "Password"
                                    UserDefaults.standard.set(self.passwordEntered, forKey: "Password")
                                    
                                    UserDefaults.standard.set(self.answerEntered, forKey: "Answer")
                                    
                                    UserDefaults.standard.set(questionList[selectedIndex], forKey: "questionChoose")
                                    
                                    self.passwordEntered = ""
                                    self.passwordVerified = ""
                                    self.answerEntered = ""
                                    self.selectedIndex = 4
                                    self.showEnteredValues = false
                                    
                                    self.showPasswordSetAlert = true
                                } else {
                                    self.showUnmatchedPasswordAlert = true
                                }
                            }
                        }) {
                            Text("Set Password to Unlock App")
                                .frame(width: 300, height: 36, alignment: .center)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color.black, lineWidth: 1)
                                )
                        }
                        .alert(isPresented: $showUnmatchedPasswordAlert, content: { self.unmatchedPasswordAlert })
                        .alert(isPresented: $showPasswordSetAlert, content: { self.passwordSetAlert })
                    }
                    
                }   // End of Form
                .navigationBarTitle(Text("Settings"), displayMode: .inline)
                
            }
        }
    }   // End of ZStack
    
    /*
     --------------------------
     MARK: - Password Set Alert
     --------------------------
     */
    var passwordSetAlert: Alert {
        Alert(title: Text("Password Set!"),
              message: Text("Password you entered is set to unlock the app!"),
              dismissButton: .default(Text("OK")) )
    }
    
    /*
     --------------------------------
     MARK: - Unmatched Password Alert
     --------------------------------
     */
    var unmatchedPasswordAlert: Alert {
        Alert(title: Text("Unmatched Password!"),
              message: Text("Two entries of the password must match!"),
              dismissButton: .default(Text("OK")) )
    }
}   // End of var




struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
