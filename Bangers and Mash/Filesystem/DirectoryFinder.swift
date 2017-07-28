import Foundation

protocol DirectoryFinderProtocol {
    func getDocumentsDirectory() -> URL
    func generateNewTempFileUrl(extensionString: String) -> URL
}

class DirectoryFinder: DirectoryFinderProtocol {
    func getDocumentsDirectory() -> URL {        
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    func generateNewTempFileUrl(extensionString: String) -> URL {
        let outputFileName = UUID().uuidString
        let outputFilePath = NSTemporaryDirectory()
        var outputFile = URL(fileURLWithPath: outputFilePath)
        outputFile.appendPathComponent(outputFileName)
        outputFile.appendPathExtension("mov")
        return outputFile
    }
}
