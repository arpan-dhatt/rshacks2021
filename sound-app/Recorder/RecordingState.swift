//
//  RecordingState.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI

class RecordingStateObject: ObservableObject {
    @Published var device_in_use: Device?
    @Published var recordings = [Record]()
    @Published var sound_name: String?
    @Published var sound_category: String?
    @Published var use_devices: [Device]?
    
    @Published var session_status: String?
    @Published var recording_status: String?
    
    func loadFake() {
        recordings = [
            Record(id: "a", url: "https://github.com/JimLynchCodes/Game-Sound-Effects/raw/master/Sounds/badBoing.wav", waveFormBuffer: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]),
            Record(id: "b", url: "https://github.com/JimLynchCodes/Game-Sound-Effects/raw/master/Sounds/badBoing.wav", waveFormBuffer: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]),
            Record(id: "c", url: "https://github.com/JimLynchCodes/Game-Sound-Effects/raw/master/Sounds/badBoing.wav", waveFormBuffer: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]),
            Record(id: "d", url: "https://github.com/JimLynchCodes/Game-Sound-Effects/raw/master/Sounds/badBoing.wav", waveFormBuffer: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0])
        ]
    }
    
    var socketTask: URLSessionWebSocketTask
    
    init() {
        let url = NetConfig.WS_ROOT
        socketTask = URLSession.shared.webSocketTask(with: URL(string: url)!)
        
        socketTask.resume()
        
        receive()
        print("begun")
    }
    
    private func receive() {
        self.socketTask.receive { [weak self] result in
            print(result)
            guard let self = self else { self?.receive(); return }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let message):
                switch message {
                case .string(let text):
                    self.handleReception(text)
                case .data(let data):
                    print(data)
                }
            }
        }
        receive()
    }
    
    // ALL INBOUND STUFF IS HERE
    func handleReception(_ text: String) {
        let eventname = text.components(separatedBy: "||||")[0]
        print(eventname)
        let eventdata = text.components(separatedBy: "||||")[1].data(using: .ascii)!
        print(eventdata)
        switch eventname {
        case "SESSION_BEGIN_STATUS":
            SESSION_BEGIN_STATUS_InboundF(data: try! JSONDecoder().decode(SESSION_BEGIN_STATUS_Inbound.self, from: eventdata))
        case "ONE_SECOND_RECORD_STATUS":
            ONE_SECOND_RECORD_STATUS_InboundF(data: try! JSONDecoder().decode(ONE_SECOND_RECORD_STATUS_Inbound.self, from: eventdata))
        case "ONE_SECOND_WAV":
            ONE_SECOND_WAV_InboundF(data: try! JSONDecoder().decode(ONE_SECOND_WAV_Inbound.self, from: eventdata))
        default:
            print(eventname)
        }
    }
    
    // receiving functions
    private func SESSION_BEGIN_STATUS_InboundF(data: SESSION_BEGIN_STATUS_Inbound) {
        session_status = data.status
    }
    
    private func ONE_SECOND_RECORD_STATUS_InboundF(data: ONE_SECOND_RECORD_STATUS_Inbound) {
        recording_status = data.status
    }
    
    private func ONE_SECOND_WAV_InboundF(data: ONE_SECOND_WAV_Inbound) {
        let id = String(data.url.split(separator: "/").last!).replacingOccurrences(of: ".wav", with: "")
        recordings.append(
            Record(id: id, url: data.url, waveFormBuffer: data.waveform)
        )
    }
    
    // ALL OUTBOUND STUFF HERE
    func SESSION_BEGIN_OutboundF(data: SESSION_BEGIN_Outbound) {
        let stringified = String(data: try! JSONEncoder().encode(data), encoding: .ascii)!
        let full_string = "SESSION_BEGIN||||\(stringified)"
        print(full_string)
        self.socketTask.send(.string(full_string)) { [weak self] error in
            guard let _ = self else {return}
            if let error = error {
                print(error)
            }
        }
    }
    
    func ONE_SECOND_RECORD_STATUS_OutboundF(data: ONE_SECOND_RECORD_STATUS_Outbound) {
        let stringified = String(data: try! JSONEncoder().encode(data), encoding: .ascii)!
        let full_string = "ONE_SECOND_RECORD_STATUS||||\(stringified)"
        print(full_string)
        self.socketTask.send(.string(full_string)) { [weak self] error in
            guard let _ = self else {return}
            if let error = error {
                print(error)
            }
        }
    }
    
    func ONE_SECOND_DELETE_Outbound(data: ONE_SECOND_DELETE_Outbound) {
        let stringified = String(data: try! JSONEncoder().encode(data), encoding: .ascii)!
        let full_string = "ONE_SECOND_DELETE||||\(stringified)"
        print(full_string)
        self.socketTask.send(.string(full_string)) { [weak self] error in
            guard let _ = self else {return}
            if let error = error {
                print(error)
            }
        }
    }
    
    func SESSION_END_Outbound(data: SESSION_END_Outbound) {
        let stringified = String(data: try! JSONEncoder().encode(data), encoding: .ascii)!
        let full_string = "SESSION_END||||\(stringified)"
        print(full_string)
        self.socketTask.send(.string(full_string)) { [weak self] error in
            guard let _ = self else {return}
            if let error = error {
                print(error)
            }
        }
    }
    
    func SESSION_CANCEL() {
        let full_string = "SESSION_CANCEL||||{}"
        print(full_string)
        self.socketTask.send(.string(full_string)) { [weak self] error in
            guard let _ = self else {return}
            if let error = error {
                print(error)
            }
        }
    }
}
