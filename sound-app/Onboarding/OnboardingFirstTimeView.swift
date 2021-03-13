//
//  OnboardingFirstTimeView.swift
//  sound-app
//
//  Created by SaakethC on 3/13/21.
//

import SwiftUI

struct OnboardingFirstTimeView: View {
    
    @Binding var currentOnboardingView: OnboardingViewEnum
    
    var body: some View {
        VStack{
            Text("Sound Shot").font(.title).fontWeight(.bold).italic().padding()
            HStack{
                Image(systemName: "dot.radiowaves.forward").font(.system(size: 200, weight: .ultraLight)).rotationEffect(.degrees(315)).offset(x:30,y:50)
                Image(systemName: "dot.radiowaves.forward").font(.system(size: 200, weight: .ultraLight)).rotationEffect(.degrees(135)).offset(x:-30,y:-50)
            }.padding()
            TitleViewBold(input: "Linking Your First Device").padding()
            ParagraphView(input: "Unbox your Sound Shot mic and scan the QR code on the top by pressing the button below").padding().padding(.horizontal).multilineTextAlignment(.center)
            Button(action: {
                currentOnboardingView = .firstTime
            }, label: {
                HStack{
                    SubtitleView(input: "Scan QR Code")
                    Image(systemName: "qrcode.viewfinder").font(.title)
                }.padding().background(Color.black).cornerRadius(50.0).foregroundColor(.white).shadow(radius: 10.0)
            }).padding()
            
        }
    }
}

struct OnboardingFirstTimeView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFirstTimeView(currentOnboardingView: .constant(.firstTime))
    }
}
