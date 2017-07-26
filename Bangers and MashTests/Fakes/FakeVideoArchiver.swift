import Foundation
@testable import Bangers_and_Mash

class FakeVideoArchiver: VideoArchiverProtocol {
    var capturedTempUrlForPersist: URL?
    func persist(tempUrl: URL) {
        capturedTempUrlForPersist = tempUrl
    }
}
