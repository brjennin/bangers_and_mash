import Foundation
import AVFoundation
import CoreMedia

protocol YoureJustMashingItProtocol {
    func combine(song: Song, videoUrl: URL, completion: @escaping (URL) -> ())
    func randomMash(song: Song, videoUrls: [URL], completion: @escaping (URL) -> ())
}

class YoureJustMashingIt: YoureJustMashingItProtocol {
    var videoArchiver: VideoArchiverProtocol = VideoArchiver()
    var trackStar: TrackStarProtocol = TrackStar()
    var timeSplitter: TimeSplitterProtocol = TimeSplitter()
    var randomPicker: RandomPickerProtocol = RandomPicker()

    func combine(song: Song, videoUrl: URL, completion: @escaping (URL) -> ()) {
        buildComposition(song: song, videoUrls: [videoUrl], chunks: 1, completion: completion)
    }

    func randomMash(song: Song, videoUrls: [URL], completion: @escaping (URL) -> ()) {
        buildComposition(song: song, videoUrls: videoUrls, chunks: 10, completion: completion)
    }

    private func buildComposition(song: Song, videoUrls: [URL], chunks: Int, completion: @escaping (URL) -> ()) {
        let composition = AVMutableComposition()
        let compositionVideoTrack = composition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)
        let compositionAudioTrack = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)

        let videoDuration = CMTime(seconds: song.recordDuration, preferredTimescale: 1)
        let timeRange = CMTimeRange(start: kCMTimeZero, duration: videoDuration)

        let songAsset = AVAsset(url: song.url)
        let songTrack = trackStar.audioTrack(from: songAsset)
        let songRecordStart = CMTime(seconds: song.recordingStartTime, preferredTimescale: 1)
        let songRange = CMTimeRange(start: songRecordStart, duration: videoDuration)
        trackStar.add(track: songTrack, to: compositionAudioTrack, for: songRange, at: timeRange.start)

        let videoAssets = videoUrls.map { videoUrl in return AVAsset(url: videoUrl) }
        let videoTracks = videoAssets.map { asset in return self.trackStar.videoTrack(from: asset) }
        let chunks = timeSplitter.timeChunks(duration: videoDuration, chunks: chunks)
        for chunk in chunks {
            let randomVideo = randomPicker.pick(from: videoTracks)
            trackStar.add(track: randomVideo, to: compositionVideoTrack, for: chunk, at: chunk.start)
        }
        compositionVideoTrack.preferredTransform = videoTracks.last!.preferredTransform

        videoArchiver.exportTemp(asset: composition, completion: completion)
    }
}
