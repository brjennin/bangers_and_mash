import UIKit
import Quick
import Nimble
import Fleet
@testable import Bangers_and_Mash

class ReviewViewControllerSpec: QuickSpec {
    override func spec() {
        describe("ReviewViewController") {
            var subject: ReviewViewController!
            var subviewPresenter: FakeSubviewPresenter!
            var videoPlayerViewControllerProvider: FakeVideoPlayerViewControllerProvider!

            beforeEach {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                subject = storyboard.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController

                subviewPresenter = FakeSubviewPresenter()
                subject.subviewPresenter = subviewPresenter

                videoPlayerViewControllerProvider = FakeVideoPlayerViewControllerProvider()
                subject.videoPlayerViewControllerProvider = videoPlayerViewControllerProvider
            }

            describe("loading a video url") {
                let url = URL(string: "https://example.com/video.mp4")!
                var controller: FakeVideoPlayerViewController!

                beforeEach {
                    controller = FakeVideoPlayerViewController()
                    videoPlayerViewControllerProvider.returnValueForGet = controller

                    subject.configureWith(videoUrl: url)
                }                

                it("calls load on the video player view controller with the URL") {
                    expect(controller.capturedUrlForLoad).to(equal(url))
                }

                describe("view did load") {
                    beforeEach {
                        TestViewRenderer.initiateViewLifeCycle(controller: subject)
                    }

                    it("presents a video player controller in the view") {
                        expect(subviewPresenter.capturedSuperViewForAdd).to(equal(subject.view))
                        expect(subviewPresenter.capturedSubControllerForAdd).to(be(controller))
                        expect(subviewPresenter.capturedParentControllerForAdd).to(be(subject))
                    }
                }
            }
        }
    }
}
