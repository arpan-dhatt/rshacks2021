//
//  DevicesView.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI

struct DevicesView: View {
    @State var showingInfoSheet = false
    
    var body: some View {
        NavigationView{
            ScrollView{
                DeviceListView(query: devices_Query(group_id: "afkjlsdkj23lkj2lkj23"))
                
                HStack{
                    Button(action: {
                        withAnimation{
                            
                        }
                        
                    }, label: {
                        HStack{
                            Text("New Sound")
                            Image(systemName: "waveform.path.badge.plus").font(.title)
                        }.padding(7.5).background(Color.black).cornerRadius(25.0).foregroundColor(.white)
                    })
                    Button(action: {
                        withAnimation{
                            
                        }
                    }, label: {
                        HStack{
                            Text("New Device")
                            Image(systemName: "apps.iphone.badge.plus").font(.title)
                        }.padding(7.5).background(Color.black).cornerRadius(25.0).foregroundColor(.white)
                    })
                }
                
            }.navigationBarTitle("Activity").navigationBarItems(trailing: Button(action: {
                withAnimation{
                    showingInfoSheet.toggle()
                }
            }, label: {
                Image(systemName: "person.crop.circle.badge.plus").resizable().frame(width: 40, height: 30).foregroundColor(.black)
            })).sheet(isPresented: $showingInfoSheet, content: {
                GroupInfoModal()
            })
        }
    }
}

struct DevicePageView: View {
    var device: Device
    var currentQuery = activity_Query.init(group_id: "4353j4lk5j34lkj5lk34j5", device_id: nil, category: nil)
    
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
                            Image(systemName: "waveform.path").font(.title).foregroundColor(PurposeColors.getColor[device.purpose])
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
            
            SoundListView(query: activity_Query.init(group_id: "4353j4lk5j34lkj5lk34j5", device_id: device.id, category: nil))
            
        }
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView()
    }
}
