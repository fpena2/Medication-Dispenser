//
//  AccountItem.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//

import SwiftUI

struct accountItem: View {
   
    // Input Parameter
    let account: Account
   
    var body: some View {
        HStack {
            Image(account.category)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
                /*
                You can obtain YouTube thumbnail image with the quality and size you desire:
                    Default:               default.jpg          120x90
                    Medium Quality:        mqdefault.jpg        320x180
                    High Quality:          hqdefault.jpg        480x360
                    Standard Definition:   sddefault.jpg        640x480
                    Maximum Resolution:    maxresdefault.jpg    1280x720
 
                 Thumbnail medium quality (mqdefault.jpg) size: 320x180 -> 16:9 ratio
                 Select frame width and height with 16:9 ratio
                 Do not use high quality size! It leaves black bars on top and bottom.
                 */
                
                //set up the format
                
            VStack(alignment: .leading) {
                Text(account.title)
                Text("\(account.category) Account")
                Text(account.username)
            }
            // Set font and size for the whole VStack content
            .font(.system(size: 14))
        }
    }
}

struct accountItem_Previews: PreviewProvider {
    static var previews: some View {
        accountItem(account: accountStructList[0])
    }
}
