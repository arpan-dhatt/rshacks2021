//
//  DeviceListDataSource.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI

class DeviceListDataSource: ObservableObject {
    
    @Published var items = [Device]()
    
    private func formURL(_ query: devices_Query) -> URL {
        return URL(string: NetConfig.URL_ROOT+"?group_id=\(query.group_id)")!
    }
    
    func loadData(query: devices_Query) {
        let url = formURL(query)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let response_data = try? JSONDecoder().decode(devices_Response.self, from: data)
            if let json_data = response_data {
                DispatchQueue.main.async {
                    self.items.removeAll()
                    for ri in json_data.devices_list {
                        self.items.append(
                            Device(id: ri.device_id, name: ri.name, activeSounds: [], location: ri.location, purpose: ri.purpose)
                        )
                    }
                }
            }
        }
        task.resume()
    }
}
