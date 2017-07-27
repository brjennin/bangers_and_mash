import UIKit
import Quick
import Nimble
import Fleet
@testable import Bangers_and_Mash

class SongSpec: QuickSpec {
    override func spec() {
        describe("Song") {
            var subject: Song!
            let url = URL(string: "https://example.com/song.mp3")!
            let name = "Wild Thoughts"

            describe("Initialization") {
                it("defaults the recording start time and end time") {
                    subject = Song(name: name, url: url)
                    expect(subject.name).to(equal(name))
                    expect(subject.url).to(equal(url))
                    expect(subject.recordingStartTime).to(equal(TimeInterval(CameraViewController.countdownTime)))
                    expect(subject.recordingEndTime).to(equal(TimeInterval(CameraViewController.countdownTime) + Song.defaultDuration))
                    expect(subject.recordDuration).to(equal(Song.defaultDuration))
                }

                it("allows specification of start time with default end time") {
                    subject = Song(name: name, url: url, recordingStartTime: 10)
                    expect(subject.name).to(equal(name))
                    expect(subject.url).to(equal(url))
                    expect(subject.recordingStartTime).to(equal(10))
                    expect(subject.recordingEndTime).to(equal(10 + Song.defaultDuration))
                    expect(subject.recordDuration).to(equal(Song.defaultDuration))
                }

                it("allows specification of start time and end time") {
                    subject = Song(name: name, url: url, recordingStartTime: 10, recordingEndTime: 15)
                    expect(subject.name).to(equal(name))
                    expect(subject.url).to(equal(url))
                    expect(subject.recordingStartTime).to(equal(10))
                    expect(subject.recordingEndTime).to(equal(15))
                    expect(subject.recordDuration).to(equal(5))
                }
            }

            describe("equality") {
                it("returns true when 2 songs have the same url") {
                    expect(Song(name: name, url: url) == Song(name: name, url: url)).to(beTrue())
                }

                it("returns false when 2 songs have different urls") {
                    expect(Song(name: name, url: url) == Song(name: name, url: URL(string: "https://example.com/song2.mp3")!)).to(beFalse())
                }
            }
        }
    }
}
