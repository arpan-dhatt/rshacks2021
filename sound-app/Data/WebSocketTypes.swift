//
//  Types.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import Foundation

// SESSION_BEGIN
struct SESSION_BEGIN_Outbound: Codable {
    var group_id: String
    var device_id: String
}
struct SESSION_BEGIN_STATUS_Inbound: Codable {
    var status: String
}

// ONE_SECOND_RECORD_STATUS
struct ONE_SECOND_RECORD_STATUS_Outbound: Codable {
    var status: String
}
struct ONE_SECOND_RECORD_STATUS_Inbound: Codable {
    var status: String
}

// ONE_SECOND_WAV_URL_STATUS
struct ONE_SECOND_WAV_Inbound: Codable {
    var url: String
    var waveFormBuffer: [Float]
}

// ONE_SECOND_DELETE
struct ONE_SECOND_DELETE_Outbound: Codable {
    var id: String
}

// SESSION_END
struct SESSION_END_Outbound: Codable {
    var name: String
    var category: String
    var device_ids: [String]
}

// SESSION_CANCEL
// empty JSON
