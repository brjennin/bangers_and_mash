import UIKit
import Quick
import Nimble
import Fleet
@testable import Bangers_and_Mash

class RandomPickerSpec: QuickSpec {
    override func spec() {
        describe("RandomPicker") {
            var subject: RandomPicker!

            beforeEach {
                subject = RandomPicker()
            }

            describe("getting a random item from an array") {
                var list: [Int]!
                var results: Set<Int>!

                beforeEach {
                    list = [1,2,3,4,5]
                    results = Set<Int>()
                    for _ in 1...10 {
                        results.insert(subject.pick(from: list))
                    }
                }

                it("picks from the list") {
                    results.forEach( { result in expect(list).to(contain(result)) } )
                }

                it("returns different items randomly") {
                    expect(results.count).to(beGreaterThan(1))
                }
            }
        }
    }
}
