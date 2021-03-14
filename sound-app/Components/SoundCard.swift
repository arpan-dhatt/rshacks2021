//
//  SoundCard.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI
import AVKit

struct SoundCard: View {
    
    // these have default values but you can change them at initialization ofc
    var sound: Sound = Sound(id: "asdfasdfasdfasd", name: "Sound", device_name: "Device", device_id: "32423kl4jl23kj4", category: "Category", wavFileURL: "https://github.com/JimLynchCodes/Game-Sound-Effects/raw/master/Sounds/badBoing.wav", waveFormBuffer: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0])
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading){
                    SubtitleView(input: sound.name)
                    ParagraphView(input: "\(sound.device_name) • \(sound.category)")
                }.padding(.top, 10)
                Spacer()
                Image(systemName: "checkmark.circle").resizable().scaledToFit().frame(maxHeight: 30).padding(5)
                Image(systemName: "xmark.circle").resizable().scaledToFit().frame(maxHeight: 30).padding(5)
            }.padding(.horizontal)
            WaveFormPlayer(player: AVPlayer(url: URL(string: sound.wavFileURL)!), waveFormBuffer: sound.waveFormBuffer, waveFormColor: CategoryColors.getColor[sound.category] ?? .blue, waveFormHighlightColor: .white).padding(.bottom, 35)
        }.background(Color.white).cornerRadius(10.0).shadow(radius: 5)
    }
}

struct SoundCard_Previews: PreviewProvider {
    static var previews: some View {
        SoundCard()
    }
}
