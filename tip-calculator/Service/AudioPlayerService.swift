//
//  AudioPlayerService.swift
//  tip-calculator
//
//  Created by trungnghia on 30/06/2023.
//

import Foundation
import AVFoundation

protocol AudioPlayerService {
    func playSound()
}

final class DefaultAudioPlayer: AudioPlayerService {

    private var player: AVAudioPlayer?

    func playSound() {
        guard let path = Bundle.main.path(forResource: "click", ofType: "m4a"),
              let url = URL(string: path)
        else { return }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
