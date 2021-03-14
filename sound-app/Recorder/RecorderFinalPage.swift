//
//  RecorderFinalPage.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI

struct RecorderFinalPage: View {
    @EnvironmentObject var recorderState: RecordingStateObject
    @Binding var presenting: ActiveSheet?
    
    @StateObject var dataSource = DeviceListDataSource()
    
    @AppStorage("group_id") var group_id = "NONE"
    
    @State private var sound_name = ""
    @State private var sound_category = "Other"
    @State private var selectedDevices = ""
    @State private var selectedDeviceId = ""
    
    var allCategories = ["Security","SmartHome","Hobby","Children","Other"]
    
    var body: some View {
        VStack{
            SubtitleViewLight(input: "Name of Sound").padding(.top, 35)
            TextField("name", text: $sound_name).padding().overlay(RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 1.5)).padding(.horizontal, 30)
            SubtitleViewLight(input: "Category of Sound").padding(.top)
            Picker(sound_category, selection: $sound_category) {
                ForEach(allCategories, id: \.self) { purpose in
                    Text(purpose).frame(minWidth: 200)
                }
            }.pickerStyle(MenuPickerStyle()).frame(minWidth: 275).padding().overlay(RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 1.5)).foregroundColor(.black)
            SubtitleViewLight(input: "Which Devices Should Listen For This Sound?").padding()
            VStack {
                ScrollView{
                ForEach(dataSource.items, id: \.id) { device in
                    if selectedDevices == device.name {
                        ParagraphView(input: device.name).padding(10).frame(width: 200).background(Color.black).cornerRadius(10.0).foregroundColor(.white).shadow(radius: 5).padding(5)
                    }
                    else {
                        ParagraphView(input: device.name).padding(10).frame(width: 200).background(Color.white).cornerRadius(10.0).foregroundColor(.black).shadow(radius: 5).padding(5).onTapGesture {
                            withAnimation {
                                selectedDevices = device.name
                            }
                        }
                    }
                }
                }
            }
            Button(action: {
                withAnimation{
                    // tell server all the final information it needs
                    let output = SESSION_END_Outbound(name: sound_name, category: sound_category, device_ids: [selectedDeviceId])
                    recorderState.SESSION_END_Outbound(data: output)
                    presenting = nil
                }
            }, label: {
                HStack{
                    SubtitleView(input: "Add")
                    Image(systemName: "plus").font(.title2)
                }.padding(20).background(Color.black).cornerRadius(50.0).foregroundColor(.white).shadow(radius: 10.0)
            }).padding().transition(.slide).padding(.top)
        }.navigationBarTitle("Almost Done").onAppear {
            dataSource.loadFake(query: devices_Query(group_id: group_id))
        }
    }
}

struct RecorderFinalPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecorderFinalPage(presenting: .constant(.newSound)).environmentObject(RecordingStateObject())
        }
    }
}
