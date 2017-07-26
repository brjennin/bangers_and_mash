import Foundation
import NotificationCenter
@testable import Bangers_and_Mash

class FakeNotificationCenter: NotificationCenterProtocol {
    struct AddObserverOptions {
        let observer: Any
        let selector: Selector
        let name: NSNotification.Name?
        let object: Any?
    }

    var capturedObserverOptionsForAdding = [AddObserverOptions]()
    func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?) {
        let options = AddObserverOptions(observer: observer, selector: aSelector, name: aName, object: anObject)
        capturedObserverOptionsForAdding.append(options)
    }

    struct RemoveObserverOptions {
        let observer: Any
        let name: NSNotification.Name?
        let object: Any?
    }

    var capturedObserverOptionsForRemoval = [RemoveObserverOptions]()
    func removeObserver(_ observer: Any, name aName: NSNotification.Name?, object anObject: Any?) {
        let options = RemoveObserverOptions(observer: observer, name: aName, object: anObject)
        capturedObserverOptionsForRemoval.append(options)
    }
}
