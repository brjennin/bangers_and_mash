import Foundation
@testable import Bangers_and_Mash

class FakeDirectoryFinder: DirectoryFinderProtocol {
    func getDocumentsDirectory() -> URL {
        return URL(fileURLWithPath: "/Documents")
    }

    var capturedExtensionForGenerateNewTempFile: String?
    var returnUrlForGenerateNewTempFile: URL!
    func generateNewTempFileUrl(extensionString: String) -> URL {
        capturedExtensionForGenerateNewTempFile = extensionString
        return returnUrlForGenerateNewTempFile
    }
}
