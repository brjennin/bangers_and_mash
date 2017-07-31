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

                    sharedExamples("loading videos into the table") {
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

                    context("With deletion") {
                        var capturedUrlForDeleteCallback: URL?
                        var capturedVideosForDeleteCallback: [URL]?

                        beforeEach {
                            capturedUrlForDeleteCallback = nil
                            capturedVideosForDeleteCallback = nil
                            subject.load(videos: videos, deleteCallback: { url, videos in
                                capturedUrlForDeleteCallback = url
                                capturedVideosForDeleteCallback = videos
                            })
                        }

                        itBehavesLike("loading videos into the table")

                        it("allows editing of rows") {
                            expect(subject.tableView(subject.tableView, canEditRowAt: IndexPath(row: 0, section: 0))).to(beTrue())
                        }

                        context("When action was a deletion") {
                            beforeEach {
                                subject.tableView(subject.tableView, commit: .delete, forRowAt: IndexPath(row: 1, section: 0))
                            }

                            it("calls deletion callback") {
                                expect(capturedUrlForDeleteCallback).to(equal(videos.last!))
                            }

                            it("hides the visible cell") {
                                expect(subject.tableView.visibleCells.count).to(equal(1))
                            }

                            it("doesn't come back when reloading the table data") {
                                subject.tableView.reloadData()
                                expect(subject.tableView.visibleCells.count).to(equal(1))
                            }

                            it("tells the callback there are videos left") {
                                expect(capturedVideosForDeleteCallback).to(equal([videos.first!]))
                            }

                            describe("deleting the last video") {
                                beforeEach {
                                    subject.tableView(subject.tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))
                                }

                                it("calls deletion callback") {
                                    expect(capturedUrlForDeleteCallback).to(equal(videos.first!))
                                }

                                it("hides the visible cell") {
                                    expect(subject.tableView.visibleCells.count).to(equal(0))
                                }

                                it("doesn't come back when reloading the table data") {
                                    subject.tableView.reloadData()
                                    expect(subject.tableView.visibleCells.count).to(equal(0))
                                }

                                it("tells the callback there are no more videos left") {
                                    expect(capturedVideosForDeleteCallback).to(equal([]))
                                }
                            }
                        }

                        context("When action was an insert") {
                            beforeEach {
                                subject.tableView(subject.tableView, commit: .insert, forRowAt: IndexPath(row: 1, section: 0))
                            }
                            
                            it("does not call deletion callback") {
                                expect(capturedUrlForDeleteCallback).to(beNil())
                            }
                            
                            it("does not modify the number of visible cells") {
                                expect(subject.tableView.visibleCells.count).to(equal(2))
                            }
                        }
                    }

                    context("Without deletion") {
                        beforeEach {
                            subject.load(videos: videos, deleteCallback: nil)
                        }
                        
                        itBehavesLike("loading videos into the table")

                        it("prevents editing of rows") {
                            expect(subject.tableView(subject.tableView, canEditRowAt: IndexPath(row: 0, section: 0))).to(beFalse())
                        }
                    }
                }
            }
        }
    }
}
