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
                Image(systemName: "mic.circle").font(.system(size: 200, weight: .ultraLight)).padding(.vertical)
                SubtitleViewBold(input: "Select A Device to Record From").multilineTextAlignment(.center).padding(.vertical)
                VStack{
                ScrollView{
                    ForEach(dataSource.items, id: \.id) { device in
                        if selectedDevice == device.name {
                            HStack{
                                ParagraphView(input: device.name).padding(10).frame(width: 200).background(Color.black).cornerRadius(10.0).foregroundColor(.white).shadow(radius: 5).padding(5)
                            }
                        }
                        else {
                            HStack{
                                ParagraphView(input: device.name).padding(10).frame(width: 200).background(Color.white).cornerRadius(10.0).foregroundColor(.black).shadow(radius: 5).padding(5).onTapGesture {
                                withAnimation {
                                    selectedDevice = device.name
                                    recorderState.device_in_use = device
                                }
                            }
                            }
                        }
                    }
                }
                }
                Button(action: {
                    //next in recorder
                    showingNextView = true
                }, label: {
                    HStack{
                        SubtitleView(input: "Continue")
                        Image(systemName: "arrow.right").font(.title)
                    }.padding(20).background(selectedDevice == "" ? Color.gray : Color.green).cornerRadius(50.0).foregroundColor(.white).shadow(radius: 10.0)
                }).padding().disabled(selectedDevice == "")
                NavigationLink(
                    destination: RecorderMainPage(isPresented: $isPresented).environmentObject(recorderState).navigationBarBackButtonHidden(true),
                    isActive: $showingNextView,
                    label: {
                        EmptyView()
                    })
            }.navigationBarTitle("Add Sound").onAppear(perform: {
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
