import UIKit
import Quick
import Nimble
import Fleet
@testable import Bangers_and_Mash

class BallDropSpec: QuickSpec {
    override func spec() {
        describe("BallDrop") {
            var subject: BallDrop!
            var scheduler: FakeScheduler!

            beforeEach {
                subject = BallDrop()

                scheduler = FakeScheduler()
                subject.scheduler = scheduler
            }

            describe("starting the ball drop") {
                beforeEach {
                    
                }
            }
        }
    }
}
