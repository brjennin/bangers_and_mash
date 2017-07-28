import Foundation
import AVFoundation
import CoreMedia

protocol YoureJustMashingItProtocol {
    func combine(song: Song, videoUrl: URL, completion: @escaping (URL) -> ())
}

class YoureJustMashingIt: YoureJustMashingItProtocol {
    var videoArchiver: VideoArchiverProtocol = VideoArchiver()
    var trackStar: TrackStarProtocol = TrackStar()

    func combine(song: Song, videoUrl: URL, completion: @escaping (URL) -> ()) {
        let composition = AVMutableComposition()
        let compositionVideoTrack = composition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)
        let compositionAudioTrack = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)

        let songAsset = AVAsset(url: song.url)
        let videoAsset = AVAsset(url: videoUrl)

        let songTrack = trackStar.audioTrack(from: songAsset)
        let videoTrack = trackStar.videoTrack(from: videoAsset)
        compositionVideoTrack.preferredTransform = videoTrack.preferredTransform

        let videoDuration = CMTime(seconds: song.recordDuration, preferredTimescale: 1)

        let timeRange = CMTimeRange(start: kCMTimeZero, duration: videoDuration)

        let songRecordStart = CMTime(seconds: song.recordingStartTime, preferredTimescale: 1)
        let songRange = CMTimeRange(start: songRecordStart, duration: videoDuration)
        trackStar.add(track: songTrack, to: compositionAudioTrack, for: songRange, at: timeRange.start)
        trackStar.add(track: videoTrack, to: compositionVideoTrack, for: timeRange, at: timeRange.start)

        videoArchiver.exportTemp(asset: composition, completion: completion)
    }
}
