//
//  GroupInfoModal.swift
//  sound-app
//
//  Created by SaakethC on 3/13/21.
//

import SwiftUI

struct GroupInfoModal: View {
    @AppStorage("group_id") var group_id: String = "NONE"
    
    var body: some View {
        VStack(alignment: .center){
            TitleView(input: "Want To Add A New User To Your Group?").multilineTextAlignment(.leading).padding(.vertical)
            Image(systemName: "apps.iphone.badge.plus").font(.system(size: 150, weight: .ultraLight)).padding()
            SubtitleView(input: "It's quite simple, use this unique group code when setting up a new user:").multilineTextAlignment(.leading).padding(.vertical)
            TitleViewBold(input: group_id).multilineTextAlignment(.center)
            
        }.padding()
    }
}

struct GroupInfoModal_Previews: PreviewProvider {
    static var previews: some View {
        GroupInfoModal()
    }
}
