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
    case firstTimeConfigure
}

struct OnboardingView: View {
    @State private var currentOnboardingView: OnboardingViewEnum = .intro
    
    @EnvironmentObject var onboardingFirstTime: OnboardingFirstTimeData
    
    var body: some View {
        if currentOnboardingView == .intro {
            OnboardingIntroView(currentOnboardingView: $currentOnboardingView).animation(.easeInOut)
        }
        if currentOnboardingView == .firstTime {
            OnboardingFirstTimeView(currentOnboardingView: $currentOnboardingView).animation(.easeInOut)
        }
        if currentOnboardingView == .joinGroup {
            OnboardingJoinView(currentOnboardingView: $currentOnboardingView).animation(.easeInOut)
        }
        if currentOnboardingView == .firstTimeConfigure {
            OnboardingFirstTimeConfigureView(currentOnboardingView: $currentOnboardingView).animation(.easeInOut)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView().environmentObject(OnboardingFirstTimeData())
    }
}
