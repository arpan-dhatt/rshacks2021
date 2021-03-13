//
//  BrowseView.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI

struct BrowseView: View {
    var body: some View {
        VStack {
            Image(systemName: "cart")
                .resizable()
                .padding(100)
                .scaledToFit()
                .foregroundColor(.gray)
            TitleViewBold(input: "Coming Soon")
            ParagraphView(input: "We didn't have the time :(")
        }
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
    }
}
