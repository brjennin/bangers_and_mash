import UIKit
import Quick
import Nimble
import Fleet
@testable import Bangers_and_Mash

class ArrayBangersAndMashSpec: QuickSpec {
    override func spec() {
        describe("Array") {
            describe("get item at") {
                it("returns the item if it exists") {
                    let array = ["a", "b", "c"]
                    expect(array.get(0)).to(equal("a"))
                    expect(array.get(1)).to(equal("b"))
                    expect(array.get(2)).to(equal("c"))
                    expect(array.get(3)).to(beNil())
                }
            }
        }
    }
}
