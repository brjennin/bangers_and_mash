import UIKit
import Quick
import Nimble
import Fleet
@testable import Bangers_and_Mash

class VideoCellSpec: QuickSpec {
    override func spec() {
        describe("VideoCell") {
            var subject: VideoCell!
            var previewBuilder: FakePreviewBuilder!
            var videoThumbImageView: UIImageView!

            beforeEach {
                subject = VideoCell()

                previewBuilder = FakePreviewBuilder()
                subject.previewBuilder = previewBuilder

                videoThumbImageView = UIImageView()
                subject.videoThumbImageView = videoThumbImageView
            }

            describe("Configuring for a video") {
                var video: URL!

                beforeEach {
                    video = URL(string: "file:///private/var/mobile/Containers/Data/Application/20067031-DBC0-4DD5-9BCC-2D1D6616B8DF/tmp/video1.mov")!

                    previewBuilder.returnImageForImage = #imageLiteral(resourceName: "focus")

                    subject.configure(video: video)
                }

                it("generates a preview image from the video url") {
                    expect(previewBuilder.capturedUrlForImage).to(equal(video))
                }

                it("sets the image view image") {
                    expect(subject.videoThumbImageView.image).to(equal(#imageLiteral(resourceName: "focus")))
                }
            }
        }
    }
}
