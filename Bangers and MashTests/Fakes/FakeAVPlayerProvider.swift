import Foundation
import AVFoundation
@testable import Bangers_and_Mash

class FakeAVPlayerProvider: AVPlayerProviderProtocol {
    var capturedUrlForGet: URL?
    var returnedPlayerForGet: AVPlayer!
    func get(url: URL) -> AVPlayer {
        capturedUrlForGet = url

        return returnedPlayerForGet
    }

    var capturedUrlForGetAudioPlayer: URL?
    var returnedPlayerForGetAudioPlayer: AVAudioPlayer!
    func getAudioPlayer(url: URL) -> AVAudioPlayer {
        capturedUrlForGetAudioPlayer = url

        return returnedPlayerForGetAudioPlayer
    }
}
