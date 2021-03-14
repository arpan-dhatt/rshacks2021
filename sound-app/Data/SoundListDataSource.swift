//
//  SoundListDataSource.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI


class SoundListDataSource: ObservableObject {
    
    @Published var items = [Sound]()
    
    private func formURL(_ query: activity_Query) -> URL {
        return URL(string: NetConfig.URL_ROOT+"?group_id=\(query.group_id)&device_id=\(query.device_id ?? "nil")&category=\(query.category ?? "nil")")!
    }
    
    func loadData(query: activity_Query) {
        let url = formURL(query)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let response_data = try? JSONDecoder().decode(activity_Response.self, from: data)
            if let json_data = response_data {
                DispatchQueue.main.async {
                    self.items.removeAll()
                    for ri in json_data.sound_list {
                        self.items.append(
                            Sound(id: ri.id, name: ri.name, device_name: ri.device_name, device_id: ri.device_id, category: ri.category, wavFileURL: ri.wav, waveFormBuffer: ri.waveform)
                        )
                    }
                }
            }
        }
        task.resume()
    }
    
    func loadFake() {
        items = [
            Sound(id: "3lkjlk2j4kl3", name: "Cough", device_name: "Vivek", device_id: "kjljkl23j4lkj", category: "Alert", wavFileURL: "https://github.com/JimLynchCodes/Game-Sound-Effects/raw/master/Sounds/Reminder.wav", waveFormBuffer: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]),
            Sound(id: "3lkjlk2j4kl33lkjlk2j4kl3", name: "Sneeze", device_name: "Arpan", device_id: "kjljkl23j4lkj", category: "Info", wavFileURL: "https://github.com/JimLynchCodes/Game-Sound-Effects/raw/master/Sounds/VOLTAGE.WAV", waveFormBuffer: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]),
            Sound(id: "3lkjlk2j4kl33lkjlk2j4kl33lkjlk2j4kl3", name: "Vomit", device_name: "Saaketh", device_id: "kjljkl23j4lkj", category: "Other", wavFileURL: "https://github.com/JimLynchCodes/Game-Sound-Effects/raw/master/Sounds/boodoodaloop.wav", waveFormBuffer: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]),
        ]
    }
}
