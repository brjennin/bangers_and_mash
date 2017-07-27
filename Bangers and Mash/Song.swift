import Foundation

struct Song {
    static let defaultDuration: TimeInterval = 15

    let name: String
    let url: URL
    let recordingStartTime: TimeInterval
    let recordingEndTime: TimeInterval
    let recordDuration: TimeInterval

    init(name: String, url: URL, recordingStartTime: TimeInterval = TimeInterval(CameraViewController.countdownTime), recordingEndTime: TimeInterval? = nil) {
        self.name = name
        self.url = url
        self.recordingStartTime = recordingStartTime
        if let recordingEndTime = recordingEndTime {
            self.recordingEndTime = recordingEndTime
        } else {
            self.recordingEndTime = recordingStartTime + Song.defaultDuration
        }
        self.recordDuration = self.recordingEndTime - recordingStartTime
    }
}

extension Song: Equatable {
    public static func ==(lhs: Song, rhs: Song) -> Bool {
        return lhs.url == rhs.url
    }
}
