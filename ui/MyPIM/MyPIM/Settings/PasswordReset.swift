//
//  PasswordReset.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//

import SwiftUI

struct PasswordReset: View {
    
    @State private var showEnteredValues = false
    @State private var answerEntered = ""
    
    let validPassword = UserDefaults.standard.string(forKey: "Password")
    
    let validAnswer = UserDefaults.standard.string(forKey: "Answer")
    
    let validQuestion = UserDefaults.standard.string(forKey: "questionChoose")
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            
            Form {
                Section(header: Text("SHOW / HIDE ENTERED VALUES")) {
                    Toggle(isOn: $showEnteredValues) {
                        Text("Show Entered Values")
                    }
                }
                Section(header: Text("SECURITY QUESTION")) {
                    Text(validQuestion!)
                }//problem probably
                
                
                if self.showEnteredValues {
                    HStack {
                        TextField("Enter Answer", text: $answerEntered)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {
                            self.answerEntered = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                        
                    }
                    .frame(width: 300, height: 50)
                }
                
                else {
                    HStack {
                        SecureField("Enter Answer", text: $answerEntered)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {
                            self.answerEntered = ""
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }
                    
                }
                
                
                
                if answerEntered == validAnswer {
                    Section(header: Text("Go To Settings to Reset Password")) {
                        NavigationLink(destination: Settings()) {
                            HStack {
                                Image(systemName: "gear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                    .foregroundColor(.blue)
                                Text("Show Settings")
                                    .font(.system(size: 16))
                            }
                        }
                        .frame(minWidth: 300, maxWidth: 500)
                    }
                }
                else {
                    Section(header: Text("INCORRECT ANSWER")) {
                        Text("Answer to the Security Question is incorrect!")
                    }
                }
                
                
            }
            // End of Form
            .navigationBarTitle(Text("Password Reset"), displayMode: .inline)
        }
        
    }   // End of ZStack
    
    
}   // End of body



struct PasswordReset_Previews: PreviewProvider {
    static var previews: some View {
        PasswordReset()
    }
}

