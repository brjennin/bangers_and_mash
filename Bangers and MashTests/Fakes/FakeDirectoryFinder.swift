import Foundation
@testable import Bangers_and_Mash

class FakeDirectoryFinder: DirectoryFinderProtocol {
    func getDocumentsDirectory() -> URL {
        return URL(fileURLWithPath: "/Documents")
    }
}
