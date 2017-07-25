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
            var cameraViewControllerProvider: FakeCameraViewControllerProvider!
            var subviewPresenter: FakeSubviewPresenter!
            var ballDrop: FakeBallDrop!
            var animator: FakeAnimator!
            var scheduler: FakeScheduler!
            var seguePresenter: FakeSeguePresenter!

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
            }

            describe("viewDidLoad") {
                var swiftCamViewController: FakeSwiftyCamViewController!
                var recordButton: FakeRecordButton!

                beforeEach {
                    swiftCamViewController = FakeSwiftyCamViewController()
                    cameraViewControllerProvider.returnedControllerForGet = swiftCamViewController

                    TestViewRenderer.initiateViewLifeCycle(controller: subject)

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
                    expect(subject.flashButton.imageView?.image).to(equal(#imageLiteral(resourceName: "flashOutline")))
                }

                describe("toggling flash on") {
                    beforeEach {
                        try? subject.flashButton.tap()
                    }

                    it("updates the image to flash on") {
                        expect(subject.flashButton.imageView?.image).to(equal(#imageLiteral(resourceName: "flash")))
                    }

                    it("toggles flash on the swifty cam controller") {
                        expect(swiftCamViewController.flashEnabled).to(beTrue())
                    }

                    describe("toggling flash off") {
                        beforeEach {
                            try? subject.flashButton.tap()
                        }

                        it("updates the image to flash off") {
                            expect(subject.flashButton.imageView?.image).to(equal(#imageLiteral(resourceName: "flashOutline")))
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

                            it("does not animate anything") {
                                expect(animator.capturedAnimationsForAnimate).to(beNil())
                            }

                            it("leaves flash and switch camera buttons visible") {
                                expect(subject.flashButton.alpha).to(equal(1))
                                expect(subject.flipCameraButton.alpha).to(equal(1))
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

                            it("leaves flash and switch camera buttons visible") {
                                expect(subject.flashButton.alpha).to(equal(1))
                                expect(subject.flipCameraButton.alpha).to(equal(1))
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
                        }
                    }
                }

                describe("As a SwiftyCamViewControllerDelegate") {
                    describe("When video begins recording") {
                        beforeEach {
                            subject.swiftyCam(SwiftyCamViewController(), didBeginRecordingVideo: .front)
                        }

                        it("does not stop recording until time has elapsed") {
                            expect(swiftCamViewController.calledStopVideoRecording).to(beFalse())
                        }

                        it("starts a timer") {
                            expect(scheduler.capturedSecondsForFireOnce).to(equal(CameraViewController.videoDuration))
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
                            subject.flipCameraButton.alpha = 0

                            subject.swiftyCam(SwiftyCamViewController(), didFinishRecordingVideo: .front)
                        }

                        it("indicates no longer recording") {
                            expect(recordButton.calledIndicateRecordingFinished).to(beTrue())
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
                        var reviewViewController: FakeReviewViewController!

                        beforeEach {
                            url = URL(string: "https://example.com/video.mp4")

                            reviewViewController = try! storyboard.mockIdentifier("ReviewViewController", usingMockFor: FakeReviewViewController.self)


                            subject.swiftyCam(SwiftyCamViewController(), didFinishProcessVideoAt: url)
                        }

//                        it("triggers the segue") {
//                            expect(seguePresenter.capturedControllerForTrigger).to(be(subject))
//                            expect(seguePresenter.capturedIdentifierForTrigger).to(equal("reviewVideo"))
//                        }
                        it("presents the review view controller") {
//                            expect(subject.pre)
                        }
                    }
                }
            }
        }
    }
}
