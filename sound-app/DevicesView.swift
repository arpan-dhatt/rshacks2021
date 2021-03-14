//
//  DevicesView.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case infoSheet, newSound, newDevice
    
    var id: Int {
        hashValue
    }
}

struct DevicesView: View {
    
    @EnvironmentObject var recorderState: RecordingStateObject
    
    @State var activeSheet: ActiveSheet?
    
    @AppStorage("group_id") var group_id = "NONE"
    
    var body: some View {
        NavigationView{
            ScrollView{
                DeviceListView(query: devices_Query(group_id: group_id))
                
                HStack{
                    Button(action: {
                        withAnimation{
                            activeSheet = .newSound
                            recorderState.initializeConnection()
                        }
                        
                    }, label: {
                        HStack{
                            Text("New Sound")
                            Image(systemName: "waveform.path.badge.plus").font(.title)
                        }.padding(7.5).background(Color.black).cornerRadius(25.0).foregroundColor(.white)
                    })
                    Button(action: {
                        withAnimation{
                            activeSheet = .newDevice
                        }
                    }, label: {
                        HStack{
                            Text("New Device")
                            Image(systemName: "apps.iphone.badge.plus").font(.title)
                        }.padding(7.5).background(Color.black).cornerRadius(25.0).foregroundColor(.white)
                    })
                }
                
            }.navigationBarTitle("Devices")
            .sheet(item: $activeSheet, onDismiss: {
//                recorderState.SESSION_CANCEL()
                print("cancelled session if it was active")
            }, content: { item in
                switch item {
                case .infoSheet:
                    GroupInfoModal()
                case .newSound:
                    RecorderView(presenting: $activeSheet)
                case .newDevice:
                    NewDeviceView()
                }
                
            })
        }
    }
}

struct DevicePageView: View {
    var device: Device
    
    @AppStorage("group_id") var group_id = "NONE"
    
    var body: some View{
        ScrollView{
            HStack(alignment: .top){
                VStack(alignment: .leading){
                TitleViewBold(input: device.name)
                SubtitleViewLight(input: device.purpose)
                ParagraphView(input: device.location)
                }
                Spacer()
            }.padding()
            
            HStack{
                TitleViewBold(input: "Alerts From This Device")
                Spacer()
            }.padding()
            
            SoundListView(query: activity_Query.init(group_id: group_id, device_id: device.id, category: nil))
            
        }
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView()
    }
}
