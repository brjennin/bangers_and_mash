import Foundation
import UIKit

protocol EmptyViewLifecycyleController: class {}

extension UIViewController: EmptyViewLifecycyleController {
    func swizzleViewLifecycleMethods() {
        swizzleViewDidLoad()
        swizzleViewWillAppear()
        swizzleViewDidAppear()
        swizzleViewWillDisappear()
        swizzleViewDidDisappear()
    }

    private func swizzleViewDidLoad() {
        let originalSelector = #selector(type(of: self).viewDidLoad)
        let swizzledSelector = #selector(UIViewController.viewDidLoad)
        swizzle(original: originalSelector, replacement: swizzledSelector)
    }

    private func swizzleViewWillAppear() {
        let originalSelector = #selector(type(of: self).viewWillAppear(_:))
        let swizzledSelector = #selector(UIViewController.viewWillAppear(_:))
        swizzle(original: originalSelector, replacement: swizzledSelector)
    }

    private func swizzleViewDidAppear() {
        let originalSelector = #selector(type(of: self).viewDidAppear(_:))
        let swizzledSelector = #selector(UIViewController.viewDidAppear(_:))
        swizzle(original: originalSelector, replacement: swizzledSelector)
    }

    private func swizzleViewWillDisappear() {
        let originalSelector = #selector(type(of: self).viewWillDisappear(_:))
        let swizzledSelector = #selector(UIViewController.viewWillDisappear(_:))
        swizzle(original: originalSelector, replacement: swizzledSelector)
    }

    private func swizzleViewDidDisappear() {
        let originalSelector = #selector(type(of: self).viewDidDisappear(_:))
        let swizzledSelector = #selector(UIViewController.viewDidDisappear(_:))
        swizzle(original: originalSelector, replacement: swizzledSelector)
    }

    private func swizzle(original: Selector, replacement: Selector) {
        let swizzledMethod = class_getInstanceMethod(UIViewController.self, replacement)
        class_replaceMethod(type(of: self), original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
    }
}
