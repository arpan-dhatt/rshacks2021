//
//  ViewModel.swift
//  sound-app
//
//  Created by SaakethC on 3/13/21.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var OnboardingPage = "Intro"
    @Published var Page = "Onboarding"
}
