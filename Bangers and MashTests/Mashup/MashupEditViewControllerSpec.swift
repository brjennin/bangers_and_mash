import UIKit
import Quick
import Nimble
import Fleet
@testable import Bangers_and_Mash

class MashupEditViewControllerSpec: QuickSpec {
    override func spec() {
        describe("MashupEditViewController") {
            var subject: MashupEditViewController!
            var subviewPresenter: FakeSubviewPresenter!
            var videoPlayerViewControllerProvider: FakeVideoPlayerViewControllerProvider!
            var youreJustMashingIt: FakeYoureJustMashingIt!
            var dispatcher: FakeDispatcher!

            beforeEach {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                subject = storyboard.instantiateViewController(withIdentifier: "MashupEditViewController") as! MashupEditViewController

                subviewPresenter = FakeSubviewPresenter()
                subject.subviewPresenter = subviewPresenter

                videoPlayerViewControllerProvider = FakeVideoPlayerViewControllerProvider()
                subject.videoPlayerViewControllerProvider = videoPlayerViewControllerProvider

                youreJustMashingIt = FakeYoureJustMashingIt()
                subject.youreJustMashingIt = youreJustMashingIt

                dispatcher = FakeDispatcher()
                subject.dispatcher = dispatcher
            }

            describe("configuring with videos and a song") {
                let videos = [
                    URL(string: "https://example.com/video1.mp4")!,
                    URL(string: "https://example.com/video2.mp4")!
                ]
                let song = Song(name: "", url: URL(string: "https://example.com/song.mp3")!, recordingStartTime: 5)

                beforeEach {
                    subject.configure(videos: videos, song: song)
                }

                describe("view did load") {
                    beforeEach {
                        TestViewRenderer.initiateViewLifeCycle(controller: subject)
                    }

                    it("mashes up the videos and song") {
                        expect(youreJustMashingIt.capturedSongForRandomMash).to(equal(song))
                        expect(youreJustMashingIt.capturedVideoUrlsForRandomMash).to(equal(videos))
                    }

                    describe("when the mash is completed") {
                        var controller: FakeVideoPlayerViewController!
                        let exportUrl = URL(string: "https://example.com/final.mov")!

                        beforeEach {
                            controller = FakeVideoPlayerViewController()
                            videoPlayerViewControllerProvider.returnValueForGet = controller

                            youreJustMashingIt.capturedCompletionForRandomMash?(exportUrl)
                        }

                        it("calls load on the video player controller") {
                            expect(controller.capturedUrlForLoad).to(equal(exportUrl))
                        }

                        it("it dispatches to the main queue") {
                            expect(dispatcher.capturedCompletionForDispatchToMainQueue).toNot(beNil())
                        }

                        describe("dispatching to the main queue") {
                            beforeEach {
                                dispatcher.capturedCompletionForDispatchToMainQueue?()
                            }

                            it("presents the player controller in the player view") {
                                expect(subviewPresenter.capturedSuperViewForAdd).to(equal(subject.playerView))
                                expect(subviewPresenter.capturedSubControllerForAdd).to(be(controller))
                                expect(subviewPresenter.capturedParentControllerForAdd).to(be(subject))
                            }
                        }
                    }
                }
            }
        }
    }
}
