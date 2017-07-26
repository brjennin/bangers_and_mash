import Foundation

protocol NotificationCenterProtocol {
    func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?)
    func removeObserver(_ observer: Any, name aName: NSNotification.Name?, object anObject: Any?)
}
extension NotificationCenter: NotificationCenterProtocol {}

protocol FileManagerProtocol {
    func moveItem(at srcURL: URL, to dstURL: URL) throws
    func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions) throws -> [URL]
}
extension FileManager: FileManagerProtocol {}
