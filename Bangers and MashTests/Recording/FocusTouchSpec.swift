import UIKit
import Quick
import Nimble
import Fleet
@testable import Bangers_and_Mash

class FocusTouchSpec: QuickSpec {
    override func spec() {
        describe("FocusTouch") {
            var subject: FocusTouch!
            var subviewPresenter: FakeSubviewPresenter!
            var animator: FakeAnimator!

            beforeEach {
                subject = FocusTouch()

                subviewPresenter = FakeSubviewPresenter()
                subject.subviewPresenter = subviewPresenter

                animator = FakeAnimator()
                subject.animator = animator
            }

            describe("showing focus") {
                var point: CGPoint!
                var view: UIView!
                var focusImageView: UIImageView!

                beforeEach {
                    point = CGPoint(x: 30, y: 50)
                    view = UIView(frame: CGRect(x: 5, y: 10, width: 200, height: 400))

                    subject.showFocus(at: point, in: view)

                    focusImageView = subviewPresenter.capturedSubviewForAddView as! UIImageView
                }

                it("adds an image subview at the point") {
                    expect(subviewPresenter.capturedParentViewForAddView).to(equal(view))
                    expect(focusImageView.image).to(equal(#imageLiteral(resourceName: "focus")))
                    expect(focusImageView.center).to(equal(point))
                    expect(focusImageView.alpha).to(equal(0))
                }

                it("animates the focus view in") {
                    expect(animator.capturedDurationForAnimate).to(equal(FocusTouch.focusAnimationDurationIn))
                    expect(animator.capturedDelayForAnimate).to(equal(0))
                    expect(animator.capturedOptionsForAnimate).to(equal(UIViewAnimationOptions.curveEaseInOut))
                }

                describe("animating") {
                    var originalSize: CGSize!

                    beforeEach {
                        originalSize = focusImageView.frame.size

                        animator.capturedAnimationsForAnimate?()
                    }

                    it("makes the focus image visible") {
                        expect(focusImageView.alpha).to(equal(1))
                    }

                    it("enlarges the focus image") {
                        expect(focusImageView.frame.size.width).to(beGreaterThan(originalSize.width))
                        expect(focusImageView.frame.size.height).to(beGreaterThan(originalSize.height))
                    }

                    describe("on completion") {
                        beforeEach {
                            let completion = animator.capturedCompletionForAnimate
                            animator.reset()

                            completion?(true)
                        }

                        it("animates the focus view out") {
                            expect(animator.capturedDurationForAnimate).to(equal(FocusTouch.focusAnimationDurationOut))
                            expect(animator.capturedDelayForAnimate).to(equal(FocusTouch.focusAnimationDelayOut))
                            expect(animator.capturedOptionsForAnimate).to(equal(UIViewAnimationOptions.curveEaseInOut))
                        }

                        describe("animating") {
                            var enlargedSize: CGSize!

                            beforeEach {
                                enlargedSize = focusImageView.frame.size

                                animator.capturedAnimationsForAnimate?()
                            }

                            it("makes the focus image hidden") {
                                expect(focusImageView.alpha).to(equal(0))
                            }

                            it("shrinks the focus image") {
                                expect(focusImageView.frame.size.width).to(beLessThan(enlargedSize.width))
                                expect(focusImageView.frame.size.height).to(beLessThan(enlargedSize.height))
                            }

                            describe("on completion") {
                                beforeEach {
                                    animator.capturedCompletionForAnimate?(true)
                                }

                                it("removes the focus view from the parent") {
                                    expect(subviewPresenter.capturedViewForRemove).to(equal(focusImageView))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
