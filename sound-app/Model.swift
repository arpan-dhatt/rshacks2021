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

struct Record: Identifiable {
    var id: String
    var url: String
    var waveFormBuffer: [Float]
}

// this can be accessed globally e.g.: PurposeColors.getColor["Emergencies"]
class PurposeColors {
    static var getColor: [String: LinearGradient] = [
        "All": LinearGradient(gradient: Gradient(colors: [Color("PinkTop"),Color("PinkBottom")]), startPoint: .top, endPoint: .bottom),
        "Hobby": LinearGradient(gradient: Gradient(colors: [Color("BlueTop"),Color("BlueBottom")]), startPoint: .top, endPoint: .bottom),
        "SmartHome": LinearGradient(gradient: Gradient(colors: [Color("GreenTop"),Color("GreenBottom")]), startPoint: .top, endPoint: .bottom),
        "Security": LinearGradient(gradient: Gradient(colors: [Color("RedTop"),Color("RedBottom")]), startPoint: .top, endPoint: .bottom),
        "Children": LinearGradient(gradient: Gradient(colors: [Color("OrangeTop"), Color("OrangeBottom")]), startPoint: .top, endPoint: .bottom),
        "Other": LinearGradient(gradient: Gradient(colors: [Color("GrayTop"),Color("GrayBottom")]), startPoint: .top, endPoint: .bottom)
    ]
    static var getColorIcon: [String: Color] = [
        "All": Color("PinkTop"),
        "Hobby": Color("BlueTop"),
        "SmartHome": Color("GreenTop"),
        "Security": Color("RedTop"),
        "Children": Color("OrangeTop"),
        "Other": Color("GrayTop")
    ]
}


class PurposeIcon {
    static var getIcon: [String: String] = [
        "All": "infinity",
        "Hobby": "giftcard",
        "SmartHome": "homekit",
        "Security": "lock.fill",
        "Children": "ladybug.fill",
        "Other": "ellipsis.circle.fill"
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
