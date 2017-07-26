import UIKit
import Quick
import Nimble
import Fleet
@testable import Bangers_and_Mash

class VideoCellSpec: QuickSpec {
    override func spec() {
        describe("VideoCell") {
            var subject: VideoCell!
            var titleLabel: UILabel!

            beforeEach {
                subject = VideoCell()

                titleLabel = UILabel()
                subject.titleLabel = titleLabel
            }

            describe("Configuring for a video") {
                var video: URL!

                beforeEach {
                    video = URL(string: "file:///private/var/mobile/Containers/Data/Application/20067031-DBC0-4DD5-9BCC-2D1D6616B8DF/tmp/video1.mov")!
                    subject.configure(video: video)
                }

                it("sets the title label") {
                    expect(subject.titleLabel.text).to(equal("video1"))
                }
            }
        }
    }
}
