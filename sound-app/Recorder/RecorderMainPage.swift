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
    @Binding var isPresented: Bool
    
    @State private var showingNextView = false
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    ParagraphView(input: "Press the microphone and record the noise you want to train for detection").multilineTextAlignment(.center).padding()
                    Text("8 Recordings Reccomended").font(.caption).padding(.bottom)
                    VStack{
                        ScrollView{
                    ForEach(recorderState.recordings, id: \.id) { record in
                        RecordCard(record: record, minusButtonClosure: {
                            // remove this card
                            self.recorderState.recordings.remove(at: self.recorderState.recordings.firstIndex(where: {rc in
                                print(rc)
                                return rc.id == record.id
                            })!)
                        })
                
                    }
                        }
                    }
                }.navigationBarTitle(recorderState.device_in_use?.name ?? "Device Name").navigationBarBackButtonHidden(true)
            }
            HStack(alignment: .center) {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "mic.circle").font(.system(size: 85,weight: .ultraLight)).padding(.horizontal, 50).foregroundColor(.green)
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
                    destination: RecorderFinalPage(isPresented: $isPresented).navigationBarBackButtonHidden(true),
                    isActive: $showingNextView,
                    label: {
                        EmptyView()
                    })

            }
        }.onAppear {
            recorderState.loadFake()
        }
    }
}

struct RecorderMainPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecorderMainPage(isPresented: .constant(true)).environmentObject(RecordingStateObject())
        }
    }
}
