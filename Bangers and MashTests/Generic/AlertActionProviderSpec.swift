import UIKit
import Quick
import Nimble
import Fleet
@testable import Bangers_and_Mash

class AlertActionProviderSpec: QuickSpec {
    override func spec() {
        describe("AlertActionProvider") {
            var subject: AlertActionProvider!

            beforeEach {
                subject = AlertActionProvider()
            }

            describe("Providing an alert action") {
                var title: String!
                var style: UIAlertActionStyle!
                var result: UIAlertAction!

                beforeEach {
                    title = "title"
                    style = UIAlertActionStyle.destructive
                    result = subject.buildAction(title: title, style: style) { _ in }
                }

                it("builds the alert action") {
                    expect(result.title).to(equal(title))
                    expect(result.style).to(equal(style))
                }

                it("returns an enabled action") {
                    expect(result.isEnabled).to(beTrue())
                }
            }
        }
    }
}
