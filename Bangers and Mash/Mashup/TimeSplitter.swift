import Foundation
import CoreMedia

protocol TimeSplitterProtocol {
    func timeChunks(duration: CMTime, chunks: Int) -> [CMTimeRange]
}

class TimeSplitter: TimeSplitterProtocol {
    func timeChunks(duration: CMTime, chunks: Int) -> [CMTimeRange] {
        let chunkDuration = Double(duration.value) / (Double(chunks))
        var ranges = [CMTimeRange]()

        for index in 0...(chunks - 1) {
            let start = Double(index) * chunkDuration
            let end = Double(index + 1) * chunkDuration

            let range = CMTimeRange(start: CMTime(value: CMTimeValue(start), timescale: 100), end: CMTime(value: CMTimeValue(end), timescale: 100))
            ranges.append(range)
        }

        return ranges
    }
}
