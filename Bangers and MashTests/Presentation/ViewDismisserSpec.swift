import UIKit
import Quick
import Nimble
import Fleet
@testable import Bangers_and_Mash

class FakeDismissableController: UIViewController {
    var capturedAnimated: Bool?
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        capturedAnimated = flag
    }
}

class ViewDismisserSpec: QuickSpec {
    override func spec() {
        describe("ViewDismisser") {
            var subject: ViewDismisser!

            beforeEach {
                subject = ViewDismisser()
            }

            describe("Dismissing the view controller") {
                var controller: FakeDismissableController!
                beforeEach {
                    controller = FakeDismissableController()
                    subject.dismiss(controller: controller)
                }

                it("calls the dismiss function") {
                    expect(controller.capturedAnimated).to(beTrue())
                }
            }
        }
    }
}
