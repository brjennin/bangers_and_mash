import UIKit
import Quick
import Nimble
import Fleet
@testable import Bangers_and_Mash

class RecordButtonSpec: QuickSpec {
    override func spec() {
        describe("RecordButton") {
            var subject: RecordButton!
            var animator: FakeAnimator!

            beforeEach {
                subject = RecordButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))

                animator = FakeAnimator()
                subject.animator = animator
            }

            describe("drawing the button") {
                var circleBorder: CALayer!

                beforeEach {
                    circleBorder = subject.layer.sublayers?.first
                }

                it("makes the background color clear") {
                    expect(subject.backgroundColor).to(equal(UIColor.clear))
                }

                it("draws the button") {
                    expect(subject.layer.sublayers?.count).to(equal(1))
                }

                describe("making the circle border") {
                    it("has a clear background color") {
                        expect(circleBorder.backgroundColor).to(equal(UIColor.clear.cgColor))
                    }

                    it("creates a border") {
                        expect(circleBorder.borderColor).to(equal(UIColor.white.cgColor))
                        expect(circleBorder.borderWidth).to(equal(RecordButton.borderWidth))
                    }

                    it("sets the bounds to be the same as the button") {
                        expect(circleBorder.bounds).to(equal(subject.bounds))
                    }

                    it("positions it in the center of the view") {
                        expect(circleBorder.position).to(equal(CGPoint(x: 15, y: 15)))
                    }

                    it("creates a circle with the corner radius") {
                        expect(circleBorder.cornerRadius).to(equal(15))
                    }
                }

                describe("indicating recording is happening") {
                    var recordCircle: UIView!

                    beforeEach {
                        subject.indicateRecording()

                        recordCircle = subject.subviews.first
                    }

                    it("makes a red recording circle") {
                        expect(subject.subviews.count).to(equal(1))
                    }

                    it("animates with an ease out") {
                        expect(animator.capturedDurationForAnimate).to(equal(RecordButton.recordGrowDuration))
                        expect(animator.capturedDelayForAnimate).to(equal(0))
                        expect(animator.capturedOptionsForAnimate).to(equal(UIViewAnimationOptions.curveEaseOut))
                    }

                    describe("red record circle") {
                        it("is red and centered in the middle of the button") {
                            expect(recordCircle.backgroundColor).to(equal(UIColor.red))
                            expect(recordCircle.center).to(equal(CGPoint(x: 15, y: 15)))
                        }

                        it("clips to bounds") {
                            expect(recordCircle.clipsToBounds).to(beTrue())
                        }

                        it("starts small") {
                            expect(recordCircle.frame.size.width).to(equal(1))
                            expect(recordCircle.frame.size.height).to(equal(1))
                        }

                        it("sets the corner radius to be half its width") {
                            expect(recordCircle.layer.cornerRadius).to(equal(0.5))
                        }
                    }
                    
                    describe("animating") {
                        beforeEach {
                            animator.capturedAnimationsForAnimate?()
                        }
                        
                        it("scales the record button") {
                            expect(recordCircle.frame.size.width).to(beCloseTo(RecordButton.recordButtonScale))
                            expect(recordCircle.frame.size.height).to(beCloseTo(RecordButton.recordButtonScale))
                        }
                        
                        it("scales the circle border") {
                            expect(circleBorder.frame.size.width).to(beCloseTo(RecordButton.outerBorderScale * 30))
                            expect(circleBorder.frame.size.height).to(beCloseTo(RecordButton.outerBorderScale * 30))
                        }

                        it("adjusts the border width") {
                            expect(circleBorder.borderWidth).to(beCloseTo(RecordButton.borderWidth / RecordButton.outerBorderScale))
                        }

                        describe("indicating recording finished") {
                            beforeEach {
                                animator.reset()
                                subject.indicateRecordingFinished()
                            }

                            it("animates") {
                                expect(animator.capturedDurationForAnimate).to(equal(RecordButton.recordShrinkDuration))
                                expect(animator.capturedDelayForAnimate).to(equal(0))
                                expect(animator.capturedOptionsForAnimate).to(equal(UIViewAnimationOptions.curveEaseOut))
                            }

                            describe("animating") {
                                beforeEach {
                                    animator.capturedAnimationsForAnimate?()
                                }

                                it("scales the record circle back to its normal size") {
                                    expect(recordCircle.frame.size.width).to(beCloseTo(1))
                                    expect(recordCircle.frame.size.height).to(beCloseTo(1))
                                }

                                it("scales the border back to its normal size") {
                                    expect(circleBorder.frame.size.width).to(beCloseTo(30))
                                    expect(circleBorder.frame.size.height).to(beCloseTo(30))
                                }

                                it("sets the border width back") {
                                    expect(circleBorder.borderWidth).to(equal(RecordButton.borderWidth))
                                }

                                describe("animation completion") {
                                    beforeEach {
                                        animator.capturedCompletionForAnimate?(true)
                                    }

                                    it("removes the record button from the superview") {
                                        expect(subject.subviews.count).to(equal(0))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
