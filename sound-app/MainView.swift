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
    @State var currentPage: MainPageEnum = .onboarding
    
    var body: some View {
        if currentPage == .onboarding {
            OnboardingView()
        }
        if currentPage == .app {
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
        MainView(currentPage: .app)
    }
}
