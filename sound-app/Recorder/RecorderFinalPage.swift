//
//  RecorderFinalPage.swift
//  sound-app
//
//  Created by Arpan Dhatt on 2/27/21.
//

import SwiftUI

struct RecorderFinalPage: View {
    @EnvironmentObject var recorderState: RecordingStateObject
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).navigationBarTitle("Almost Done")
    }
}

struct RecorderFinalPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecorderFinalPage().environmentObject(RecordingStateObject())
        }
    }
}
