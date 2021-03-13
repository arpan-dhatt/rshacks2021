//
//  OnboardingView.swift
//  sound-app
//
//  Created by SaakethC on 3/13/21.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        if viewModel.OnboardingPage == "Intro"{
            OnboardingIntroView()
        }
        if viewModel.OnboardingPage == "First-Time"{
            ContentView()
        }
        if viewModel.OnboardingPage == "Join-Existing"{
            ContentView()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView().environmentObject(ViewModel())
    }
}
