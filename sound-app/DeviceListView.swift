//
//  DeviceListView.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI

struct DeviceListView: View {
    
    @StateObject var dataSource = DeviceListDataSource()
    @AppStorage("group_id") var group_id = "NONE"
    
    // query is a struct which's data will be sent to server when dataSource.loadData(query) is called
    var query: devices_Query
    
    var body: some View {
        VStack {
            ForEach(dataSource.items, id: \.id) { device in
                NavigationLink(destination: DevicePageView(device: device)){
                    DeviceCard(device: device)
                }
            }
        }.onAppear(perform: {
            self.dataSource.loadFake(query: devices_Query(group_id: group_id))
        })
    }
}

struct DeviceListView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceListView(query: devices_Query(group_id: "q4kjrlqwerkljwelkjr"))
    }
}
