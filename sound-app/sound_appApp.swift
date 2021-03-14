
  //sound_appApp.swift
 // sound-app

//  Created by Arpan Dhatt on 3/13/21.


import SwiftUI

@main
struct sound_appApp: App {
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(ViewModel()).environmentObject(RecordingStateObject())
        }
    }
}
