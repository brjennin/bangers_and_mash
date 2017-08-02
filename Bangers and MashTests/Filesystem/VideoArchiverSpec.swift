import UIKit
import Quick
import Nimble
import Fleet
import AVFoundation
@testable import Bangers_and_Mash

class VideoArchiverSpec: QuickSpec {
    override func spec() {
        describe("VideoArchiver") {
            var subject: VideoArchiver!
            var directoryFinder: FakeDirectoryFinder!
            var fileManager: FakeFileManager!
            var avAssetExportSessionProvider: FakeAVAssetExportSessionProvider!
            var photoLibrary: FakePHPhotoLibrary!
            var cameraRollSaver: FakeCameraRollSaver!

            beforeEach {
                subject = VideoArchiver()

                directoryFinder = FakeDirectoryFinder()
                subject.directoryFinder = directoryFinder

                fileManager = FakeFileManager()
                subject.fileManager = fileManager

                avAssetExportSessionProvider = FakeAVAssetExportSessionProvider()
                subject.avAssetExportSessionProvider = avAssetExportSessionProvider

                photoLibrary = FakePHPhotoLibrary()
                subject.photoLibrary = photoLibrary

                cameraRollSaver = FakeCameraRollSaver()
                subject.cameraRollSaver = cameraRollSaver
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

            describe("exporting an asset to the temp directory") {
                var session: FakeAVAssetExportSession!
                let bundle = Bundle(for: type(of: self))
                let path = bundle.path(forResource: "perrier", ofType: "MOV")!
                let url = URL(fileURLWithPath: path)
                let asset = AVAsset(url: url)
                var capturedCompletionUrl: URL?
                let tempUrl = URL(string: "file:///temp/thing.mov")
                var videoComposition: AVVideoComposition!

                beforeEach {
                    session = FakeAVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
                    avAssetExportSessionProvider.returnSessionForGet = session

                    directoryFinder.returnUrlForGenerateNewTempFile = tempUrl

                    videoComposition = AVVideoComposition(propertiesOf: asset)

                    capturedCompletionUrl = nil
                    subject.exportTemp(asset: asset, videoComposition: videoComposition) { url in
                        capturedCompletionUrl = url
                    }
                }

                it("calls the export session provider") {
                    expect(avAssetExportSessionProvider.capturedAssetForGet).to(equal(asset))
                    expect(avAssetExportSessionProvider.capturedQualityForGet).to(equal(AVAssetExportPresetHighestQuality))
                }

                it("creates a new location to store the video") {
                    expect(directoryFinder.capturedExtensionForGenerateNewTempFile).to(equal("mov"))
                }

                it("sets the output url to be the temp url") {
                    expect(session.outputURL).to(equal(tempUrl))
                }

                it("sets the output filetype to be a quicktime movie") {
                    expect(session.outputFileType).to(equal(AVFileTypeQuickTimeMovie))
                }

                it("sets the video composition on the session") {
                    expect(session.videoComposition).to(be(videoComposition))
                }

                it("exports async") {
                    expect(session.capturedCompletionForExportAsync).toNot(beNil())
                }

                describe("exporting async") {
                    context("status is completed") {
                        beforeEach {
                            session.status = .completed
                            session.capturedCompletionForExportAsync?()
                        }

                        it("calls the callback with the temp url") {
                            expect(capturedCompletionUrl).to(equal(tempUrl))
                        }
                    }

                    context("status is failure") {
                        beforeEach {
                            session.status = .failed
                            session.capturedCompletionForExportAsync?()
                        }

                        it("does not call the callback") {
                            expect(capturedCompletionUrl).to(beNil())
                        }
                    }
                }
            }

            describe("saving a video to the camera roll") {
                var capturedSuccessValue: Bool!
                let url = URL(string: "https://www.example.com/mov.mov")!

                beforeEach {
                    capturedSuccessValue = nil
                    subject.downloadVideoToCameraRoll(url: url) { success in
                        capturedSuccessValue = success
                    }
                }

                it("makes changes to the photo library") {
                    expect(photoLibrary.capturedChangeBlockForPerformChanges).toNot(beNil())
                }

                describe("making changes") {
                    beforeEach {
                        photoLibrary.capturedChangeBlockForPerformChanges?()
                    }

                    it("savea a url to the camera roll") {
                        expect(cameraRollSaver.capturedUrlForSaveVideo).to(equal(url))
                    }

                    describe("on completion") {
                        context("When successful") {
                            beforeEach {
                                photoLibrary.capturedCompletionForPerformChanges?(true, nil)
                            }

                            it("calls the callback with true") {
                                expect(capturedSuccessValue).to(beTrue())
                            }
                        }

                        context("When unsuccessful") {
                            beforeEach {
                                photoLibrary.capturedCompletionForPerformChanges?(false, nil)
                            }

                            it("calls the callback with false") {
                                expect(capturedSuccessValue).to(beFalse())
                            }
                        }
                    }
                }
            }
        }
    }
}
