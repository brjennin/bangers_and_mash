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
                var timer: Timer!
                var capturedSecondsLeft: Int?

                beforeEach {
                    timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { _ in })
                    scheduler.returnTimerForFireRepeatedly = timer

                    subject.start(dropTime: 3) { secondsRemaining in
                        capturedSecondsLeft = secondsRemaining
                    }
                }

                afterEach {
                    timer.invalidate()
                }

                it("calls the scheduler repeatedly every second") {
                    expect(scheduler.capturedSecondsForFireRepeatedly).to(equal(1))
                }

                it("calls the callback immediately") {
                    expect(capturedSecondsLeft).to(equal(3))
                }

                it("keeps the timer valid") {
                    expect(timer?.isValid).to(beTrue())
                }

                describe("When the scheduler notifies a second has elapsed") {
                    beforeEach {
                        scheduler.capturedBlockForFireRepeatedly?(timer)
                    }

                    it("calls the callback with one less second") {
                        expect(capturedSecondsLeft).to(equal(2))
                    }

                    it("keeps the timer valid") {
                        expect(timer.isValid).to(beTrue())
                    }

                    describe("When the scheduler fires again") {
                        beforeEach {
                            scheduler.capturedBlockForFireRepeatedly?(timer)
                        }

                        it("calls the callback with one less second") {
                            expect(capturedSecondsLeft).to(equal(1))
                        }

                        it("keeps the timer valid") {
                            expect(timer.isValid).to(beTrue())
                        }

                        describe("When the scheduler fires again") {
                            beforeEach {
                                scheduler.capturedBlockForFireRepeatedly?(timer)
                            }

                            it("calls the callback with one less second") {
                                expect(capturedSecondsLeft).to(equal(0))
                            }

                            it("keeps the timer valid") {
                                expect(timer.isValid).to(beFalse())
                            }
                        }
                    }
                }
            }
        }
    }
}
