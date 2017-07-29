import UIKit
import Quick
import Nimble
import Fleet
import CoreMedia
@testable import Bangers_and_Mash

class TimeSplitterSpec: QuickSpec {
    override func spec() {
        describe("TimeSplitter") {
            var subject: TimeSplitter!

            beforeEach {
                subject = TimeSplitter()
            }

            describe("splitting time") {
                var ranges: [CMTimeRange]!

                beforeEach {
                    ranges = subject.timeChunks(duration: CMTime(seconds: 20, preferredTimescale: 1), chunks: 5)
                }

                it("returns 5 ranges") {
                    expect(ranges.count).to(equal(5))
                }

                it("returns consecutive ranges") {
                    let first = ranges.first { range in range.start == kCMTimeZero }
                    expect(first).toNot(beNil())
                    if let first = first {
                        let second = ranges.first { range in range.start == (first.start + first.duration) }
                        expect(second).toNot(beNil())
                        if let second = second {
                            let third = ranges.first { range in range.start == (second.start + second.duration) }
                            expect(third).toNot(beNil())
                            if let third = third {
                                let fourth = ranges.first { range in range.start == (third.start + third.duration) }
                                expect(fourth).toNot(beNil())
                                if let fourth = fourth {
                                    let fif = ranges.first { range in range.start == (fourth.start + fourth.duration) }
                                    expect(fif).toNot(beNil())
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
