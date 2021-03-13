//
//  SoundCard.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI
import AVKit

struct SoundCard: View {
    
    var soundName: String = "Sound"
    var deviceName: String = "Device"
    var category: String = "Category"
    var waveFormBuffer: [Float] = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
    var wavFileURL = URL(string: "https://github.com/JimLynchCodes/Game-Sound-Effects/raw/master/Sounds/Reminder.wav")!
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading){
                    Text(soundName).font(.title)
                    Text("\(deviceName) • \(category)")
                }.padding(.vertical)
                Spacer()
                Image(systemName: "hand.thumbsup.fill").resizable().scaledToFit().frame(maxHeight: 30).padding(4)
                Image(systemName: "hand.thumbsdown.fill").resizable().scaledToFit().frame(maxHeight: 30).padding(4)
            }.padding(.horizontal)
            WaveFormPlayer(player: AVPlayer(url: wavFileURL), waveFormBuffer: waveFormBuffer, waveFormColor: .purple, waveFormHighlightColor: .pink).padding(.bottom, -10)
        }.background(Color.white).clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous)).shadow(radius: 3).scaledToFit()
    }
}

struct SoundCard_Previews: PreviewProvider {
    static var previews: some View {
        SoundCard()
    }
}
