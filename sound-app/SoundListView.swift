//
//  SoundListView.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI


struct SoundListView: View {
    
    @StateObject var dataSource = SoundListDataSource()
    
    var query: activity_Query
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(dataSource.items, id: \.id) { sound in
                    SoundCard(sound: sound).padding(.horizontal).padding(.vertical, 10)
                }
            }.onAppear(perform: {
                //self.dataSource.loadData(query: self.query)
                print(query)
                self.dataSource.loadFake(query: self.query)
            })
        }
        
    }
}

struct SoundListView_Previews: PreviewProvider {
    static var previews: some View {
        SoundListView(query: activity_Query(group_id: "4353j4lk5j34lkj5lk34j5", device_id: nil, category: nil))
    }
}
