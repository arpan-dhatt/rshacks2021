//
//  OnboardingJoinView.swift
//  sound-app
//
//  Created by SaakethC on 3/13/21.
//

import SwiftUI

struct OnboardingJoinView: View {
    @Binding var currentOnboardingView: OnboardingViewEnum
    
    @EnvironmentObject var onboardingFirstTime: OnboardingFirstTimeData
    
    @AppStorage("group_id") var group_id: String = "NONE"
    @AppStorage("completed_setup") var completed_setup: Bool = false
    
    var body: some View {
        VStack{
            Text("Sound Shot").font(.title).fontWeight(.bold).italic().padding()
            HStack{
                Image(systemName: "person.circle.fill").font(.system(size: 125, weight: .ultraLight)).foregroundColor(.pink)
                Image(systemName: "arrow.left.and.right").font(.system(size: 50, weight: .ultraLight))
                Image(systemName: "person.circle.fill").font(.system(size: 125, weight: .ultraLight)).foregroundColor(.blue)
            }.padding()
            TitleViewBold(input: "Connect To An Existing Group").padding().multilineTextAlignment(.center)
            ParagraphView(input: "Get a group code from any device that has already been added by pressing the person icon at the top of the home page").padding().padding(.horizontal).multilineTextAlignment(.center)
            TextField("Code", text: $group_id).padding().overlay(RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 2)).padding().padding(.horizontal, 20)
            
            Button(action: {
                withAnimation{
//                    currentOnboardingView = .fistTimeConfigure
                    completed_setup = true
                }
            }, label: {
                HStack{
                    SubtitleView(input: "Continue")
                    Image(systemName: "arrow.right").font(.title)
                }.padding(25).background(Color.black).cornerRadius(50.0).foregroundColor(.white).shadow(radius: 10.0)
            }).padding().transition(.slide)
            
        }
    }
}

struct OnboardingJoinView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingJoinView(currentOnboardingView: .constant(.joinGroup))
    }
}
