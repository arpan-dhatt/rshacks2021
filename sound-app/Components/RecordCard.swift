//
//  RecordCard.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI
import AVKit

struct RecordCard: View {
    var record: Record
    var minusButtonClosure: () -> Void
    
    var body: some View {
        
        WaveFormPlayer(audioItem: AVPlayerItem(url: URL(string: record.url)!), waveFormBuffer: record.waveFormBuffer, playerBackgroundColor: .white, waveFormColor: .blue, waveFormHighlightColor: .white, minusButton: minusButtonClosure).frame(height: 50)
       
    }
}

struct RecordCard_Previews: PreviewProvider {
    static var previews: some View {
        RecordCard(record: Record(id: "a", url: "https://github.com/HenrikJoreteg/SoundEffectManager/raw/master/taps.mp3", waveFormBuffer: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]), minusButtonClosure: {})
    }
}
