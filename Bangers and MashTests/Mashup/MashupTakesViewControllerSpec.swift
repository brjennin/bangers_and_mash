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

            beforeEach {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                subject = storyboard.instantiateViewController(withIdentifier: "MashupTakesViewController") as! MashupTakesViewController
            }

            describe("viewDidLoad") {
                beforeEach {
                    TestViewRenderer.initiateViewLifeCycle(controller: subject)
                }

                it("sets the button to be a fontawesome button") {
                    expect(subject.addVideoButton.title(for: .normal)).to(equal(String.fontAwesomeIcon(name: .plusCircle)))
                }
            }
        }
    }
}
