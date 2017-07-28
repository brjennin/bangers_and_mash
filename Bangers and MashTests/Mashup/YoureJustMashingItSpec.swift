import UIKit
import Quick
import Nimble
import Fleet
import AVFoundation
@testable import Bangers_and_Mash

class YoureJustMashingItSpec: QuickSpec {
    override func spec() {
        describe("YoureJustMashingIt") {
            var subject: YoureJustMashingIt!
            var videoArchiver: FakeVideoArchiver!
            var trackStar: FakeTrackStar!

            beforeEach {
                subject = YoureJustMashingIt()

                videoArchiver = FakeVideoArchiver()
                subject.videoArchiver = videoArchiver

                trackStar = FakeTrackStar()
                subject.trackStar = trackStar
            }

            describe("combining an audio and video") {
                let bundle = Bundle(for: type(of: self))
                let videoPath = bundle.path(forResource: "perrier", ofType: "MOV")!
                let videoUrl = URL(fileURLWithPath: videoPath)
                let songPath = bundle.path(forResource: "wild_thoughts", ofType: "mp3")!
                let songUrl = URL(fileURLWithPath: songPath)
                var song: Song!
                var completionUrl: URL?
                var composition: AVMutableComposition!
                let exportUrl = URL(string: "file:///export/movie.mov")!
                var audioTrack: AVAssetTrack!
                var videoTrack: AVAssetTrack!

                beforeEach {
                    song = Song(name: "", url: songUrl, recordingStartTime: 20)

                    audioTrack = AVAsset(url: songUrl).tracks.first!
                    trackStar.returnAssetTrackForAudioTrack = audioTrack
                    videoTrack = AVAsset(url: videoUrl).tracks.first!
                    trackStar.returnAssetTrackForVideoTrack = videoTrack

                    completionUrl = nil
                    subject.combine(song: song, videoUrl: videoUrl) { url in
                        completionUrl = url
                    }

                    composition = videoArchiver.capturedAssetForExportTemp as? AVMutableComposition
                }

                it("has an audio and video track") {
                    expect(composition?.tracks.count).to(equal(2))
                    let compositionVideoTrack = composition?.tracks(withMediaType: AVMediaTypeVideo).first
                    let compositionAudioTrack = composition?.tracks(withMediaType: AVMediaTypeAudio).first
                    expect(compositionVideoTrack).toNot(beNil())
                    expect(compositionAudioTrack).toNot(beNil())
                }                

                it("exports a temp video") {
                    expect(videoArchiver.capturedAssetForExportTemp).to(beAKindOf(AVMutableComposition.self))
                }

                it("gets the audio track from the song") {
                    expect((trackStar.capturedAssetForAudioTrack as? AVURLAsset)?.url).to(equal(song.url))
                }

                it("gets the video track from video url") {
                    expect((trackStar.capturedAssetForVideoTrack as? AVURLAsset)?.url).to(equal(videoUrl))
                }

                it("adds 2 tracks with the track star") {
                    expect(trackStar.capturedArgumentsForAdd.count).to(equal(2))
                }

                it("adds the audio track to the composiition") {
                    let audioAdd = trackStar.capturedArgumentsForAdd.get(0)
                    let compositionAudioTrack = composition?.tracks(withMediaType: AVMediaTypeAudio).first
                    expect(audioAdd?.capturedCompositionTrack).to(equal(compositionAudioTrack))
                    expect(audioAdd?.capturedTime).to(equal(kCMTimeZero))
                    expect(audioAdd?.capturedTrack).to(equal(audioTrack))

                    let songRange = CMTimeRange(start: CMTime(seconds: 20, preferredTimescale: 1), duration: CMTime(seconds: song.recordDuration, preferredTimescale: 1))
                    expect(audioAdd?.capturedRange).to(equal(songRange))
                }

                it("adds the video track to the composiition") {
                    let videoAdd = trackStar.capturedArgumentsForAdd.get(1)
                    let compositionVideoTrack = composition?.tracks(withMediaType: AVMediaTypeVideo).first
                    expect(videoAdd?.capturedCompositionTrack).to(equal(compositionVideoTrack))
                    expect(videoAdd?.capturedTime).to(equal(kCMTimeZero))
                    expect(videoAdd?.capturedTrack).to(equal(videoTrack))

                    let videoRange = CMTimeRange(start: kCMTimeZero, duration: CMTime(seconds: song.recordDuration, preferredTimescale: 1))
                    expect(videoAdd?.capturedRange).to(equal(videoRange))
                }

                it("sets the preferred transform of the video track") {
                    let compositionVideoTrack = composition?.tracks(withMediaType: AVMediaTypeVideo).first
                    expect(compositionVideoTrack?.preferredTransform).to(equal(videoTrack.preferredTransform))
                }

                describe("when export finishes") {
                    beforeEach {
                        videoArchiver.capturedCompletionForExportTemp?(exportUrl)
                    }

                    it("calls the completion with the url") {
                        expect(completionUrl).to(equal(exportUrl))
                    }
                }
            }
        }
    }
}
