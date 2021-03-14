//
//  Postman.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI

class Postman : ObservableObject {
    static var shared = Postman()
    
    @AppStorage("group_id") var group_id: String = "NONE"
    
    func create_group() {
        let url = URL(string: NetConfig.URL_ROOT+"create/group")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let response_data = try? JSONDecoder().decode(create_group_Response.self, from: data)
            if let json_data = response_data {
                DispatchQueue.main.async {
                    self.group_id = json_data._id
                }
            }
        }
        task.resume()
    }
    
    func create_device(data: create_device_Request) {
        if group_id != "NONE" {
            let url = URL(string: NetConfig.URL_ROOT+"create/device")!
            var request = URLRequest(url: url)
            request.httpBody = try! JSONEncoder().encode(data)
            request.httpMethod = "POST"
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                let response_data = try? JSONDecoder().decode(create_device_Response.self, from: data)
                if let json_data = response_data {
                    print(json_data)
                }
            }
            task.resume()
        }
    }
}
