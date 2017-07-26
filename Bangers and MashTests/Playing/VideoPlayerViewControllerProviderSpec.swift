import UIKit
import Quick
import Nimble
import Fleet
@testable import Bangers_and_Mash

class VideoPlayerViewControllerProviderSpec: QuickSpec {
    override func spec() {
        describe("VideoPlayerViewControllerProvider") {
            var subject: VideoPlayerViewControllerProvider!

            beforeEach {
                subject = VideoPlayerViewControllerProvider()
            }

            describe("getting a new view controller") {
                var result: VideoPlayerViewController!

                beforeEach {
                    result = subject.get()
                }

                it("returns a new controller each time") {
                    expect(result).toNot(be(subject.get()))
                }
            }
        }
    }
}
