//
//  WaveFormPlayer.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI
import AVKit

struct WaveFormPlayer: View {
    
    @State var player: AVPlayer? = AVPlayer(url: URL(string: "https://github.com/JimLynchCodes/Game-Sound-Effects/raw/master/Sounds/Reminder.wav")!)
    
    var waveFormBuffer: [Float] = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
    var waveFormColor: Color = .white
    var waveFormHighlightColor: Color = .blue
    var minusButton: (() -> Void)? = {}
    
    var body: some View {
        GeometryReader { geom in
            HStack {
                Image(systemName: "play.circle.fill").resizable().frame(width: 50, height: 50)
                ForEach(waveFormBuffer, id: \.self) {h in
                    RoundedRectangle(cornerRadius: 25.0)
                        .frame(width: (geom.size.width-100)/CGFloat(waveFormBuffer.count), height: 50*CGFloat(h))
                }
                if let minusButtonClosure = minusButton {
                    Image(systemName: "minus.circle.fill").resizable().frame(width: 50, height: 50).onTapGesture(perform: minusButtonClosure)
                }
            }.background(Color.blue).cornerRadius(20)
        }
    }
}

struct WaveFormPlayer_Previews: PreviewProvider {
    static var previews: some View {
        WaveFormPlayer(player: AVPlayer(url: URL(string: "https://github.com/JimLynchCodes/Game-Sound-Effects/raw/master/Sounds/Reminder.wav")!), minusButton: {print("hi")})
    }
}
