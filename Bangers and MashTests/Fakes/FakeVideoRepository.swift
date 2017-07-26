import Foundation
@testable import Bangers_and_Mash

class FakeVideoRepository: VideoRepositoryProtocol {
    var capturedCallbackForGetVideos: (([URL]) -> ())?
    func getVideos(callback: @escaping ([URL]) -> ()) {
        capturedCallbackForGetVideos = callback
    }
}
