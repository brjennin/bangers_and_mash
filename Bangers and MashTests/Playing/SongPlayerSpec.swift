import UIKit
import Quick
import Nimble
import Fleet
@testable import Bangers_and_Mash

class SongPlayerSpec: QuickSpec {
    override func spec() {
        describe("SongPlayer") {
            var subject: SongPlayer!
            var scheduler: FakeScheduler!
            var avPlayerProvider: FakeAVPlayerProvider!

            beforeEach {
                subject = SongPlayer()

                scheduler = FakeScheduler()
                subject.scheduler = scheduler

                avPlayerProvider = FakeAVPlayerProvider()
                subject.avPlayerProvider = avPlayerProvider
            }

            describe("loading a song") {
                var song: Song!
                var player: FakeAVAudioPlayer!
                let bundle = Bundle(for: type(of: self))
                let path = bundle.path(forResource: "wild_thoughts", ofType: "mp3")!
                let url = URL(fileURLWithPath: path)

                beforeEach {
                    player = try! FakeAVAudioPlayer(contentsOf: url)
                    avPlayerProvider.returnedPlayerForGetAudioPlayer = player

                    song = Song(name: "wild thoughts", url: url, recordingStartTime: 5)
                    subject.load(song: song)
                }

                it("gets an audio player with the url") {
                    expect(avPlayerProvider.capturedUrlForGetAudioPlayer).to(equal(url))
                }

                it("prepares the song for playing") {
                    expect(player.calledPrepareToPlay).to(beTrue())
                }

                describe("playing a song from countdown") {
                    beforeEach {
                        player.currentTime = 10
                    }

                    context("when the countdown matches how long to wait before recording") {
                        beforeEach {
                            subject.playSong(fromCountdown: 5)
                        }

                        it("sets the current time back to 0") {
                            expect(player.currentTime).to(equal(0))
                        }

                        it("calls play") {
                            expect(player.calledPlay).to(beTrue())
                        }
                    }

                    context("when recording start time is greater than countdown") {
                        beforeEach {
                            subject.playSong(fromCountdown: 3)
                        }

                        it("sets the current time back to 0") {
                            expect(player.currentTime).to(equal(2))
                        }

                        it("calls play at") {
                            expect(player.calledPlay).to(beTrue())
                        }
                    }

                    context("when recording start time is less than countdown") {
                        var timer: Timer!

                        beforeEach {
                            timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { _ in })
                            scheduler.returnTimerForFireOnce = timer

                            subject.playSong(fromCountdown: 8)
                        }

                        it("sets the current time back to 0") {
                            expect(player.currentTime).to(equal(0))
                        }

                        it("schedules playing the song in the future") {
                            expect(scheduler.capturedSecondsForFireOnce).to(equal(3))
                        }

                        describe("if stopped before scheduler fires") {
                            beforeEach {
                                subject.stopSong()
                            }

                            it("invalidates the timer") {
                                expect(timer.isValid).to(beFalse())
                            }

                            it("stops the player") {
                                expect(player.calledStop).to(beTrue())
                            }
                        }

                        describe("when the scheduler fires") {
                            beforeEach {
                                scheduler.capturedBlockForFireOnce?(Timer())
                            }

                            it("calls play") {
                                expect(player.calledPlay).to(beTrue())
                            }
                        }
                    }
                }

                describe("stopping") {
                    beforeEach {
                        player.reset()
                        player.currentTime = 15

                        subject.stopSong()
                    }

                    it("sets the current time back to 0") {
                        expect(player.currentTime).to(equal(0))
                    }

                    it("prepares the song for playing") {
                        expect(player.calledPrepareToPlay).to(beTrue())
                    }

                    it("stops the player") {
                        expect(player.calledStop).to(beTrue())
                    }
                }
            }
        }
    }
}
