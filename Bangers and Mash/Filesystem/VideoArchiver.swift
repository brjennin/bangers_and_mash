import Foundation

protocol VideoArchiverProtocol {
    func persist(tempUrl: URL)
}

class VideoArchiver: VideoArchiverProtocol {
    var directoryFinder: DirectoryFinderProtocol = DirectoryFinder()
    var fileManager: FileManagerProtocol = FileManager.default

    func persist(tempUrl: URL) {
        let file = tempUrl.lastPathComponent
        var documentsDirectory = directoryFinder.getDocumentsDirectory()
        documentsDirectory.appendPathComponent(file)

        try! fileManager.moveItem(at: tempUrl, to: documentsDirectory)
    }
}
