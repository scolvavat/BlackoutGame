//
//  MusicPlayer.swift
//  Blackout Fight in Detroit
//
//  Created by Michael Marion on 2/18/26.
//

import AVFoundation
internal import Combine

final class MusicPlayer: ObservableObject {
    @Published private(set) var isPlaying: Bool = false
    private var player: AVAudioPlayer?
    private var shouldResumeAfterPause = false

    init() {
        configureAudioSession()
        preparePlayer()
    }

    private func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.ambient, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            print("[MusicPlayer] Audio session error: \(error)")
        }
    }

    private func preparePlayer() {
        guard let url = Bundle.main.url(forResource: "Detroit", withExtension: "wav") else {
            print("[MusicPlayer] detroit.wav not found in bundle")
            return
        }
        
        do {
            let newPlayer = try AVAudioPlayer(contentsOf: url)
            newPlayer.numberOfLoops = -1
            newPlayer.volume = 0.8
            newPlayer.prepareToPlay()
            player = newPlayer
        } catch {
            print("[MusicPlayer] Failed to initialize AVAudioPlayer: \(error)")
        }
    }

    func play() {
        if player == nil {
            preparePlayer()
        }
        
        player?.play()
        isPlaying = player?.isPlaying ?? false
    }

    func pause() {
        player?.pause()
        isPlaying = false
        shouldResumeAfterPause = false
    }

    func toggle() {
        if player?.isPlaying == true {
            pause()
        } else {
            play()
        }
    }
    
    func setPaused(_ paused: Bool) {
        if paused {
            shouldResumeAfterPause = player?.isPlaying == true
            player?.pause()
            isPlaying = false
        } else {
            if shouldResumeAfterPause {
                player?.play()
            }
            isPlaying = player?.isPlaying ?? false
            shouldResumeAfterPause = false
        }
    }
}
