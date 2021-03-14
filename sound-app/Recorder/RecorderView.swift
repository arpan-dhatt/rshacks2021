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
    @AppStorage("group_id") var group_id = "NONE"
    @Binding var presenting: ActiveSheet?
    
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
                    // tell server to prime a device
                    recorderState.SESSION_BEGIN_OutboundF(data: SESSION_BEGIN_Outbound(group_id: group_id, device_id: recorderState.device_in_use!.id))
                    print("waiting for server")
                    //next in recorder doesn't start until session status has returned from server
//                    showingNextView = true
                }, label: {
                    HStack{
                        SubtitleView(input: "Continue")
                        Image(systemName: "arrow.right").font(.title)
                    }.padding(20).background(selectedDevice == "" ? Color.gray : Color.green).cornerRadius(50.0).foregroundColor(.white).shadow(radius: 10.0)
                }).padding().disabled(selectedDevice == "")
                NavigationLink(
                    destination: RecorderMainPage(presenting: $presenting).environmentObject(recorderState).navigationBarBackButtonHidden(true),
                    isActive: $showingNextView,
                    label: {
                        EmptyView()
                    })
            }.navigationBarTitle("Add Sound").onAppear(perform: {
                dataSource.loadFake(query: devices_Query(group_id: group_id))
            }).navigationBarBackButtonHidden(true).onChange(of: recorderState.session_status, perform: { value in
                // when server says it's ok, change state
                if recorderState.session_status == "ready" {
                    self.showingNextView = true
                }
            })
        }
    }
}

struct RecorderView_Previews: PreviewProvider {
    static var previews: some View {
        RecorderView(presenting: .constant(.newSound))
    }
}
