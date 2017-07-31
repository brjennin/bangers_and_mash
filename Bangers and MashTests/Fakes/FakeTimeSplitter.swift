import UIKit
import CoreMedia
@testable import Bangers_and_Mash

class FakeTimeSplitter: TimeSplitterProtocol {
    var capturedDurationForTimeChunks: CMTime?
    var capturedChunksForTimeChunks: Int?
    var returnTimeRangesForTimeChunks: [CMTimeRange]!
    func timeChunks(duration: CMTime, chunks: Int) -> [CMTimeRange] {
        capturedDurationForTimeChunks = duration
        capturedChunksForTimeChunks = chunks
        return returnTimeRangesForTimeChunks
    }
}
