import UIKit
import Quick
import Nimble
import Fleet
@testable import Bangers_and_Mash

class VideoArchiverSpec: QuickSpec {
    override func spec() {
        describe("VideoArchiver") {
            var subject: VideoArchiver!
            var directoryFinder: FakeDirectoryFinder!
            var fileManager: FakeFileManager!

            beforeEach {
                subject = VideoArchiver()

                directoryFinder = FakeDirectoryFinder()
                subject.directoryFinder = directoryFinder

                fileManager = FakeFileManager()
                subject.fileManager = fileManager
            }

            describe("persisting a temp url") {
                let tempUrl = URL(string: "file:///private/var/mobile/Containers/Data/Application/20067031-DBC0-4DD5-9BCC-2D1D6616B8DF/tmp/34401EA2-3EF2-4EC8-8169-6553CC8ACFFB.mov")!

                beforeEach {
                    subject.persist(tempUrl: tempUrl)
                }

                it("moves the file to the documents directory") {
                    expect(fileManager.capturedSrcUrlForMoveItem).to(equal(tempUrl))
                    var destinationURL = URL(fileURLWithPath: "/Documents")
                    destinationURL.appendPathComponent("34401EA2-3EF2-4EC8-8169-6553CC8ACFFB.mov")
                    expect(fileManager.capturedDstUrlForMoveItem).to(equal(destinationURL))
                }
            }
        }
    }
}
