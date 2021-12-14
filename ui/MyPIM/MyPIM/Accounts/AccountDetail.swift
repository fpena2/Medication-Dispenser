//
//  AccountDetail.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//


import SwiftUI
import MapKit

struct accountDetails: View {
    
    let account: Account
    
    
    var body: some View {
        Form {
            //set up the format.
            Section(header: Text("Account Title")) {
                Text(account.title)
            }
            // get video images.
            Section(header: Text("Category")) {
                HStack {
                    Image(account.category)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100.0)
                    Text("\(account.category) Account")
                }
            }
            if account.url != "" {
                Section(header: Text("Show Account Website")){
                    Link(destination: URL(string: account.url)!) {
                        HStack {
                            Image(systemName: "globe")
                            Text("Show Account Website")
                        }
                    }
                }
            }
            
            Section(header: Text("Account Username")) {
                Text(account.username)
            }
            
            Section(header: Text("Account Password")) {
                Text(account.password)
            }
            
            Section(header: Text("Account Notes")) {
                Text(account.notes)
            }
        }   // End of Form
        .font(.system(size: 14))    // Set font and size for all Text views in the Form
        
    }   // End of body
    
}

struct accountDetails_Previews: PreviewProvider {
    static var previews: some View {
        accountDetails(account: accountStructList[0])
    }
}
