import Foundation

protocol DirectoryFinderProtocol {
    func getDocumentsDirectory() -> URL
}

class DirectoryFinder: DirectoryFinderProtocol {
    func getDocumentsDirectory() -> URL {        
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
