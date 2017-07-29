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

                it("sets the add button to be a fontawesome button") {
                    expect(subject.addVideoButton.title(for: .normal)).to(equal(String.fontAwesomeIcon(name: .plusCircle)))
                }

                it("sets the mash button to be a fontawesome button") {
                    expect(subject.mashButton.title(for: .normal)).to(equal(String.fontAwesomeIcon(name: .random)))
                }

                it("starts with the mash button disabled") {
                    expect(subject.mashButton.isEnabled).to(beFalse())
                }

                it("presents a collection of all mashup videos") {
                    expect(subviewPresenter.capturedSuperViewForAdd).to(equal(subject.mashupListView))
                    expect(subviewPresenter.capturedSubControllerForAdd).to(be(videoCollectionViewController))
                    expect(subviewPresenter.capturedParentControllerForAdd).to(be(subject))
                }

                it("sets the song label text") {
                    expect(subject.songLabel.text).to(equal("DJ Khaled, Rihanna, Bryson Tiller - Wild Thoughts (Medasin Dance Remix)"))
                }

                describe("view did appear") {
                    beforeEach {
                        subject.viewDidAppear(false)
                    }

                    it("calls the video repository") {
                        expect(videoRepository.capturedCallbackForGetVideos).toNot(beNil())
                    }

                    describe("when the callback returns") {
                        var videos: [URL]!

                        context("when there are videos") {
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

                            it("has a delete callback") {
                                expect(videoCollectionViewController.capturedDeleteCallbackForLoad).toNot(beNil())
                            }

                            it("enables the mashup button") {
                                expect(subject.mashButton.isEnabled).to(beTrue())
                            }

                            describe("when the delete callback is called") {
                                context("when deleting the last video") {
                                    beforeEach {
                                        videoCollectionViewController.capturedDeleteCallbackForLoad?(videos.first!, [])
                                    }

                                    it("deletes the video from the filesystem") {
                                        expect(videoRepository.capturedUrlForDelete).to(equal(videos.first!))
                                    }

                                    it("disables the mash button") {
                                        expect(subject.mashButton.isEnabled).to(beFalse())
                                    }
                                }

                                context("when there are videos left") {
                                    beforeEach {
                                        videoCollectionViewController.capturedDeleteCallbackForLoad?(videos.first!, [videos.last!])
                                    }

                                    it("deletes the video from the filesystem") {
                                        expect(videoRepository.capturedUrlForDelete).to(equal(videos.first!))
                                    }

                                    it("leaves the mash button enabled") {
                                        expect(subject.mashButton.isEnabled).to(beTrue())
                                    }
                                }
                            }

                            describe("hitting the mash up button") {
                                var mashupEditController: FakeMashupEditViewController!

                                beforeEach {
                                    mashupEditController = FakeMashupEditViewController()
                                    let segue = UIStoryboardSegue(identifier: "mashUp", source: subject, destination: mashupEditController)
                                    subject.prepare(for: segue, sender: nil)
                                }

                                it("passes the videos to the editing controller") {
                                    expect(mashupEditController.capturedVideosForConfigure).to(equal(videos))
                                }
                            }
                        }

                        context("when there are no videos") {
                            beforeEach {
                                subject.mashButton.isEnabled = true
                                videos = []
                                videoRepository.capturedCallbackForGetVideos?(videos)
                            }

                            it("loads videos into the collection view controller") {
                                expect(videoCollectionViewController.capturedVideosForLoad).to(equal(videos))
                            }

                            it("has a delete callback") {
                                expect(videoCollectionViewController.capturedDeleteCallbackForLoad).toNot(beNil())
                            }

                            it("leaves the mashup button disabled") {
                                expect(subject.mashButton.isEnabled).to(beFalse())
                            }
                        }
                    }
                }

                describe("when adding a video to the mashup") {
                    var cameraViewController: FakeCameraViewController!

                    beforeEach {
                        cameraViewController = FakeCameraViewController()
                        let segue = UIStoryboardSegue(identifier: "addVideo", source: subject, destination: cameraViewController)
                        subject.prepare(for: segue, sender: nil)
                    }

                    it("passes the song to the camera view controller") {
                        expect(cameraViewController.capturedSongForConfigure).to(equal(subject.song()))
                    }
                }
            }
        }
    }
}
