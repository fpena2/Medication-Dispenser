//
//  LoginView.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//

import SwiftUI

struct LoginView : View {
    
    // Subscribe to changes in UserData
    @EnvironmentObject var userData: UserData
    
    @State private var enteredPassword = ""
    @State private var showInvalidPasswordAlert = false
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        Image("Welcome")
                            .padding(.top, 30)
                        
                        Text("Pill Delivery Manager")
                            .font(.headline)
                            .padding()
                        
                        Image("DataProtection")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 300, maxWidth: 600)
                            .padding()
                        
                        SecureField("Password", text: $enteredPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 300, height: 36)
                            .padding()
                        
                        HStack {
                            Button(action: {
                                /*
                                 UserDefaults provides an interface to the user’s defaults database,
                                 where you store key-value pairs persistently across launches of your app.
                                 */
                                // Retrieve the password from the user’s defaults database under the key "Password"
                                let validPassword = UserDefaults.standard.string(forKey: "Password")
                                
                                /*
                                 If the user has not yet set a password, validPassword = nil
                                 In this case, allow the user to login.
                                 */
                                
                                if validPassword == nil || self.enteredPassword == validPassword {
                                    userData.userAuthenticated = true
                                    self.showInvalidPasswordAlert = false
                                } else {
                                    self.showInvalidPasswordAlert = true
                                }
                                
                            })
                            {
                                Text("Login")
                                    .frame(width: 100, height: 36, alignment: .center)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color.black, lineWidth: 1)
                                    )
                            }
                            
                            if UserDefaults.standard.string(forKey: "questionChoose") != nil {
                                
                                NavigationLink(destination: PasswordReset()){
                                    Text("Forgot Password")
                                        
                                        .frame(width: 180, height: 36, alignment: .center)
                                        
                                        .background(
                                            
                                            RoundedRectangle(cornerRadius: 16)
                                                
                                                .strokeBorder(Color.black, lineWidth: 1)
                                            
                                        )
                                    
                                }
                                
                                .padding()
                                
                            }
                            
                        } // end of HStack
                        
                        .alert(isPresented: $showInvalidPasswordAlert, content: { self.invalidPasswordAlert })
                        
                    }   // End of VStack
                }   // End of ScrollView
            }
        }   // End of ZStack
    }   // End of var
    
    /*
     ------------------------------
     MARK: - Invalid Password Alert
     ------------------------------
     */
    var invalidPasswordAlert: Alert {
        Alert(title: Text("Invalid Password!"),
              message: Text("Please enter a valid password to unlock the app!"),
              dismissButton: .default(Text("OK")) )
        
        // Tapping OK resets @State var showInvalidPasswordAlert to false.
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
