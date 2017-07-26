import UIKit
import Quick
import Nimble
import Fleet
import FontAwesome_swift
@testable import Bangers_and_Mash

class MashupTakesViewControllerSpec: QuickSpec {
    override func spec() {
        describe("MashupTakesViewController") {
            var subject: MashupTakesViewController!
            var subviewPresenter: FakeSubviewPresenter!
            var videoCollectionViewControllerProvider: FakeVideoCollectionViewControllerProvider!
            var videoRepository: FakeVideoRepository!

            beforeEach {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                subject = storyboard.instantiateViewController(withIdentifier: "MashupTakesViewController") as! MashupTakesViewController

                subviewPresenter = FakeSubviewPresenter()
                subject.subviewPresenter = subviewPresenter

                videoCollectionViewControllerProvider = FakeVideoCollectionViewControllerProvider()
                subject.videoCollectionViewControllerProvider = videoCollectionViewControllerProvider

                videoRepository = FakeVideoRepository()
                subject.videoRepository = videoRepository
            }

            describe("viewDidLoad") {
                var videoCollectionViewController: FakeVideoCollectionViewController!

                beforeEach {
                    videoCollectionViewController = FakeVideoCollectionViewController()
                    videoCollectionViewControllerProvider.returnValueForGet = videoCollectionViewController

                    TestViewRenderer.initiateViewLifeCycle(controller: subject)
                }

                it("sets the button to be a fontawesome button") {
                    expect(subject.addVideoButton.title(for: .normal)).to(equal(String.fontAwesomeIcon(name: .plusCircle)))
                }

                it("presents a collection of all mashup videos") {
                    expect(subviewPresenter.capturedSuperViewForAdd).to(equal(subject.mashupListView))
                    expect(subviewPresenter.capturedSubControllerForAdd).to(be(videoCollectionViewController))
                    expect(subviewPresenter.capturedParentControllerForAdd).to(be(subject))
                }

                describe("view did appear") {
                    beforeEach {
                        subject.viewDidAppear(false)
                    }

                    it("calls the video repository") {
                        expect(videoRepository.capturedCallbackForGetVideos).toNot(beNil())
                    }

                    describe("when the callback returns videos") {
                        var videos: [URL]!

                        beforeEach {
                            videos = [
                                URL(string: "https://example.com/video1.mp4")!,
                                URL(string: "https://example.com/video2.mp4")!,
                                URL(string: "https://example.com/video3.mp4")!
                            ]
                            videoRepository.capturedCallbackForGetVideos?(videos)
                        }

                        it("loads videos into the collection view controller") {
                            expect(videoCollectionViewController.capturedVideosForLoad).to(equal(videos))
                        }
                    }
                }
            }
        }
    }
}
