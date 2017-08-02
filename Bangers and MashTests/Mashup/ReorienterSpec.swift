import UIKit
import Quick
import Nimble
import Fleet
import CoreMedia
import CoreGraphics
import AVFoundation
@testable import Bangers_and_Mash

class ReorienterSpec: QuickSpec {
    override func spec() {
        describe("Reorienter") {
            var subject: Reorienter!
            var transformTransformer: FakeTransformTransformer!
            var michaelBay: FakeMichaelBay!

            beforeEach {
                subject = Reorienter()

                transformTransformer = FakeTransformTransformer()
                subject.transformTransformer = transformTransformer

                michaelBay = FakeMichaelBay()
                subject.michaelBay = michaelBay
            }

            describe("building reorientation instructions") {
                var instruction: AVVideoCompositionInstruction!
                let timeRange = CMTimeRange(start: CMTime(seconds: 1, preferredTimescale: 1), duration: CMTime(seconds: 3, preferredTimescale: 1))
                var compositionAssetTrack: AVCompositionTrack!
                let bundle = Bundle(for: type(of: self))
                let videoPath = bundle.path(forResource: "perrier", ofType: "MOV")!
                let videoUrl = URL(fileURLWithPath: videoPath)
                let videoAsset = AVAsset(url: videoUrl)
                var assetTrack: AVAssetTrack!

                beforeEach {
                    assetTrack = videoAsset.tracks(withMediaType: AVMediaTypeVideo).first!
                    let composition = AVMutableComposition()
                    compositionAssetTrack = composition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)

                    transformTransformer.returnTranslationsForNewTranslation = [6, 8]

                    instruction = subject.buildInstructions(assetTrack: assetTrack, compositionAssetTrack: compositionAssetTrack, timeRange: timeRange)
                }

                it("sets the instruction time range") {
                    expect(instruction.timeRange).to(equal(timeRange))
                }

                it("has a layer instruction") {
                    expect(instruction.layerInstructions.count).to(equal(1))
                }

                describe("the layer instruction") {
                    var layerInstruction: AVVideoCompositionLayerInstruction?

                    beforeEach {
                        layerInstruction = instruction.layerInstructions.first
                    }

                    it("sets the asset track to the composition asset track") {
                        expect(layerInstruction?.trackID).to(equal(compositionAssetTrack.trackID))
                    }

                    it("calls the transform transformer twice") {
                        expect(transformTransformer.capturedArgumentsForNewTranslation.count).to(equal(2))
                    }

                    it("calls the transform transformer on the tx value") {
                        let args = transformTransformer.capturedArgumentsForNewTranslation.get(0)
                        expect(args?.original).to(equal(assetTrack.preferredTransform.tx))
                        expect(args?.size).to(equal(assetTrack.naturalSize))
                    }

                    it("calls the transform transformer on the ty value") {
                        let args = transformTransformer.capturedArgumentsForNewTranslation.get(1)
                        expect(args?.original).to(equal(assetTrack.preferredTransform.ty))
                        expect(args?.size).to(equal(assetTrack.naturalSize))
                    }

                    it("tells michael bay to make a transform") {
                        expect(michaelBay.capturedTimeForSet).to(equal(kCMTimeZero))
                        expect(michaelBay.capturedInstructionForSet).to(equal(layerInstruction))
                        var newTransform = assetTrack.preferredTransform
                        newTransform.tx = 6
                        newTransform.ty = 8
                        expect(michaelBay.capturedTransformForSet).to(equal(newTransform))
                    }
                }
            }
        }
    }
}
