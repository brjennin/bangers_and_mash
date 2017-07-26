import Foundation
import AVFoundation

protocol AVPlayerProviderProtocol {
    func get(url: URL) -> AVPlayer
}

class AVPlayerProvider: AVPlayerProviderProtocol {
    func get(url: URL) -> AVPlayer {
        return AVPlayer(url: url)
    }
}
