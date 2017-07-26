import UIKit
import Quick
import Nimble
import Fleet
@testable import Bangers_and_Mash

class VideoCollectionViewControllerProviderSpec: QuickSpec {
    override func spec() {
        describe("VideoCollectionViewControllerProvider") {
            var subject: VideoCollectionViewControllerProvider!

            beforeEach {
                subject = VideoCollectionViewControllerProvider()
            }

            describe("getting a new view controller") {
                var result: VideoCollectionViewController!

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
