//
//  OnboardingFirstTimeView.swift
//  sound-app
//
//  Created by SaakethC on 3/13/21.
//

import SwiftUI

struct OnboardingFirstTimeView: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        ZStack{
            VStack{
                SubtitleViewLight(input: "Sound Shot").padding()
                HStack{
                    Image(systemName: "dot.radiowaves.forward").font(.system(size: 200)).rotationEffect(.degrees(315)).offset(x:30,y:60)
                    Image(systemName: "dot.radiowaves.forward").font(.system(size: 200)).rotationEffect(.degrees(135)).offset(x:-31,y:-60)
                }.padding()
                TitleViewBold(input: "Linking Your First Device").padding()
            }
        }
    }
}

struct OnboardingFirstTimeView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFirstTimeView().environmentObject(ViewModel())
    }
}
