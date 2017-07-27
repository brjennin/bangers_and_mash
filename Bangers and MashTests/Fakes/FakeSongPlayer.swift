import Foundation
import AVFoundation
@testable import Bangers_and_Mash

class FakeSongPlayer: SongPlayerProtocol {
    var capturedSongForLoad: Song?
    func load(song: Song) {
        capturedSongForLoad = song
    }

    var capturedCountdownForPlaySong: TimeInterval?
    func playSong(fromCountdown: TimeInterval) {
        capturedCountdownForPlaySong = fromCountdown
    }

    var calledStopSong = false
    func stopSong() {
        calledStopSong = true
    }

    func reset() {
        capturedSongForLoad = nil
        capturedCountdownForPlaySong = nil
        calledStopSong = false
    }
}
