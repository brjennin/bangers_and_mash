import UIKit
import Quick
import Nimble
import Fleet
import AVKit
import AVFoundation
@testable import Bangers_and_Mash

class AVPlayerProviderSpec: QuickSpec {
    override func spec() {
        describe("AVPlayerProvider") {
            var subject: AVPlayerProvider!

            beforeEach {
                subject = AVPlayerProvider()
            }

            describe("getting a new av player") {
                let url = URL(string: "https://example.com/video.mp4")!
                var result: AVPlayer!

                beforeEach {
                    result = subject.get(url: url)
                }

                it("returns a new player each time") {
                    expect(result).toNot(be(subject.get(url: url)))
                }
            }
        }
    }
}
