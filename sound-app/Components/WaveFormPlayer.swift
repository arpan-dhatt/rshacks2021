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
    
    //anything already with = in it means that's the default value but you can still change it
    
    // list of 20 floats that will be received from server
    var waveFormBuffer: [Float] = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
    
    @State private var waveFormActivityBuffer: [Bool] = [Bool](repeating: false, count: 20)
    
    // these are the colors you can change, the play-button's color also changes inactive/active when playing audio
    var playerBackgroundColor: Color = .white
    var waveFormColor: Color = .blue
    var waveFormHighlightColor: Color = .white
    
    // minus button appears if this optional closure is filled with something
    var minusButton: (() -> Void)?
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var timerActive: Bool = false
    
    var body: some View {
        GeometryReader { geom in
            HStack(spacing: 0) {
                Image(systemName: timerActive ? "pause.circle.fill" : "play.circle.fill").resizable().padding(3).frame(width: 40, height: 40).foregroundColor(waveFormColor).onTapGesture {
                    player?.play()
                    
                    timerActive = true
                }
                HStack(spacing: 0) {
                    ForEach(0..<waveFormBuffer.count, id: \.self) {i in
                        RoundedRectangle(cornerRadius: 25.0).padding(.horizontal, 3)
                            .frame(width: (geom.size.width-50-(minusButton == nil ? 20 : 50))/CGFloat(waveFormBuffer.count), height: 35*CGFloat(max(waveFormBuffer[i], 0.15)))
                            .foregroundColor(waveFormActivityBuffer[i] ? self.waveFormHighlightColor : self.waveFormColor)
                    }
                }.padding(.vertical, 8).padding(.trailing, minusButton == nil ? 15 : 0)
                if let minusButtonClosure = minusButton {
                    Image(systemName: "minus.circle.fill").resizable().padding(3).frame(width: 40, height: 40).onTapGesture(perform: minusButtonClosure).foregroundColor(.red)
                }
            }.background(playerBackgroundColor).clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous)).frame(width: geom.size.width)
        }.onReceive(timer) {input in
            if timerActive { updateHighlightColor(time: player?.currentItem?.currentTime(), duration: player?.currentItem?.duration) }
        }.animation(.easeIn(duration: 0.25))
    }
    
    func updateHighlightColor(time: CMTime?, duration: CMTime?) {
        if let time = time, let duration = duration {
            if time.seconds < duration.seconds {
                let activeInt = Int(time.seconds / (duration.seconds) * Double(waveFormActivityBuffer.count))
                for i in 0..<waveFormActivityBuffer.count {
                    if i > activeInt && i < activeInt+5 {
                        waveFormActivityBuffer[i] = true
                    } else {
                        waveFormActivityBuffer[i] = false
                    }
                }
            } else {
                timerActive = false
                for i in 0..<waveFormActivityBuffer.count {
                    waveFormActivityBuffer[i] = false
                }
                player?.pause()
                player?.currentItem?.seek(to: .zero, completionHandler: nil)
            }
        }
    }
    
}

struct WaveFormPlayer_Previews: PreviewProvider {
    static var previews: some View {
        WaveFormPlayer(player: AVPlayer(url: URL(string: "https://github.com/JimLynchCodes/Game-Sound-Effects/raw/master/Sounds/Reminder.wav")!))
    }
}
