import UIKit
import Quick
import Nimble
import Fleet
import AVFoundation
@testable import Bangers_and_Mash

class AVAssetExportSessionProviderSpec: QuickSpec {
    override func spec() {
        describe("AVAssetExportSessionProvider") {
            var subject: AVAssetExportSessionProvider!

            beforeEach {
                subject = AVAssetExportSessionProvider()
            }

            describe("provising an av asset export session") {
                var result: AVAssetExportSession!
                let bundle = Bundle(for: type(of: self))
                let path = bundle.path(forResource: "perrier", ofType: "MOV")!
                let url = URL(fileURLWithPath: path)
                let asset = AVAsset(url: url)

                beforeEach {
                    result = subject.get(asset: asset, quality: AVAssetExportPresetHighestQuality)
                }

                it("creates an export session with the asset and quality") {
                    expect(result.asset).to(be(asset))
                    expect(result.presetName).to(equal(AVAssetExportPresetHighestQuality))
                }
            }
        }
    }
}
