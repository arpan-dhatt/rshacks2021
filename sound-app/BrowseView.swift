//
//  BrowseView.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI

struct BrowseView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "cart")
                    .resizable()
                    .padding(100)
                    .scaledToFit()
                    .foregroundColor(.gray)
                TitleViewBold(input: "Coming Soon")
                ParagraphView(input: "We didn't have the time :(")
            }.navigationBarTitle("Browse").navigationBarItems(trailing: Button(action: {
                // will show and let you copy group id
            }, label: {
                Image(systemName: "person.crop.circle.badge.plus").resizable().frame(width: 40, height: 34).foregroundColor(.black)
            }))
        }
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
    }
}
