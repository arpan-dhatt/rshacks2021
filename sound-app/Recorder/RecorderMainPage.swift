//
//  RecorderMainPage.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI
import AVKit

struct RecorderMainPage: View {
    
    @EnvironmentObject var recorderState: RecordingStateObject
    
    @Binding var presenting: ActiveSheet?
    
    @State private var showingNextView = false
    
    @State private var recordButtonColor: Color = .green
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 5) {
                    ParagraphView(input: "Press the microphone and record the noise you want to train for detection").multilineTextAlignment(.center).padding()
                    Text("Minimum of 8 Recordings Recommended").font(.caption).padding(.bottom)
                    VStack{
                        ScrollView{
                            ForEach(recorderState.recordings, id: \.id) { record in
                                RecordCard(record: record, minusButtonClosure: {
                                    // remove this card
                                    recorderState.recordings.remove(at: recorderState.recordings.firstIndex(where: {rc in
                                        print(rc)
                                        // we need to tell server to get rid of this
                                        if rc.id == record.id {
                                            recorderState.ONE_SECOND_DELETE_Outbound(data: ONE_SECOND_DELETE_Outbound(id: rc.id))
                                        }
                                        // now we delete it client side
                                        return rc.id == record.id
                                    })!)
                                })
                            }
                        }.scaledToFill()
                    }
                }.navigationBarTitle(recorderState.device_in_use?.name ?? "Device Name").navigationBarBackButtonHidden(true)
            }
            HStack(alignment: .center) {
                Button(action: {
                    recorderState.ONE_SECOND_RECORD_STATUS_OutboundF(data: ONE_SECOND_RECORD_STATUS_Outbound(status: "start"))
                }, label: {
                    Image(systemName: "mic.circle").font(.system(size: 85,weight: .ultraLight)).padding(.horizontal, 50).foregroundColor(recordButtonColor)
                })
                
                Button(action: {
                    withAnimation{
                        showingNextView = true
                    }
                }, label: {
                    HStack{
                        SubtitleView(input: "Next")
                        Image(systemName: "arrow.right").font(.title)
                    }.padding(20).background(Color.black).cornerRadius(50.0).foregroundColor(.white).shadow(radius: 10.0)
                }).padding().transition(.slide).padding(.top).disabled(recorderState.recordings.count < 5)
                NavigationLink(
                    destination: RecorderFinalPage(presenting: $presenting).navigationBarBackButtonHidden(true),
                    isActive: $showingNextView,
                    label: {
                        EmptyView()
                    })

            }
        }.onAppear {
            recorderState.loadFake()
        }.onChange(of: recorderState.recording_status, perform: { value in
            // this will change the color of the button depending on the state
            print(recorderState.recording_status)
            switch value {
            case nil:
                recordButtonColor = .green
            case "start":
                recordButtonColor = .gray
            case "started":
                recordButtonColor = .red
            case "complete":
                recordButtonColor = .blue; DispatchQueue.main.async { recordButtonColor = .green }
            default:
                recordButtonColor = .green
            }
        })
    }
}

struct RecorderMainPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecorderMainPage(presenting: .constant(.newSound)).environmentObject(RecordingStateObject())
        }
    }
}
