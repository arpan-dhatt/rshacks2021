//
//  DevicesView.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI

struct DevicesView: View {
    var allDevice = [Device.init(id: "One", name: "Arpan", activeSounds: ["Alarm", "Door", "Sibling", "Dog"], location: "Home", purpose: "SmartHome"),Device.init(id: "Two", name: "Samosa", activeSounds: ["Duck"], location: "Work", purpose: "Hobby"), Device.init(id: "Three", name: "Guru", activeSounds: [], location: "Here", purpose: "Other")]
    
    var body: some View {
        NavigationView{
            ScrollView{
                ForEach(allDevice){dev in
                    DeviceCardView(device: dev)
                }
                
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
                // will show and let you copy group id
            }, label: {
                Image(systemName: "person.crop.circle.badge.plus").resizable().frame(width: 40, height: 30).foregroundColor(.black)
            }))
        }
    }
}



struct DeviceCardView: View {
    var device: Device
    
    var body: some View{
        VStack(alignment: .leading){
            HStack{
                Image(systemName: PurposeIcon.getIcon[device.purpose]!).font(.title)
                Spacer()
                Image(systemName: "ellipsis.circle.fill").font(.title)
            }
            HStack(alignment: .top){
                VStack(alignment: .leading){
                    TitleViewBold(input: device.name)
                    SubtitleViewLight(input: device.purpose)
                    ParagraphView(input: device.location)
                }.padding(.trailing)
                
                VStack(alignment:.leading){
                    if device.activeSounds.count == 0{
                        Text("This Device Has No Active Sounds").multilineTextAlignment(.leading)
                    }
                    else if device.activeSounds.count < 4{
                        ParagraphViewBold(input: "Active Sounds:")
                        ForEach(device.activeSounds, id: \.self){
                            Text("- \($0)")
                        }.multilineTextAlignment(.leading)
                        
                    }
                    else{
                        ParagraphViewBold(input: "Active Sounds:")
                        ForEach(0..<3, id: \.self){
                            Text("- \(device.activeSounds[$0])")
                        }.multilineTextAlignment(.leading)
                        HStack{
                            Text("More").bold()
                            Image(systemName: "arrow.right")
                        }
                    }
                }.padding(.leading)
            }
            
        }.padding().frame(height: 175).background(PurposeColors.getColor[device.purpose]!).cornerRadius(10.0).padding(.horizontal).padding(.vertical, 10).shadow(radius: 10).foregroundColor(.white)
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView()
    }
}
