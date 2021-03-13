//
//  BrowseView.swift
//  sound-app
//
//  Created by SaakethC on 3/13/21.
//

import SwiftUI

struct BrowseView: View {
    var body: some View {
        VStack {
            Image("cart")
                .resizable()
                .scaledToFit()
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
