import UIKit
import Quick
import Nimble
import Fleet
import AVFoundation
@testable import Bangers_and_Mash

class PreviewBuilderSpec: QuickSpec {
    override func spec() {
        describe("PreviewBuilder") {
            var subject: PreviewBuilder!

            beforeEach {
                subject = PreviewBuilder()
            }

            describe("getting a thumbnail image for a video url") {
                var result: UIImage?
                let bundle = Bundle(for: type(of: self))
                let path = bundle.path(forResource: "perrier", ofType: "MOV")!
                let url = URL(fileURLWithPath: path)

                beforeEach {
                    result = subject.image(for: url)
                }

                it("returns an image") {
                    expect(result).toNot(beNil())
                }

                it("returns a thumbnail from the first frame of the video") {
                    let asset = AVURLAsset(url: url)
                    let imageGenerator = AVAssetImageGenerator(asset: asset)
                    imageGenerator.appliesPreferredTrackTransform = true
                    let image = try! imageGenerator.copyCGImage(at: kCMTimeZero, actualTime: nil)

                    expect(UIImagePNGRepresentation(result!)).to(equal(UIImagePNGRepresentation(UIImage(cgImage: image))))
                }

                it("rotates the image to portrait mode") {
                    expect(result?.size.height).to(beGreaterThan(result?.size.width))
                }
            }
        }
    }
}
