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

            beforeEach {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                subject = storyboard.instantiateViewController(withIdentifier: "MashupEditViewController") as! MashupEditViewController

                subviewPresenter = FakeSubviewPresenter()
                subject.subviewPresenter = subviewPresenter

                videoPlayerViewControllerProvider = FakeVideoPlayerViewControllerProvider()
                subject.videoPlayerViewControllerProvider = videoPlayerViewControllerProvider
            }

            describe("configuring with videos") {
                let videos = [
                    URL(string: "https://example.com/video1.mp4")!,
                    URL(string: "https://example.com/video2.mp4")!
                ]

                beforeEach {
                    subject.configure(videos: videos)
                }

                describe("view did load") {
//                    var controller: FakeVideoPlayerViewController!

                    beforeEach {
//                        controller = FakeVideoPlayerViewController()
//                        videoPlayerViewControllerProvider.returnValueForGet = controller

                        TestViewRenderer.initiateViewLifeCycle(controller: subject)
                    }


                }
            }
        }
    }
}
