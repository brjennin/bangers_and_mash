import UIKit
import Quick
import Nimble
import Fleet
import AVKit
import AVFoundation
@testable import Bangers_and_Mash

class VideoPlayerViewControllerSpec: QuickSpec {
    override func spec() {
        describe("VideoPlayerViewController") {
            var subject: VideoPlayerViewController!
            var avPlayerProvider: FakeAVPlayerProvider!
            var subviewPresenter: FakeSubviewPresenter!
            var notificationCenter: FakeNotificationCenter!

            beforeEach {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                subject = storyboard.instantiateViewController(withIdentifier: "VideoPlayerViewController") as! VideoPlayerViewController

                avPlayerProvider = FakeAVPlayerProvider()
                subject.avPlayerProvider = avPlayerProvider

                subviewPresenter = FakeSubviewPresenter()
                subject.subviewPresenter = subviewPresenter

                notificationCenter = FakeNotificationCenter()
                subject.notificationCenter = notificationCenter
            }

            describe("loading a video url") {
                let url = URL(string: "https://example.com/video.mp4")!
                var player: FakeAVPlayer!
                var currentItem: AVPlayerItem!

                beforeEach {
                    player = FakeAVPlayer()
                    currentItem = AVPlayerItem(url: url)
                    player.currentItem = currentItem

                    avPlayerProvider.returnedPlayerForGet = player
                    
                    subject.load(videoUrl: url)
                }

                it("loads the video into the player") {
                    expect(avPlayerProvider.capturedUrlForGet).to(equal(url))
                }

                it("sets the player") {
                    expect(subject.player).to(be(player))
                }

                it("sets the player controller") {
                    expect(subject.playerController).toNot(beNil())
                }

                it("disables playback controls") {
                    expect(subject.playerController.showsPlaybackControls).to(beFalse())
                }

                it("sets the player controller player") {
                    expect(subject.playerController.player).to(be(player))
                }

                describe("view did load") {
                    beforeEach {
                        TestViewRenderer.initiateViewLifeCycle(controller: subject)
                    }

                    it("presents a player controller in the view") {
                        expect(subviewPresenter.capturedSuperViewForAdd).to(equal(subject.view))
                        expect(subviewPresenter.capturedSubControllerForAdd).to(be(subject.playerController))
                        expect(subviewPresenter.capturedParentControllerForAdd).to(be(subject))
                    }

                    it("sets up a notification for when the player ends") {
                        expect(notificationCenter.capturedObserverOptionsForAdding.count).to(equal(1))
                        let observerOption = notificationCenter.capturedObserverOptionsForAdding.get(0)
                        expect(observerOption?.observer).to(be(subject))
                        expect(observerOption?.selector).to(equal(#selector(VideoPlayerViewController.didReachEnd)))
                        expect(observerOption?.name).to(be(NSNotification.Name.AVPlayerItemDidPlayToEndTime))
                        expect(observerOption?.object).to(be(currentItem))
                    }

                    describe("view did appear") {
                        beforeEach {
                            subject.viewDidAppear(true)
                        }

                        it("plays the video") {
                            expect(player.calledPlay).to(beTrue())
                        }

                        describe("when the video plays to the end") {
                            beforeEach {
                                player.reset()

                                subject.didReachEnd(Notification(name: .AVPlayerItemDidPlayToEndTime))
                            }

                            it("seeks to the begining of the video") {
                                expect(player.capturedTimeForSeek).to(equal(kCMTimeZero))
                            }

                            it("calls play") {
                                expect(player.calledPlay).to(beTrue())
                            }
                        }

                        describe("when the view disappears") {
                            beforeEach {
                                subject.viewDidDisappear(false)
                            }

                            it("pauses the player") {
                                expect(player.calledPause).to(beTrue())
                            }
                        }
                    }
                }
            }
        }
    }
}
