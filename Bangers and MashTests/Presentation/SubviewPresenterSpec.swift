import UIKit
import Quick
import Nimble
import Fleet
@testable import Bangers_and_Mash

class MoveableParentViewController: UIViewController {
    var capturedMoveController: UIViewController?
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        capturedMoveController = parent
    }
}

class SubviewPresenterSpec: QuickSpec {
    override func spec() {
        describe("SubviewPresenter") {
            var subject: SubviewPresenter!

            beforeEach {
                subject = SubviewPresenter()
            }

            describe("Presenting a controller into a view") {
                var subController: MoveableParentViewController!
                var superController: UIViewController!
                var superView: UIView!

                beforeEach {
                    subController = MoveableParentViewController()
                    subController.view.frame = CGRect(x: 1, y: 2, width: 3, height: 4)
                    superController = UIViewController()
                    superView = superController.view

                    TestViewRenderer.initiateViewLifeCycle(controller: superController)

                    subject.add(subController: subController, toController: superController, view: superView)
                }

                it("adds the subview") {
                    expect(superView.subviews).to(equal([subController.view]))
                }

                it("adds as a child view controller") {
                    expect(superController.childViewControllers).to(equal([subController]))
                }

                it("calls did move to parent") {
                    expect(subController.capturedMoveController).to(equal(superController))
                }

                it("turns off autoresizing mask into constraints") {
                    expect(subController.view.translatesAutoresizingMaskIntoConstraints).to(beFalse())
                }

                it("creates autoresizing constraints") {
                    expect(superView.constraints.count).to(equal(4))
                    let subview = subController.view!

                    var top: NSLayoutConstraint!
                    var bottom: NSLayoutConstraint!
                    var left: NSLayoutConstraint!
                    var right: NSLayoutConstraint!
                    for constraint in superView.constraints {
                        switch constraint.firstAttribute {
                        case .top:
                            top = constraint
                        case .bottom:
                            bottom = constraint
                        case .trailing:
                            right = constraint
                        case .leading:
                            left = constraint
                        default:
                            expect(false).to(beTrue())
                        }
                    }

                    for constraint in [top!, bottom!, left!, right!] {
                        expect(constraint.firstItem as? UIView).to(equal(subview))
                        expect(constraint.secondItem as? UIView).to(equal(superView))
                        expect(constraint.secondAttribute).to(equal(constraint.firstAttribute))
                        expect(constraint.relation).to(equal(NSLayoutRelation.equal))
                        expect(constraint.multiplier).to(equal(1))
                        expect(constraint.constant).to(equal(0))
                    }
                }
            }

            describe("presenting a subview in another view") {
                var superView: UIView!
                var subView: UIView!

                beforeEach {
                    superView = UIView(frame: CGRect(x: 5, y: 6, width: 10, height: 20))
                    subView = UIView(frame: CGRect(x: 1, y: 2, width: 5, height: 7))

                    subject.add(subview: subView, to: superView)
                }

                it("adds the sub view to the parent's subviews") {
                    expect(superView.subviews).to(contain(subView))
                }

                describe("removing a subview") {
                    beforeEach {
                        subject.remove(subview: subView)
                    }

                    it("removes the subview") {
                        expect(superView.subviews).toNot(contain(subView))
                    }
                }
            }
        }
    }
}
