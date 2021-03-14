//
//  Model.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI

struct Device: Identifiable {
    var id: String
    var name: String
    var activeSounds: [String]
    var location: String
    var purpose: String
}

struct Sound: Identifiable {
    var id: String
    var name: String
    var device_name: String
    var device_id: String
    var category: String
    var wavFileURL: String
    var waveFormBuffer: [Float]
}

// this can be accessed globally e.g.: PurposeColors.getColor["Emergencies"]
class PurposeColors {
    static var getColor: [String: Color] = [
        "Emergencies": Color.red,
        "Children": Color.pink,
        "Other": Color.gray
    ]
}

// this can be accessed globally e.g.: CategoryColors.getColor["Emergencies"]
class CategoryColors {
    static var getColor: [String: Color] = [
        "Alert": Color.red,
        "Info": Color.green,
        "Other": Color.gray
    ]
}

// data that stores the onboarding processes
class OnboardingFirstTimeData: ObservableObject {
    @Published var new_device_id: String?
    @Published var new_device_name: String?
    @Published var location: String?
    @Published var purpose: String?
    @Published var group_id: String?
}
