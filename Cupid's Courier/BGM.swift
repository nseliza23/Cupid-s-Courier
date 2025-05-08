//
//  BGM.swift
//  Cupid's Courier
//
//  Created by nandana on 5/3/25.
//

import Foundation
import AVFoundation
import SpriteKit

class BGM {
    static let shared = BGM()
        private var player: AVAudioPlayer?

        private init() {}

    func play(_ filename: String, volume: Float = 0.5) {
            if let p = player, p.isPlaying { return }

            guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
                print("BGM: file not found: \(filename)")
                return
            }

            do {
                let p = try AVAudioPlayer(contentsOf: url)
                p.numberOfLoops = -1        // loop infinitely
                p.volume        = volume
                p.prepareToPlay()
                p.play()
                self.player = p
            } catch {
                print("BGM: failed to init player:", error)
            }
        }

        func stop() {
            player?.stop()
            player = nil
        }
}
