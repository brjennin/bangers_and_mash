import UIKit
import Quick
import Nimble
import Fleet
@testable import Bangers_and_Mash

class ConfirmationDialogProviderSpec: QuickSpec {
    override func spec() {
        describe("ConfirmationDialogProvider") {
            var subject: ConfirmationDialogProvider!
            var alertActionProvider: FakeAlertActionProvider!

            beforeEach {
                subject = ConfirmationDialogProvider()

                alertActionProvider = FakeAlertActionProvider()
                subject.alertActionProvider = alertActionProvider
            }

            describe("Providing an alert action") {
                var title: String!
                var message: String!
                var confirmOption: String!
                var denyOption: String?
                var controller: UIViewController!
                var capturedCalledCompletion: Bool?
                var confirmAction: UIAlertAction!
                var denyAction: UIAlertAction!

                beforeEach {
                    title = "title"
                    message = "message"
                    confirmOption = "YES"
                    controller = UIViewController()
                    TestViewRenderer.initiateViewLifeCycle(controller: controller)
                    capturedCalledCompletion = nil

                    confirmAction = TestFixtures.testAlertAction()
                }

                sharedExamples("presenting a confirmation dialog") {
                    it("presents an alert controller") {
                        expect(controller.presentedViewController).toNot(beNil())
                        expect(controller.presentedViewController).to(beAKindOf(UIAlertController.self))
                        let alertController = controller.presentedViewController! as! UIAlertController
                        expect(alertController.title).to(equal(title))
                        expect(alertController.message).to(equal(message))
                        expect(alertController.preferredStyle).to(equal(UIAlertControllerStyle.alert))
                    }

                    it("builds a confirm action") {
                        let confirmAction = alertActionProvider.capturedOptions[0]
                        expect(confirmAction.title).to(equal("YES"))
                        expect(confirmAction.style).to(equal(UIAlertActionStyle.default))
                    }

                    it("does not call the completion until option is selected") {
                        expect(capturedCalledCompletion).to(beNil())
                    }

                    describe("handling saying yes") {
                        beforeEach {
                            alertActionProvider.capturedOptions[0].handler!(confirmAction)
                        }

                        it("calls the completion with true") {
                            expect(capturedCalledCompletion).to(beTrue())
                        }
                    }
                }

                context("When there is a deny button") {
                    beforeEach {
                        denyOption = "NO"
                        denyAction = TestFixtures.testAlertAction()
                        alertActionProvider.returnedActions = [confirmAction, denyAction]

                        subject.buildDialog(title: title, message: message, confirmOptionTitle: confirmOption, denyOptionTitle: denyOption, controller: controller) { confirmation in
                            capturedCalledCompletion = confirmation
                        }
                    }

                    itBehavesLike("presenting a confirmation dialog")

                    it("builds a deny action") {
                        let denyAction = alertActionProvider.capturedOptions[1]
                        expect(denyAction.title).to(equal("NO"))
                        expect(denyAction.style).to(equal(UIAlertActionStyle.default))
                    }

                    describe("handling saying no") {
                        beforeEach {
                            alertActionProvider.capturedOptions[1].handler!(denyAction)
                        }

                        it("calls the completion with true") {
                            expect(capturedCalledCompletion).to(beFalse())
                        }
                    }
                }

                context("Without a deny button") {
                    beforeEach {
                        denyOption = nil
                        alertActionProvider.returnedActions = [confirmAction]

                        subject.buildDialog(title: title, message: message, confirmOptionTitle: confirmOption, denyOptionTitle: denyOption, controller: controller) { confirmation in
                            capturedCalledCompletion = confirmation
                        }
                    }
                    
                    itBehavesLike("presenting a confirmation dialog")
                }
            }
        }
    }
}
