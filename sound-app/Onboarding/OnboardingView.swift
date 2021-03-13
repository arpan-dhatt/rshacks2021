//
//  OnboardingView.swift
//  sound-app
//
//  Created by SaakethC on 3/13/21.
//

import SwiftUI

enum OnboardingViewEnum {
    case intro
    case firstTime
    case joinGroup
}

struct OnboardingView: View {
    @State private var currentOnboardingView: OnboardingViewEnum = .intro
    
    var body: some View {
        if currentOnboardingView == .intro {
            OnboardingIntroView(currentOnboardingView: $currentOnboardingView).animation(.easeInOut)
        }
        if currentOnboardingView == .firstTime {
            OnboardingFirstTimeView(currentOnboardingView: $currentOnboardingView).animation(.easeInOut)
        }
        if currentOnboardingView == .joinGroup {
            ContentView().animation(.easeInOut)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
