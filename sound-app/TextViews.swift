//
//  TextViews.swift
//  sound-app
//
//  Created by SaakethC on 3/13/21.
//

import SwiftUI

//Titel Views
struct TitleView: View {
    var input: String
    var body: some View {
        Text(input).font(.title)
    }
}
struct TitleViewBold: View {
    var input: String
    var body: some View {
        Text(input).font(.title).fontWeight(.bold)
    } 
}
struct TitleViewLight: View {
    var input: String
    var body: some View {
        Text(input).font(.title).fontWeight(.light)
    }
}

//SubTitle Views
struct SubtitleView: View {
    var input: String
    var body: some View {
        Text(input).font(.title2)
    }
}
struct SubtitleViewBold: View {
    var input: String
    var body: some View {
        Text(input).font(.title2).fontWeight(.bold)
    }
}
struct SubtitleViewLight: View {
    var input: String
    var body: some View {
        Text(input).font(.title2).fontWeight(.light)
    }
}

//Paragraph Text
struct ParagraphView: View {
    var input: String
    var body: some View {
        Text(input).font(.headline).fontWeight(.light)
    }
}
struct ParagraphViewBold: View {
    var input: String
    var body: some View {
        Text(input).font(.headline)
    }
}


struct TextViews_Previews: PreviewProvider {
    static var previews: some View {
        ParagraphViewBold(input: "Hello")
    }
}
