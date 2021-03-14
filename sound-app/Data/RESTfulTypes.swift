//
//  RESTfulTypes.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import Foundation

// POST /create/group
struct create_group_Response: Codable {
    var _id: String
}

// POST create/device
struct create_device_Request: Codable {
    var name: String
    var location: String
    var purpose: String
    var group_id: String
}
struct create_device_Response: Codable {
    var _id: String
}

// POST activity
struct activity_Query: Codable {
    var group_id: String
    var device_id: String?
    var category: String?
}
struct activity_ResponseItem: Codable {
    var id: String
    var name: String
    var device_id: String
    var device_name: String
    var category: String
    var waveform: [Float]
    var wav: String
}
struct activity_Response: Codable {
    var sound_list: [activity_ResponseItem]
}

// POST devices
struct devices_Query: Codable {
    var group_id: String
}
struct devices_ResponseItem: Codable {
    var name: String
    var location: String
    var purpose: String
    var device_id: String
}
struct devices_Response: Codable {
    var devices_list: [devices_ResponseItem]
}
