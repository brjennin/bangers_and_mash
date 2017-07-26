import Foundation

protocol VideoRepositoryProtocol {
    func getVideos(callback: @escaping ([URL]) -> ())
}

class VideoRepository: VideoRepositoryProtocol {
    var directoryFinder: DirectoryFinderProtocol = DirectoryFinder()
    var fileManager: FileManagerProtocol = FileManager.default
    
    func getVideos(callback: @escaping ([URL]) -> ()) {
        let documentsDir = directoryFinder.getDocumentsDirectory()
        let videos = try! fileManager.contentsOfDirectory(at: documentsDir, includingPropertiesForKeys: nil, options: [])
        callback(videos)
    }
}
