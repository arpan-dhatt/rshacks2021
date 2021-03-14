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
    
    @AppStorage("group_id") var group_id: String = "NONE"
    @AppStorage("completed_setup") var completed_setup: Bool = false
    
    var body: some View {
        VStack{
            SubtitleView(input: "Welcome To")
            TitleViewBold(input: "SoundFish")
            Image(systemName: "hand.point.up.braille").font(.system(size: 150)).padding()
            ParagraphView(input: "Whether it's for a smart home, alarm system, hobby project, or anything else, the power is now in your hands").padding().multilineTextAlignment(.center).padding(.horizontal)
            SubtitleViewBold(input: "Let's Go!").padding()
            
            Button(action: {
                group_id = "603ab39538f5f248646f2d32"
                completed_setup = true
            }, label: {
                HStack{
                    SubtitleView(input: "Continue")
                    Image(systemName: "chevron.right")
                }.padding(20.0).background(Color.black).cornerRadius(50.0).foregroundColor(.white).shadow(radius: 10.0)
            }).padding()
        }
    }
}

struct OnboardingIntroView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingIntroView(currentOnboardingView: .constant(.intro))
    }
}
