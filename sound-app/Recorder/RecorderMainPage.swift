//
//  RecorderMainPage.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI

struct RecorderMainPage: View {
    @EnvironmentObject var recorderState: RecordingStateObject
    
    var body: some View {
        ScrollView {
            VStack {
                ParagraphView(input: "Press the microphone and make the noise you want to train.").multilineTextAlignment(.center).padding()
                Text("Minimum of 8 Recordings required").font(.caption)

            }.navigationBarTitle(recorderState.device_in_use?.name ?? "Device Name").navigationBarBackButtonHidden(true)
        }
    }
}

struct RecorderMainPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecorderMainPage().environmentObject(RecordingStateObject())
        }
    }
}
