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

            describe("generating a new temp url") {
                var url: URL!

                beforeEach {
                    url = subject.generateNewTempFileUrl(extensionString: "mov")
                }

                it("returns a new url every time") {
                    expect(url).toNot(equal(subject.generateNewTempFileUrl(extensionString: "mov")))
                }

                it("returns a url in the temp directory") {
                    let tempDir = url.deletingLastPathComponent()
                    expect(tempDir.absoluteString).to(equal(URL(fileURLWithPath: NSTemporaryDirectory()).absoluteString))
                }

                it("has the correct extension") {
                    expect(url.pathExtension).to(equal("mov"))
                }
            }
        }
    }
}
