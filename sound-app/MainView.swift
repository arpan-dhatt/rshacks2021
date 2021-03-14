//
//  MainView.swift
//  sound-app
//
//  Created by SaakethC on 3/13/21.
//

import SwiftUI

enum MainPageEnum {
    case onboarding
    case app
}

struct MainView: View {
    
    @AppStorage("completed_setup") var completed_setup: Bool = false
    
    var body: some View {
        if !completed_setup {
            OnboardingView().environmentObject(OnboardingFirstTimeData())
        }
        else {
            TabView {
                ActivityView()
                    .tabItem { Label("Activity", systemImage: "list.dash") }
                DevicesView()
                    .tabItem { Label("Devices", systemImage: "server.rack") }
                BrowseView()
                    .tabItem { Label("Browse", systemImage: "cart") }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
