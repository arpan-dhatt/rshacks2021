//
//  RecorderBegin.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI

struct RecorderView: View {
    @StateObject var dataSource = DeviceListDataSource()
    @StateObject var recorderState = RecordingStateObject()
    @Binding var isPresented: Bool
    
    @State private var showingNextView = false
    
    @State private var selectedDevice = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "mic.circle").resizable().scaledToFit().padding(.horizontal, 50)
                TitleViewBold(input: "Select Device to Record From").multilineTextAlignment(.center)
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
                    //next in recorder
                    showingNextView = true
                }, label: {
                    HStack{
                        SubtitleView(input: "Continue")
                        Image(systemName: "arrow.right").font(.title)
                    }.padding(25).background(selectedDevice == "" ? Color.gray : Color.black).cornerRadius(50.0).foregroundColor(.white).shadow(radius: 10.0)
                }).padding().disabled(selectedDevice == "")
                NavigationLink(
                    destination: RecorderMainPage(isPresented: $isPresented).environmentObject(recorderState).navigationBarBackButtonHidden(true),
                    isActive: $showingNextView,
                    label: {
                        EmptyView()
                    })
            }.navigationBarTitle("Create Sound").onAppear(perform: {
                dataSource.loadFake()
            }).navigationBarBackButtonHidden(true)
        }
    }
}

struct RecorderView_Previews: PreviewProvider {
    static var previews: some View {
        RecorderView(isPresented: .constant(false))
    }
}
