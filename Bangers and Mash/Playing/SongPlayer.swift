import Foundation
import AVFoundation

protocol SongPlayerProtocol {
    func load(song: Song)
    func playSong(fromCountdown: TimeInterval)
    func stopSong()
}

class SongPlayer: SongPlayerProtocol {
    var scheduler: SchedulerProtocol = Scheduler()
    var avPlayerProvider: AVPlayerProviderProtocol = AVPlayerProvider()

    var player: AVAudioPlayer!
    var song: Song!
    var timer: Timer?

    func load(song: Song) {
        self.song = song
        player = avPlayerProvider.getAudioPlayer(url: song.url)
        player.prepareToPlay()
    }

    func playSong(fromCountdown: TimeInterval) {
        player.currentTime = 0
        let timeDifference = fromCountdown - song.recordingStartTime
        if timeDifference == 0 {
            player.play()
        } else if timeDifference < 0 {
            player.currentTime = -1 * timeDifference
            player.play()
        } else {
            timer = scheduler.fireOnce(after: timeDifference) { [weak self] _ in
                self?.player.play()
            }
        }
    }

    func stopSong() {
        if let timer = timer, timer.isValid {
            timer.invalidate()
        }
        player.stop()
        player.currentTime = 0
        player.prepareToPlay()
    }
}
