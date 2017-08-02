import Foundation
import Photos

protocol NotificationCenterProtocol {
    func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?)
    func removeObserver(_ observer: Any, name aName: NSNotification.Name?, object anObject: Any?)
}
extension NotificationCenter: NotificationCenterProtocol {}

protocol FileManagerProtocol {
    func moveItem(at srcURL: URL, to dstURL: URL) throws
    func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions) throws -> [URL]
    func removeItem(at URL: URL) throws
}
extension FileManager: FileManagerProtocol {}

protocol PHPhotoLibraryProtocol {
    func performChanges(_ changeBlock: @escaping () -> Swift.Void, completionHandler: ((Bool, Error?) -> Swift.Void)?)
}
extension PHPhotoLibrary: PHPhotoLibraryProtocol {}
