import Foundation
@testable import Bangers_and_Mash

class FakeFileManager: FileManagerProtocol {
    var moveItemDoesThrow = false
    var capturedSrcUrlForMoveItem: URL?
    var capturedDstUrlForMoveItem: URL?
    func moveItem(at srcURL: URL, to dstURL: URL) throws {
        capturedSrcUrlForMoveItem = srcURL
        capturedDstUrlForMoveItem = dstURL

        if moveItemDoesThrow {
            throw NSError(domain: "domain", code: 100, userInfo: nil)
        }
    }

    var contentsOfDirectoryDoesThrow = false
    var capturedUrlForContentsOfDirectory: URL?
    var capturedKeysForContentsOfDirectory: [URLResourceKey]?
    var capturedOptionsForContentsOfDirectory: FileManager.DirectoryEnumerationOptions?
    var returnUrlsForContentsOfDirectory: [URL]!
    func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions = []) throws -> [URL] {
        capturedUrlForContentsOfDirectory = url
        capturedKeysForContentsOfDirectory = keys
        capturedOptionsForContentsOfDirectory = mask

        if contentsOfDirectoryDoesThrow {
            throw NSError(domain: "domain", code: 100, userInfo: nil)
        }
        return returnUrlsForContentsOfDirectory
    }
}
