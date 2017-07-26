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
            var viewDismisser: FakeViewDismisser!
            var videoArchiver: FakeVideoArchiver!

            beforeEach {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                subject = storyboard.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController

                subviewPresenter = FakeSubviewPresenter()
                subject.subviewPresenter = subviewPresenter

                videoPlayerViewControllerProvider = FakeVideoPlayerViewControllerProvider()
                subject.videoPlayerViewControllerProvider = videoPlayerViewControllerProvider

                viewDismisser = FakeViewDismisser()
                subject.viewDismisser = viewDismisser

                videoArchiver = FakeVideoArchiver()
                subject.videoArchiver = videoArchiver
            }

            describe("loading a video url") {
                let url = URL(string: "https://example.com/video.mp4")!
                var controller: FakeVideoPlayerViewController!
                var calledVideoKeptCallback: Bool!

                beforeEach {
                    controller = FakeVideoPlayerViewController()
                    videoPlayerViewControllerProvider.returnValueForGet = controller

                    calledVideoKeptCallback = false
                    subject.configureWith(videoUrl: url) {
                        calledVideoKeptCallback = true
                    }
                }                

                it("calls load on the video player view controller with the URL") {
                    expect(controller.capturedUrlForLoad).to(equal(url))
                }

                describe("view did load") {
                    beforeEach {
                        TestViewRenderer.initiateViewLifeCycle(controller: subject)
                    }

                    it("presents a video player controller in the view") {
                        expect(subviewPresenter.capturedSuperViewForAdd).to(equal(subject.playerView))
                        expect(subviewPresenter.capturedSubControllerForAdd).to(be(controller))
                        expect(subviewPresenter.capturedParentControllerForAdd).to(be(subject))
                    }

                    describe("tapping retake") {
                        beforeEach {
                            try! subject.retakeButton.tap()
                        }

                        it("dismisses the view") {
                            expect(viewDismisser.capturedControllerForDismiss).to(be(subject))
                        }

                        it("disables keep and retake buttons") {
                            expect(subject.keepButton.isEnabled).to(beFalse())
                            expect(subject.retakeButton.isEnabled).to(beFalse())
                        }

                        it("does not call the video kept callback") {
                            expect(calledVideoKeptCallback).to(beFalse())
                        }
                    }

                    describe("tapping keep video take") {
                        beforeEach {
                            try! subject.keepButton.tap()
                        }

                        it("dismisses the view") {
                            expect(viewDismisser.capturedControllerForDismiss).to(be(subject))
                        }

                        it("archives the video") {
                            expect(videoArchiver.capturedTempUrlForPersist).to(equal(url))
                        }

                        it("disables keep and retake buttons") {
                            expect(subject.keepButton.isEnabled).to(beFalse())
                            expect(subject.retakeButton.isEnabled).to(beFalse())
                        }

                        it("calls the video kept callback") {
                            expect(calledVideoKeptCallback).to(beTrue())
                        }
                    }
                }
            }
        }
    }
}
