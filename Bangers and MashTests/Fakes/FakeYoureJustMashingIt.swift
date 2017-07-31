import Foundation
@testable import Bangers_and_Mash

class FakeYoureJustMashingIt: YoureJustMashingItProtocol {
    var capturedSongForCombine: Song?
    var capturedVideoUrlForCombine: URL?
    var capturedCompletionForCombine: ((URL) -> ())?
    func combine(song: Song, videoUrl: URL, completion: @escaping (URL) -> ()) {
        capturedSongForCombine = song
        capturedVideoUrlForCombine = videoUrl
        capturedCompletionForCombine = completion
    }

    var capturedSongForRandomMash: Song?
    var capturedVideoUrlsForRandomMash: [URL]?
    var capturedCompletionForRandomMash: ((URL) -> ())?
    func randomMash(song: Song, videoUrls: [URL], completion: @escaping (URL) -> ()) {
        capturedSongForRandomMash = song
        capturedVideoUrlsForRandomMash = videoUrls
        capturedCompletionForRandomMash = completion
    }
}
