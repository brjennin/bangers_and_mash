import Foundation
import AVFoundation
import Photos

protocol VideoArchiverProtocol {
    func persist(tempUrl: URL)
    func exportTemp(asset: AVAsset, videoComposition: AVVideoComposition, completion: @escaping (URL) -> ())
    func downloadVideoToCameraRoll(url: URL, completion: @escaping (Bool) -> ())
}

class VideoArchiver: VideoArchiverProtocol {
    var directoryFinder: DirectoryFinderProtocol = DirectoryFinder()
    var fileManager: FileManagerProtocol = FileManager.default
    var avAssetExportSessionProvider: AVAssetExportSessionProviderProtocol = AVAssetExportSessionProvider()
    var photoLibrary: PHPhotoLibraryProtocol = PHPhotoLibrary.shared()
    var cameraRollSaver: CameraRollSaverProtocol = CameraRollSaver()

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
                NSLog("completed")
                completion(outputFile)
            case .cancelled:
                NSLog("cancelled")
            case .exporting:
                NSLog("exporting")
            case .failed:
                NSLog("failed")
                NSLog(exportSession.error.debugDescription)
            case .unknown:
                NSLog("unknown")
            case .waiting:
                NSLog("waiting")
            }
        }
    }

    func downloadVideoToCameraRoll(url: URL, completion: @escaping (Bool) -> ()) {
        photoLibrary.performChanges({ [weak self] in
            self?.cameraRollSaver.saveVideo(url: url)
        }, completionHandler: { isSuccess, error in
            if let error = error {
                NSLog("Error saving to camera roll: \(error)")
            }
            completion(isSuccess)
        })
    }
}
