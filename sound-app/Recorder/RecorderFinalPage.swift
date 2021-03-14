//
//  RecorderFinalPage.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI

struct RecorderFinalPage: View {
    @EnvironmentObject var recorderState: RecordingStateObject
    
    @StateObject var dataSource = DeviceListDataSource()
    
    @State private var sound_name = ""
    @State private var sound_category = "Other"
    @State private var selectedDevice = ""
    
    var allCategories = ["Alert", "Info", "Other"]
    
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
            SubtitleViewLight(input: "Which Devices Should Listen?").padding(.top)
            VStack {
                ForEach(dataSource.items, id: \.id) { device in
                    if selectedDevice == device.name {
                        ParagraphView(input: device.name).padding(8).background(Color.black).foregroundColor(.white)
                    }
                    else {
                        ParagraphView(input: device.name).padding(8).background(Color.white).foregroundColor(.black).onTapGesture {
                            withAnimation {
                                selectedDevice = device.name
                                recorderState.device_in_use = device
                            }
                        }
                    }
                }
            }.scaledToFill()
            Button(action: {
                withAnimation{
                    //todo
                }
            }, label: {
                HStack{
                    SubtitleView(input: "Done")
                    Image(systemName: "checkmark").font(.title)
                }.padding(25).background(Color.black).cornerRadius(50.0).foregroundColor(.white).shadow(radius: 10.0)
            }).padding().transition(.slide).padding(.top)
        }.navigationBarTitle("Almost Done").onAppear {
            dataSource.loadFake()
        }
    }
}

struct RecorderFinalPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecorderFinalPage().environmentObject(RecordingStateObject())
        }
    }
}
