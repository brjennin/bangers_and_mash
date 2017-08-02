import UIKit
import Quick
import Nimble
import Fleet
import AVFoundation
import CoreMedia
import CoreGraphics
@testable import Bangers_and_Mash

class YoureJustMashingItSpec: QuickSpec {
    override func spec() {
        describe("YoureJustMashingIt") {
            var subject: YoureJustMashingIt!
            var videoArchiver: FakeVideoArchiver!
            var trackStar: FakeTrackStar!
            var timeSplitter: FakeTimeSplitter!
            var randomPicker: FakeRandomPicker!
            var reorienter: FakeReorienter!

            beforeEach {
                subject = YoureJustMashingIt()

                videoArchiver = FakeVideoArchiver()
                subject.videoArchiver = videoArchiver

                trackStar = FakeTrackStar()
                subject.trackStar = trackStar

                timeSplitter = FakeTimeSplitter()
                subject.timeSplitter = timeSplitter

                randomPicker = FakeRandomPicker()
                subject.randomPicker = randomPicker

                reorienter = FakeReorienter()
                subject.reorienter = reorienter
            }

            describe("combining a song and video") {
                let bundle = Bundle(for: type(of: self))
                let video1Path = bundle.path(forResource: "perrier", ofType: "MOV")!
                let video1Url = URL(fileURLWithPath: video1Path)
                let video2Path = bundle.path(forResource: "ice", ofType: "MOV")!
                let video2Url = URL(fileURLWithPath: video2Path)
                let songPath = bundle.path(forResource: "wild_thoughts", ofType: "mp3")!
                let songUrl = URL(fileURLWithPath: songPath)
                var song: Song!
                var completionUrl: URL?
                var composition: AVMutableComposition!
                let exportUrl = URL(string: "file:///export/movie.mov")!
                var audioTrack: AVAssetTrack!
                var video1Track: AVAssetTrack!
                var video2Track: AVAssetTrack!
                var timeChunks: [CMTimeRange]!
                var videoComposition: AVVideoComposition!
                var instructions: [AVVideoCompositionInstruction]!

                beforeEach {
                    song = Song(name: "", url: songUrl, recordingStartTime: 20)

                    audioTrack = AVAsset(url: songUrl).tracks.first!
                    trackStar.returnAssetTrackForAudioTrack = audioTrack
                    video1Track = AVAsset(url: video1Url).tracks.first!
                    video2Track = AVAsset(url: video2Url).tracks.first!
                    trackStar.returnAssetTracksForVideoTrack = [video1Track, video2Track]
                }

                describe("combining an audio and video") {
                    beforeEach {
                        timeChunks = [
                            CMTimeRange(start: CMTime(seconds: 0, preferredTimescale: 100), end: CMTime(seconds: 5, preferredTimescale: 100))
                        ]
                        timeSplitter.returnTimeRangesForTimeChunks = timeChunks
                        
                        randomPicker.returnItemsForPick = [video1Track]

                        instructions = [AVVideoCompositionInstruction()]
                        reorienter.returnInstructionsForBuildInstructions = instructions

                        completionUrl = nil
                        subject.combine(song: song, videoUrl: video1Url) { url in
                            completionUrl = url
                        }

                        composition = videoArchiver.capturedAssetForExportTemp as? AVMutableComposition
                        videoComposition = videoArchiver.capturedVideoCompositionForExportTemp
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
                        expect(trackStar.capturedAssetsForVideoTrack.count).to(equal(1))
                        expect((trackStar.capturedAssetsForVideoTrack.first as? AVURLAsset)?.url).to(equal(video1Url))
                    }

                    it("adds 2 tracks with the track star") {
                        expect(trackStar.capturedArgumentsForAdd.count).to(equal(2))
                    }

                    it("calls the time splitter with the video duration") {
                        expect(timeSplitter.capturedDurationForTimeChunks).to(equal(CMTime(seconds: song.recordDuration, preferredTimescale: 100)))
                        expect(timeSplitter.capturedChunksForTimeChunks).to(equal(1))
                    }

                    it("calls the random picker with the list of video tracks for each time chunk") {
                        expect(randomPicker.capturedListsForPick.count).to(equal(1))
                        expect(randomPicker.capturedListsForPick.get(0) as? [AVAssetTrack]).to(equal([video1Track]))
                    }

                    it("adds the audio track to the composiition") {
                        let audioAdd = trackStar.capturedArgumentsForAdd.get(0)
                        let compositionAudioTrack = composition?.tracks(withMediaType: AVMediaTypeAudio).first
                        expect(audioAdd?.capturedCompositionTrack).to(equal(compositionAudioTrack))
                        expect(audioAdd?.capturedTime).to(equal(kCMTimeZero))
                        expect(audioAdd?.capturedTrack).to(equal(audioTrack))

                        let songRange = CMTimeRange(start: CMTime(seconds: 20, preferredTimescale: 100), duration: CMTime(seconds: song.recordDuration, preferredTimescale: 100))
                        expect(audioAdd?.capturedRange).to(equal(songRange))
                    }

                    it("adds the video track to the composiition") {
                        let videoAdd = trackStar.capturedArgumentsForAdd.get(1)
                        let compositionVideoTrack = composition?.tracks(withMediaType: AVMediaTypeVideo).first
                        expect(videoAdd?.capturedCompositionTrack).to(equal(compositionVideoTrack))
                        expect(videoAdd?.capturedTime).to(equal(timeChunks[0].start))
                        expect(videoAdd?.capturedTrack).to(equal(video1Track))
                        expect(videoAdd?.capturedRange).to(equal(timeChunks[0]))
                    }
                    
                    it("makes a video composition") {
                        expect(videoComposition.frameDuration).to(equal(CMTimeMake(1, 30)))
                        expect(videoComposition.renderSize).to(equal(CGSize(width: 2160, height: 3840)))
                        expect(videoComposition.instructions.count).to(equal(instructions.count))
                    }

                    it("reorients for each time chunk") {
                        expect(reorienter.capturedArgsForBuildInstructions.count).to(equal(1))

                        let compositionVideoTrack = composition?.tracks(withMediaType: AVMediaTypeVideo).first
                        let args = reorienter.capturedArgsForBuildInstructions.get(0)
                        expect(args?.assetTrack).to(equal(video1Track))
                        expect(args?.compositionAssetTrack).to(equal(compositionVideoTrack))
                        expect(args?.timeRange).to(equal(timeChunks.first!))
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

                describe("mashing up videos with a song") {
                    beforeEach {
                        timeChunks = [
                            CMTimeRange(start: CMTime(seconds: 0, preferredTimescale: 100), end: CMTime(seconds: 2, preferredTimescale: 100)),
                            CMTimeRange(start: CMTime(seconds: 2, preferredTimescale: 100), end: CMTime(seconds: 4, preferredTimescale: 100)),
                            CMTimeRange(start: CMTime(seconds: 4, preferredTimescale: 100), end: CMTime(seconds: 5, preferredTimescale: 100))
                        ]
                        timeSplitter.returnTimeRangesForTimeChunks = timeChunks

                        randomPicker.returnItemsForPick = [video2Track, video1Track, video2Track]

                        instructions = [
                            AVVideoCompositionInstruction(),
                            AVVideoCompositionInstruction(),
                            AVVideoCompositionInstruction()
                        ]
                        reorienter.returnInstructionsForBuildInstructions = instructions

                        completionUrl = nil
                        subject.randomMash(song: song, videoUrls: [video1Url, video2Url]) { url in
                            completionUrl = url
                        }

                        composition = videoArchiver.capturedAssetForExportTemp as? AVMutableComposition
                        videoComposition = videoArchiver.capturedVideoCompositionForExportTemp
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

                    it("gets the video tracks from video urls") {
                        expect(trackStar.capturedAssetsForVideoTrack.count).to(equal(2))
                        expect((trackStar.capturedAssetsForVideoTrack.first as? AVURLAsset)?.url).to(equal(video1Url))
                        expect((trackStar.capturedAssetsForVideoTrack.last as? AVURLAsset)?.url).to(equal(video2Url))
                    }

                    it("adds 1 song track and 3 video tracks with the track star") {
                        expect(trackStar.capturedArgumentsForAdd.count).to(equal(4))
                    }

                    it("adds the audio track to the composiition") {
                        let audioAdd = trackStar.capturedArgumentsForAdd.get(0)
                        let compositionAudioTrack = composition?.tracks(withMediaType: AVMediaTypeAudio).first
                        expect(audioAdd?.capturedCompositionTrack).to(equal(compositionAudioTrack))
                        expect(audioAdd?.capturedTime).to(equal(kCMTimeZero))
                        expect(audioAdd?.capturedTrack).to(equal(audioTrack))

                        let songRange = CMTimeRange(start: CMTime(seconds: 20, preferredTimescale: 100), duration: CMTime(seconds: song.recordDuration, preferredTimescale: 100))
                        expect(audioAdd?.capturedRange).to(equal(songRange))
                    }

                    it("calls the time splitter with the video duration") {
                        expect(timeSplitter.capturedDurationForTimeChunks).to(equal(CMTime(seconds: song.recordDuration, preferredTimescale: 100)))
                        expect(timeSplitter.capturedChunksForTimeChunks).to(equal(10))
                    }

                    it("calls the random picker with the list of video tracks for each time chunk") {
                        expect(randomPicker.capturedListsForPick.count).to(equal(3))
                        expect(randomPicker.capturedListsForPick.get(0) as? [AVAssetTrack]).to(equal([video1Track, video2Track]))
                        expect(randomPicker.capturedListsForPick.get(1) as? [AVAssetTrack]).to(equal([video1Track, video2Track]))
                        expect(randomPicker.capturedListsForPick.get(2) as? [AVAssetTrack]).to(equal([video1Track, video2Track]))
                    }

                    it("adds the video tracks to the composiition") {
                        let compositionVideoTrack = composition?.tracks(withMediaType: AVMediaTypeVideo).first

                        let video1Add = trackStar.capturedArgumentsForAdd.get(1)
                        expect(video1Add?.capturedCompositionTrack).to(equal(compositionVideoTrack))
                        expect(video1Add?.capturedTime).to(equal(timeChunks[0].start))
                        expect(video1Add?.capturedTrack).to(equal(video2Track))
                        expect(video1Add?.capturedRange).to(equal(timeChunks[0]))

                        let video2Add = trackStar.capturedArgumentsForAdd.get(2)
                        expect(video2Add?.capturedCompositionTrack).to(equal(compositionVideoTrack))
                        expect(video2Add?.capturedTime).to(equal(timeChunks[1].start))
                        expect(video2Add?.capturedTrack).to(equal(video1Track))
                        expect(video2Add?.capturedRange).to(equal(timeChunks[1]))

                        let video3Add = trackStar.capturedArgumentsForAdd.get(3)
                        expect(video3Add?.capturedCompositionTrack).to(equal(compositionVideoTrack))
                        expect(video3Add?.capturedTime).to(equal(timeChunks[2].start))
                        expect(video3Add?.capturedTrack).to(equal(video2Track))
                        expect(video3Add?.capturedRange).to(equal(timeChunks[2]))
                    }

                    it("makes a video composition") {
                        expect(videoComposition.frameDuration).to(equal(CMTimeMake(1, 30)))
                        expect(videoComposition.renderSize).to(equal(CGSize(width: 2160, height: 3840)))
                        expect(videoComposition.instructions.count).to(equal(instructions.count))
                    }

                    it("reorients for each time chunk") {
                        expect(reorienter.capturedArgsForBuildInstructions.count).to(equal(3))

                        let compositionVideoTrack = composition?.tracks(withMediaType: AVMediaTypeVideo).first
                        let args1 = reorienter.capturedArgsForBuildInstructions.get(0)
                        expect(args1?.assetTrack).to(equal(video2Track))
                        expect(args1?.compositionAssetTrack).to(equal(compositionVideoTrack))
                        expect(args1?.timeRange).to(equal(timeChunks[0]))

                        let args2 = reorienter.capturedArgsForBuildInstructions.get(1)
                        expect(args2?.assetTrack).to(equal(video1Track))
                        expect(args2?.compositionAssetTrack).to(equal(compositionVideoTrack))
                        expect(args2?.timeRange).to(equal(timeChunks[1]))

                        let args3 = reorienter.capturedArgsForBuildInstructions.get(2)
                        expect(args3?.assetTrack).to(equal(video2Track))
                        expect(args3?.compositionAssetTrack).to(equal(compositionVideoTrack))
                        expect(args3?.timeRange).to(equal(timeChunks[2]))
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
}
