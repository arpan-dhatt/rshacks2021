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
                    Text(sound.name).font(.title)
                    Text("\(sound.device_name) • \(sound.category)")
                }.padding(.vertical)
                Spacer()
                Image(systemName: "hand.thumbsup.fill").resizable().scaledToFit().frame(maxHeight: 30).padding(4)
                Image(systemName: "hand.thumbsdown.fill").resizable().scaledToFit().frame(maxHeight: 30).padding(4)
            }.padding(.horizontal)
            WaveFormPlayer(player: AVPlayer(url: URL(string: sound.wavFileURL)!), waveFormBuffer: sound.waveFormBuffer, waveFormColor: .purple, waveFormHighlightColor: .pink).padding(.bottom, -10)
        }.background(Color.white).clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous)).shadow(radius: 3).scaledToFit()
    }
}

struct SoundCard_Previews: PreviewProvider {
    static var previews: some View {
        SoundCard()
    }
}
