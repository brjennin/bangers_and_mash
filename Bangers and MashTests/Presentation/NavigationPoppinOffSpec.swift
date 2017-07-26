import UIKit
import Quick
import Nimble
import Fleet
@testable import Bangers_and_Mash

class FakeNavigationController: UINavigationController {
    var capturedAnimated: Bool?
    override func popViewController(animated: Bool) -> UIViewController? {
        capturedAnimated = animated

        return nil
    }
}

class NavigationPoppinOffSpec: QuickSpec {
    override func spec() {
        describe("NavigationPoppinOff") {
            var subject: NavigationPoppinOff!

            beforeEach {
                subject = NavigationPoppinOff()
            }

            describe("Dismissing the view controller") {
                var controller: FakeNavigationController!

                beforeEach {
                    controller = FakeNavigationController()
                }

                context("when animating") {
                    beforeEach {
                        subject.pop(from: controller, animated: true)
                    }

                    it("calls the dismiss function") {
                        expect(controller.capturedAnimated).to(beTrue())
                    }
                }

                context("without animating") {
                    beforeEach {
                        subject.pop(from: controller, animated: false)
                    }

                    it("calls the dismiss function") {
                        expect(controller.capturedAnimated).to(beFalse())
                    }
                }
            }
        }
    }
}
