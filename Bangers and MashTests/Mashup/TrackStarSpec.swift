import UIKit
import Quick
import Nimble
import Fleet
import AVFoundation
@testable import Bangers_and_Mash

class TrackStarSpec: QuickSpec {
    override func spec() {
        describe("TrackStar") {
            var subject: TrackStar!

            beforeEach {
                subject = TrackStar()
            }

            describe("getting tracks from a URL") {
                let bundle = Bundle(for: type(of: self))
                let videoPath = bundle.path(forResource: "perrier", ofType: "MOV")!
                let videoUrl = URL(fileURLWithPath: videoPath)
                let videoAsset = AVAsset(url: videoUrl)
                var track: AVAssetTrack!

                describe("getting audio track") {
                    beforeEach {
                        track = subject.audioTrack(from: videoAsset)
                    }

                    it("returns an audio track") {
                        expect(track.mediaType).to(equal(AVMediaTypeAudio))
                    }

                    it("returns the audio track from the passed in url") {
                        let expectedTrack = videoAsset.tracks(withMediaType: AVMediaTypeAudio).first!
                        expect(track.trackID).to(equal(expectedTrack.trackID))
                    }
                }

                describe("getting video track") {
                    beforeEach {
                        track = subject.videoTrack(from: videoAsset)
                    }

                    it("returns an video track") {
                        expect(track.mediaType).to(equal(AVMediaTypeVideo))
                    }

                    it("returns the video track from the passed in url") {
                        let expectedTrack = videoAsset.tracks(withMediaType: AVMediaTypeVideo).first!
                        expect(track.trackID).to(equal(expectedTrack.trackID))
                    }
                }
            }

            describe("adding to a composition track") {
                let bundle = Bundle(for: type(of: self))
                let videoPath = bundle.path(forResource: "perrier", ofType: "MOV")!
                let videoUrl = URL(fileURLWithPath: videoPath)
                let videoAsset = AVAsset(url: videoUrl)
                let videoTrack = videoAsset.tracks(withMediaType: AVMediaTypeVideo).first!
                let range = CMTimeRange(start: CMTime(seconds: 1, preferredTimescale: 100), duration: CMTime(seconds: 5, preferredTimescale: 100))
                let addAtTime = CMTime(seconds: 3, preferredTimescale: 100)
                var mutableCompositionTrack: AVMutableCompositionTrack!

                beforeEach {
                    let composition = AVMutableComposition()
                    mutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)

                    subject.add(track: videoTrack, to: mutableCompositionTrack, for: range, at: addAtTime)
                }

                it("inserts the track in the composition track at the time for the given range") {
                    expect(mutableCompositionTrack.segments.count).to(equal(2))
                    let segment = mutableCompositionTrack.segments.last
                    expect(segment?.sourceURL).to(equal(videoUrl))

                    let destinationTimeRange = CMTimeRange(start: addAtTime, duration: range.duration)
                    let validSegment = AVCompositionTrackSegment(url: videoUrl, trackID: mutableCompositionTrack.trackID, sourceTimeRange: range, targetTimeRange: destinationTimeRange)
                    expect(segment).to(equal(validSegment))
                }
            }
        }
    }
}
