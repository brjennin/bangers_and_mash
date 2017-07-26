import UIKit
import Quick
import Nimble
import Fleet
@testable import Bangers_and_Mash

class DirectoryFinderSpec: QuickSpec {
    override func spec() {
        describe("DirectoryFinder") {
            var subject: DirectoryFinder!

            beforeEach {
                subject = DirectoryFinder()
            }

            describe("Returning the documents directory") {
                var url: URL!

                beforeEach {
                    url = subject.getDocumentsDirectory()
                }

                it("returns a file url for the documents folder") {
                    let documentsDirectoryString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                    let documentsDirectory = URL(fileURLWithPath: documentsDirectoryString)
                    expect(url).to(equal(documentsDirectory))
                }
            }
        }
    }
}
