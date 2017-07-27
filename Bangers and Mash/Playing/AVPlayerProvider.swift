import Foundation
import AVFoundation

protocol AVPlayerProviderProtocol {
    func get(url: URL) -> AVPlayer
    func getAudioPlayer(url: URL) -> AVAudioPlayer
}

class AVPlayerProvider: AVPlayerProviderProtocol {
    func get(url: URL) -> AVPlayer {
        return AVPlayer(url: url)
    }

    func getAudioPlayer(url: URL) -> AVAudioPlayer {
        return try! AVAudioPlayer(contentsOf: url)
    }
}
