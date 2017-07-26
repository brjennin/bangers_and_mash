import UIKit
import Quick
import Nimble
import Fleet
@testable import Bangers_and_Mash

class VideoRepositorySpec: QuickSpec {
    override func spec() {
        describe("VideoRepository") {
            var subject: VideoRepository!
            var directoryFinder: FakeDirectoryFinder!
            var fileManager: FakeFileManager!

            beforeEach {
                subject = VideoRepository()

                directoryFinder = FakeDirectoryFinder()
                subject.directoryFinder = directoryFinder

                fileManager = FakeFileManager()
                subject.fileManager = fileManager
            }

            describe("getting all videos") {
                var videoUrls: [URL]!
                var returnedVideos: [URL]?
                let docsDirectory = URL(fileURLWithPath: "/Documents")

                beforeEach {
                    videoUrls = [
                        URL(string: "file:///private/var/mobile/Containers/Data/Application/20067031-DBC0-4DD5-9BCC-2D1D6616B8DF/tmp/video1.mov")!,
                        URL(string: "file:///private/var/mobile/Containers/Data/Application/20067031-DBC0-4DD5-9BCC-2D1D6616B8DF/tmp/video2.mov")!,
                        URL(string: "file:///private/var/mobile/Containers/Data/Application/20067031-DBC0-4DD5-9BCC-2D1D6616B8DF/tmp/video3.mov")!
                    ]
                    fileManager.returnUrlsForContentsOfDirectory = videoUrls

                    subject.getVideos() { videos in
                        returnedVideos = videos
                    }
                }

                it("gets the contents of the documents directory") {
                    expect(fileManager.capturedUrlForContentsOfDirectory).to(equal(docsDirectory))
                    expect(fileManager.capturedKeysForContentsOfDirectory).to(beNil())
                    expect(fileManager.capturedOptionsForContentsOfDirectory).to(equal([]))
                }

                it("sends the returned videos") {
                    expect(returnedVideos).to(equal(videoUrls))
                }
            }

            describe("deleting a video") {
                var url: URL!

                beforeEach {
                    url = URL(string: "file:///private/var/mobile/Containers/Data/Application/20067031-DBC0-4DD5-9BCC-2D1D6616B8DF/tmp/video1.mov")!

                    subject.delete(url: url)
                }

                it("removes the item with the file manager") {
                    expect(fileManager.capturedUrlForRemoveItem).to(equal(url))
                }
            }
        }
    }
}
