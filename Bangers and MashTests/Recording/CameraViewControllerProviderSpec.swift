import UIKit
import Quick
import Nimble
import Fleet
import SwiftyCam
@testable import Bangers_and_Mash

class CamControllerDelegate: SwiftyCamViewControllerDelegate {}

class CameraViewControllerProviderSpec: QuickSpec {
    override func spec() {
        describe("CameraControllerProvider") {
            var subject: CameraViewControllerProvider!

            beforeEach {
                subject = CameraViewControllerProvider()
            }

            describe("getting a controller") {
                var result: SwiftyCamViewController!
                var delegate: CamControllerDelegate!

                beforeEach {
                    delegate = CamControllerDelegate()
                    result = subject.get(delegate: delegate) as! SwiftyCamViewController
                }

                it("returns a controller") {
                    expect(result).to(beAKindOf(SwiftyCamViewController.self))
                }

                it("sets the camera delegate") {
                    expect(result.cameraDelegate).to(be(delegate))
                }

                it("sets camera defaults") {
                    expect(result.shouldUseDeviceOrientation).to(beFalse())
                    expect(result.allowAutoRotate).to(beFalse())
                    expect(result.defaultCamera).to(equal(SwiftyCamViewController.CameraSelection.front))
                    expect(result.videoQuality).to(equal(SwiftyCamViewController.VideoQuality.high))
                    expect(result.swipeToZoom).to(beFalse())
                    expect(result.allowBackgroundAudio).to(beFalse())
                    expect(result.audioEnabled).to(beFalse())
                    expect(result.lowLightBoost).to(beFalse())
                    expect(result.flashEnabled).to(beFalse())
                    expect(result.pinchToZoom).to(beTrue())
                    expect(result.maxZoomScale).to(equal(CGFloat.greatestFiniteMagnitude))
                    expect(result.tapToFocus).to(beTrue())
                    expect(result.doubleTapCameraSwitch).to(beTrue())
                }
            }
        }
    }
}




