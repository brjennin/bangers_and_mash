import Foundation
import AVFoundation

protocol VideoArchiverProtocol {
    func persist(tempUrl: URL)
    func exportTemp(asset: AVAsset, videoComposition: AVVideoComposition, completion: @escaping (URL) -> ())
}

class VideoArchiver: VideoArchiverProtocol {
    var directoryFinder: DirectoryFinderProtocol = DirectoryFinder()
    var fileManager: FileManagerProtocol = FileManager.default
    var avAssetExportSessionProvider: AVAssetExportSessionProviderProtocol = AVAssetExportSessionProvider()

    func persist(tempUrl: URL) {
        let file = tempUrl.lastPathComponent
        var documentsDirectory = directoryFinder.getDocumentsDirectory()
        documentsDirectory.appendPathComponent(file)

        try! fileManager.moveItem(at: tempUrl, to: documentsDirectory)
    }

    func exportTemp(asset: AVAsset, videoComposition: AVVideoComposition, completion: @escaping (URL) -> ()) {
        let exportSession = avAssetExportSessionProvider.get(asset: asset, quality: AVAssetExportPresetHighestQuality)
        let outputFile = directoryFinder.generateNewTempFileUrl(extensionString: "mov")
        exportSession.outputURL = outputFile
        exportSession.outputFileType = AVFileTypeQuickTimeMovie
        exportSession.videoComposition = videoComposition

        exportSession.exportAsynchronously {

            switch exportSession.status {
            case .completed:
                NSLog("status: completed")
                completion(outputFile)
            case .cancelled:
                NSLog("status: cancelled")
            case .exporting:
                NSLog("status: exporting")
            case .failed:
                NSLog("status: failed")
                NSLog("\(exportSession.error)")
            case .unknown:
                NSLog("status: unknown")
            case .waiting:
                NSLog("status: waiting")
            }
        }
    }
}
