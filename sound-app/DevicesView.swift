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
                
            }.navigationBarTitle("Devices").navigationBarItems(trailing: Button(action: {
                withAnimation{
                    activeSheet = .infoSheet
                }
            }, label: {
                Image(systemName: "person.crop.circle.badge.plus").resizable().frame(width: 40, height: 34).foregroundColor(.black)
            })).sheet(item: $activeSheet, content: { item in
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
            
            HStack(alignment: .top){
                TitleViewBold(input: "Selected Sounds For This Device:")
                Spacer()
            }.padding()
            
            VStack{
                if device.activeSounds.count != 0{
                    ForEach(device.activeSounds, id: \.self){ dev in
                        HStack{
                            Image(systemName: "waveform.path").font(.title).foregroundColor(PurposeColors.getColorIcon[device.purpose])
                            SubtitleView(input:dev)
                            Spacer()
                        }
                    }
                }
                else {
                    HStack(alignment: .top){
                        SubtitleView(input: "It seems that there are no sounds selected for this device :(")
                        Spacer()
                    }
                }
                
            }.padding().background(Color.white).cornerRadius(10.0).shadow(radius: 5.0).padding()
            
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
