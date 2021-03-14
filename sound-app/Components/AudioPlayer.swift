//
//  AudioPlayer.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/14/21.
//

import Foundation
import SwiftUI
import AVKit

class AudioPlayer {
    static var shared = AudioPlayer()
    var player: AVPlayer
    
    var playedBefore = [AVPlayerItem]()
    init() {
        player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
    }
}
