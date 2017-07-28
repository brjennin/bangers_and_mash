import UIKit
import Quick
import Nimble
import Fleet
import SwiftyCam
import FontAwesome_swift
@testable import Bangers_and_Mash

class CameraViewControllerSpec: QuickSpec {
    override func spec() {
        describe("CameraViewController") {
            var storyboard: UIStoryboard!
            var subject: CameraViewController!
            var navController: UINavigationController!
            var cameraViewControllerProvider: FakeCameraViewControllerProvider!
            var subviewPresenter: FakeSubviewPresenter!
            var ballDrop: FakeBallDrop!
            var animator: FakeAnimator!
            var scheduler: FakeScheduler!
            var seguePresenter: FakeSeguePresenter!
            var focusTouch: FakeFocusTouch!
            var navigationPoppinOff: FakeNavigationPoppinOff!
            var songPlayer: FakeSongPlayer!
            var youreJustMashingIt: FakeYoureJustMashingIt!

            beforeEach {
                storyboard = UIStoryboard(name: "Main", bundle: nil)
                subject = storyboard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController

                cameraViewControllerProvider = FakeCameraViewControllerProvider()
                subject.cameraViewControllerProvider = cameraViewControllerProvider

                subviewPresenter = FakeSubviewPresenter()
                subject.subviewPresenter = subviewPresenter

                ballDrop = FakeBallDrop()
                subject.ballDrop = ballDrop

                animator = FakeAnimator()
                subject.animator = animator

                scheduler = FakeScheduler()
                subject.scheduler = scheduler

                seguePresenter = FakeSeguePresenter()
                subject.seguePresenter = seguePresenter

                focusTouch = FakeFocusTouch()
                subject.focusTouch = focusTouch

                navigationPoppinOff = FakeNavigationPoppinOff()
                subject.navigationPoppinOff = navigationPoppinOff

                songPlayer = FakeSongPlayer()
                subject.songPlayer = songPlayer

                youreJustMashingIt = FakeYoureJustMashingIt()
                subject.youreJustMashingIt = youreJustMashingIt
            }

            describe("configuring with a song") {
                var song: Song!

                beforeEach {
                    song = Song(name: "name", url: URL(string: "https://example.com")!, recordingStartTime: 2, recordingEndTime: 10)
                    subject.configure(song: song)
                }

                it("loads the song into the player") {
                    expect(songPlayer.capturedSongForLoad).to(equal(song))
                }

                describe("viewDidLoad") {
                    var swiftCamViewController: FakeSwiftyCamViewController!
                    var recordButton: FakeRecordButton!

                    beforeEach {
                        swiftCamViewController = FakeSwiftyCamViewController()
                        cameraViewControllerProvider.returnedControllerForGet = swiftCamViewController

                        navController = UINavigationController(rootViewController: subject)
                        TestViewRenderer.initiateViewLifeCycle(controller: navController)

                        recordButton = FakeRecordButton()
                        subject.captureButton = recordButton
                    }

                    it("starts with countdown hidden") {
                        expect(subject.countdownLabel.isHidden).to(beTrue())
                    }

                    it("gets a swifty camera view controller from the provider") {
                        expect(cameraViewControllerProvider.capturedDelegateForGet).to(be(subject))
                    }

                    it("displays the swifty camera view controller") {
                        expect(subviewPresenter.capturedSuperViewForAdd).to(equal(subject.cameraContainer))
                        expect(subviewPresenter.capturedSubControllerForAdd).to(be(swiftCamViewController))
                        expect(subviewPresenter.capturedParentControllerForAdd).to(be(subject))
                    }

                    it("starts with flash button image being flash off") {
                        expect(subject.flashButton.image(for: .normal)).to(equal(#imageLiteral(resourceName: "flashOutline")))
                    }

                    it("starts with controls enabled") {
                        expect(subject.flashButton.isEnabled).to(beTrue())
                        expect(subject.flipCameraButton.isEnabled).to(beTrue())
                    }

                    describe("toggling flash on") {
                        beforeEach {
                            try? subject.flashButton.tap()
                        }

                        it("updates the image to flash on") {
                            expect(subject.flashButton.image(for: .normal)).to(equal(#imageLiteral(resourceName: "flash")))
                        }

                        it("toggles flash on the swifty cam controller") {
                            expect(swiftCamViewController.flashEnabled).to(beTrue())
                        }

                        describe("toggling flash off") {
                            beforeEach {
                                try? subject.flashButton.tap()
                            }

                            it("updates the image to flash off") {
                                expect(subject.flashButton.image(for: .normal)).to(equal(#imageLiteral(resourceName: "flashOutline")))
                            }

                            it("toggles flash on the swifty cam controller") {
                                expect(swiftCamViewController.flashEnabled).to(beFalse())
                            }
                        }
                    }

                    describe("switching camera") {
                        beforeEach {
                            try? subject.flipCameraButton.tap()
                        }

                        it("calls switch camera") {
                            expect(swiftCamViewController.calledSwitchCamera).to(beTrue())
                        }
                    }

                    describe("capturing video") {
                        beforeEach {
                            subject.didTapCapture(recordButton)
                        }

                        it("disables the record button") {
                            expect(subject.captureButton.isEnabled).to(beFalse())
                        }

                        it("shows the countdown timer") {
                            expect(subject.countdownLabel.isHidden).to(beFalse())
                            expect(subject.countdownLabel.text).to(equal("\(CameraViewController.countdownTime)"))
                        }

                        it("starts the ball drop") {
                            expect(ballDrop.capturedDropTimeForStart).to(equal(TimeInterval(exactly: CameraViewController.countdownTime)))
                        }

                        it("starts playing the song from the countdown") {
                            expect(songPlayer.capturedCountdownForPlaySong).to(equal(TimeInterval(CameraViewController.countdownTime)))
                        }

                        it("leaves flash and switch camera buttons visible") {
                            expect(subject.flashButton.alpha).to(equal(1))
                            expect(subject.flipCameraButton.alpha).to(equal(1))
                        }

                        it("disables controls") {
                            expect(subject.flashButton.isEnabled).to(beFalse())
                            expect(subject.flipCameraButton.isEnabled).to(beFalse())
                        }

                        it("animates") {
                            expect(animator.capturedAnimationsForAnimate).toNot(beNil())
                        }

                        describe("animating") {
                            beforeEach {
                                animator.capturedAnimationsForAnimate?()
                            }

                            it("hides the flash button and flip camera button") {
                                expect(subject.flashButton.alpha).to(equal(0))
                                expect(subject.flipCameraButton.alpha).to(equal(0))
                            }
                        }

                        describe("When counting down") {
                            context("When time is left") {
                                beforeEach {
                                    ballDrop.capturedSecondsLeftCallbackForStart?(1)
                                }

                                it("updates the label text") {
                                    expect(subject.countdownLabel.text).to(equal("1"))
                                }

                                it("does not start recording") {
                                    expect(swiftCamViewController.calledStartVideoRecording).to(beFalse())
                                }

                                it("does not indicate recording has started") {
                                    expect(recordButton.calledIndicateRecording).to(beFalse())
                                }
                            }

                            context("When no time left") {
                                beforeEach {
                                    ballDrop.capturedSecondsLeftCallbackForStart?(0)
                                }

                                it("hides the countdown label") {
                                    expect(subject.countdownLabel.isHidden).to(beTrue())
                                }

                                it("starts recording") {
                                    expect(swiftCamViewController.calledStartVideoRecording).to(beTrue())
                                }

                                it("indicates recording has started") {
                                    expect(recordButton.calledIndicateRecording).to(beTrue())
                                }
                            }
                        }
                    }

                    describe("As a SwiftyCamViewControllerDelegate") {
                        describe("When video begins recording") {
                            beforeEach {
                                scheduler.returnTimerForFireOnce = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { _ in })
                                
                                subject.swiftyCam(SwiftyCamViewController(), didBeginRecordingVideo: .front)
                            }

                            it("does not stop recording until time has elapsed") {
                                expect(swiftCamViewController.calledStopVideoRecording).to(beFalse())
                            }

                            it("starts a timer") {
                                expect(scheduler.capturedSecondsForFireOnce).to(equal(8))
                            }

                            describe("When the timer fires") {
                                beforeEach {
                                    scheduler.capturedBlockForFireOnce?(Timer())
                                }

                                it("stops recording") {
                                    expect(swiftCamViewController.calledStopVideoRecording).to(beTrue())
                                }
                            }
                        }

                        describe("When video finishes recording") {
                            beforeEach {
                                subject.flashButton.alpha = 0
                                subject.flashButton.isEnabled = false
                                subject.flipCameraButton.alpha = 0
                                subject.flipCameraButton.isEnabled = false
                                subject.captureButton.isEnabled = false

                                subject.swiftyCam(SwiftyCamViewController(), didFinishRecordingVideo: .front)
                            }

                            it("indicates no longer recording") {
                                expect(recordButton.calledIndicateRecordingFinished).to(beTrue())
                            }

                            it("stops playing the song") {
                                expect(songPlayer.calledStopSong).to(beTrue())
                            }

                            it("re-enables the capture button") {
                                expect(subject.captureButton.isEnabled).to(beTrue())
                            }

                            it("enables controls") {
                                expect(subject.flashButton.isEnabled).to(beTrue())
                                expect(subject.flipCameraButton.isEnabled).to(beTrue())
                            }

                            it("animates") {
                                expect(animator.capturedAnimationsForAnimate).toNot(beNil())
                            }

                            describe("animating") {
                                beforeEach {
                                    animator.capturedAnimationsForAnimate?()
                                }

                                it("shows the flash button and flip camera button") {
                                    expect(subject.flashButton.alpha).to(equal(1))
                                    expect(subject.flipCameraButton.alpha).to(equal(1))
                                }
                            }
                        }

                        describe("When the video finishes processing") {
                            var url: URL!

                            beforeEach {
                                url = URL(string: "https://example.com/video.mp4")

                                subject.swiftyCam(SwiftyCamViewController(), didFinishProcessVideoAt: url)
                            }

                            it("mashes the song and video") {
                                expect(youreJustMashingIt.capturedSongForCombine).to(equal(song))
                                expect(youreJustMashingIt.capturedVideoUrlForCombine).to(equal(url))
                            }

                            describe("when the song and video have been mashed") {
                                var mashUrl: URL!

                                beforeEach {
                                    mashUrl = URL(string: "https://example.com/mash.mov")

                                    youreJustMashingIt.capturedCompletionForCombine?(mashUrl)
                                }

                                it("triggers the segue") {
                                    expect(seguePresenter.capturedControllerForTrigger).to(be(subject))
                                    expect(seguePresenter.capturedIdentifierForTrigger).to(equal("reviewVideo"))
                                }

                                describe("preparing for segue") {
                                    var reviewViewController: FakeReviewViewController!

                                    beforeEach {
                                        reviewViewController = FakeReviewViewController()
                                        let segue = UIStoryboardSegue(identifier: "reviewVideo", source: subject, destination: reviewViewController)
                                        subject.prepare(for: segue, sender: nil)
                                    }

                                    it("configures the video URL on the review view controller") {
                                        expect(reviewViewController.capturedVideoUrlForConfigure).to(equal(mashUrl))
                                    }

                                    describe("When the user keeps their video take") {
                                        beforeEach {
                                            reviewViewController.capturedVideoKeptCallbackForConfigure?()
                                        }

                                        it("pops back to the mashup view controller") {
                                            expect(navigationPoppinOff.capturedAnimatedForPop).to(beFalse())
                                            expect(navigationPoppinOff.capturedNavControllerForPop).to(be(navController))
                                        }
                                    }
                                }
                            }
                        }
                        
                        describe("When focusing at a point") {
                            var point: CGPoint!
                            
                            beforeEach {
                                point = CGPoint(x: 10, y: 20)
                                
                                subject.swiftyCam(SwiftyCamViewController(), didFocusAtPoint: point)
                            }
                            
                            it("delegates to focus touch") {
                                expect(focusTouch.capturedPointForShowFocus).to(equal(point))
                                expect(focusTouch.capturedViewForShowFocus).to(equal(swiftCamViewController.view))
                            }
                        }
                    }
                }
            }
        }
    }
}
