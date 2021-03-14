//
//  OboardingIntroView.swift
//  sound-app
//
//  Created by SaakethC on 3/13/21.
//

import SwiftUI

struct OnboardingIntroView: View {
    
    @Binding var currentOnboardingView: OnboardingViewEnum
    
    @EnvironmentObject var onboardingFirstTime: OnboardingFirstTimeData
    
    var body: some View {
        VStack{
            SubtitleView(input: "Welcome To")
            TitleViewBold(input: "Sound Shot")
            Image(systemName: "hand.point.up.braille").font(.system(size: 150)).padding()
            ParagraphView(input: "Whether it's for a smart home, alarm system, hobby project, or anything else, the power is now in your hands").padding().multilineTextAlignment(.center).padding(.horizontal)
            SubtitleViewBold(input: "Let's Go!").padding()
            
            Button(action: {
                currentOnboardingView = .firstTime
            }, label: {
                HStack{
                    SubtitleView(input: "Setup Your First Device")
                    Image(systemName: "chevron.right")
                }.padding(25.0).background(Color.black).cornerRadius(50.0).foregroundColor(.white).shadow(radius: 10.0)
            }).padding()
            Button(action: {
                currentOnboardingView = .joinGroup
            }, label: {
                HStack{
                    SubtitleView(input: "Join An Existing Group")
                    Image(systemName: "chevron.right")
                }.padding(25).background(Color.black).cornerRadius(50.0).foregroundColor(.white).shadow(radius: 10.0)
            })
        }
    }
}

struct OnboardingIntroView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingIntroView(currentOnboardingView: .constant(.intro))
    }
}
