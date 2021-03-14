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
    }
}
