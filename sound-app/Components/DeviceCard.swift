//
//  DeviceCard.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI

struct DeviceCard: View {
    var device: Device
    
    var body: some View{
        VStack(alignment: .leading){
            HStack{
                Image(systemName: PurposeIcon.getIcon[device.purpose] ?? "flame.fill").font(.title)
                Spacer()
                Image(systemName: "ellipsis.circle.fill").font(.title)
            }
            HStack(alignment: .top){
                HStack{
                VStack(alignment: .leading){
                    TitleViewBold(input: device.name)
                    SubtitleViewLight(input: device.purpose)
                    ParagraphView(input: device.location)
                }
                    Spacer()
                }.frame(width: 150).padding(.trailing)
                
                VStack(alignment:.leading){
                    if device.activeSounds.count == 0{
                        Text("This Device Has No Active Sounds").multilineTextAlignment(.leading)
                    }
                    else if device.activeSounds.count < 4{
                        ParagraphViewBold(input: "Active Sounds:")
                        ForEach(device.activeSounds, id: \.self){
                            Text("- \($0)")
                        }.multilineTextAlignment(.leading)
                        
                    }
                    else{
                        ParagraphViewBold(input: "Active Sounds:")
                        ForEach(0..<3, id: \.self){
                            Text("- \(device.activeSounds[$0])")
                        }.multilineTextAlignment(.leading)
                        HStack{
                            Text("More").bold()
                            Image(systemName: "arrow.right")
                        }
                    }
                }
            }
            
        }.padding().frame(height: 175).background(PurposeColors.getColor[device.purpose]).cornerRadius(10.0).padding(.horizontal).padding(.vertical, 10).shadow(radius: 10).foregroundColor(.white)
    }
}


struct DeviceCard_Previews: PreviewProvider {
    static var previews: some View {
        DeviceCard(device: Device(id: "3452341", name: "Hello", activeSounds: ["Hello"], location: "You", purpose: "Hobby"))
    }
}
