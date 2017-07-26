import UIKit
import Quick
import Nimble
import Fleet
@testable import Bangers_and_Mash

class VideoCollectionViewControllerSpec: QuickSpec {
    override func spec() {
        describe("VideoCollectionViewController") {
            var subject: VideoCollectionViewController!

            beforeEach {
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                subject = storyboard.instantiateViewController(
                    withIdentifier: "VideoCollectionViewController") as! VideoCollectionViewController
            }

            describe("When the view loads") {
                beforeEach {
                    TestViewRenderer.initiateViewLifeCycle(controller: subject)

                    subject.tableView.register(FakeVideoCell.self, forCellReuseIdentifier: "VideoCell")
                }

                it("makes a table footer view to hide the empty separators in the table") {
                    expect(subject.tableView.tableFooterView).toNot(beNil())
                }

                it("is setup for dynamic content sizes") {
                    expect(subject.tableView.rowHeight).to(equal(UITableViewAutomaticDimension))
                    expect(subject.tableView.estimatedRowHeight).to(equal(120))
                }

                it("sets itself as the data source") {
                    expect(subject.tableView.dataSource).to(beIdenticalTo(subject))
                }

                it("sets itself as the delegate") {
                    expect(subject.tableView.delegate).to(beIdenticalTo(subject))
                }

                describe("As a table view data source") {
                    it("has 1 section") {
                        expect(subject.numberOfSections(in: subject.tableView)).to(equal(1))
                    }

                    it("has no rows in the first section") {
                        expect(subject.tableView(subject.tableView, numberOfRowsInSection: 0)).to(equal(0))
                    }
                }

                describe("Configuring with videos") {
                    let videos = [
                        URL(string: "file:///private/var/mobile/Containers/Data/Application/20067031-DBC0-4DD5-9BCC-2D1D6616B8DF/tmp/videos1.mov")!,
                        URL(string: "file:///private/var/mobile/Containers/Data/Application/20067031-DBC0-4DD5-9BCC-2D1D6616B8DF/tmp/videos2.mov")!
                    ]

                    context("Without deletion") {
                        beforeEach {
                            subject.load(videos: videos)
                        }
                        
                        describe("As a table view data source") {
                            it("has 1 section") {
                                expect(subject.numberOfSections(in: subject.tableView)).to(equal(1))
                            }

                            it("has 2 rows in the first section") {
                                expect(subject.tableView(subject.tableView, numberOfRowsInSection: 0)).to(equal(2))
                            }

                            it("has 2 visible cells") {
                                expect(subject.tableView.visibleCells.count).to(equal(2))
                            }

                            it("makes all of the cells video cells") {
                                for cell in subject.tableView.visibleCells {
                                    expect(cell).to(beAKindOf(VideoCell.self))
                                }
                            }

                            it("configures the video cell with the videos in order") {
                                let cell1 = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! FakeVideoCell
                                expect(cell1.capturedVideoForConfigure).to(equal(videos[0]))

                                let cell2 = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 1, section: 0)) as! FakeVideoCell
                                expect(cell2.capturedVideoForConfigure).to(equal(videos[1]))
                            }
                        }
                    }
                }
            }
        }
    }
}