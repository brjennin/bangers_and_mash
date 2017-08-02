import UIKit
import Quick
import Nimble
import Fleet
import CoreGraphics
@testable import Bangers_and_Mash

class TransformTransformerSpec: QuickSpec {
    override func spec() {
        describe("TransformTransformer") {
            var subject: TransformTransformer!

            beforeEach {
                subject = TransformTransformer()
            }

            describe("transforming a translation value") {
                let size = CGSize(width: 720.0, height: 1280.0)
                var translatedTranslation: CGFloat!

                context("when the original translation is 0") {
                    beforeEach {
                        translatedTranslation = subject.newTranslationValue(original: 0, size: size)
                    }

                    it("returns the original") {
                        expect(translatedTranslation).to(equal(0))
                    }
                }

                context("when the original translation is width minus height") {
                    beforeEach {
                        translatedTranslation = subject.newTranslationValue(original: size.width - size.height, size: size)
                    }

                    it("returns 0") {
                        expect(translatedTranslation).to(equal(0))
                    }
                }

                context("when the original translation is height minus width") {
                    beforeEach {
                        translatedTranslation = subject.newTranslationValue(original: size.height - size.width, size: size)
                    }

                    it("returns 0") {
                        expect(translatedTranslation).to(equal(0))
                    }
                }

                context("when the original translation is the height") {
                    beforeEach {
                        translatedTranslation = subject.newTranslationValue(original: size.height, size: size)
                    }

                    it("returns the original") {
                        expect(translatedTranslation).to(equal(size.height))
                    }
                }

                context("when the original translation is the width") {
                    beforeEach {
                        translatedTranslation = subject.newTranslationValue(original: size.width, size: size)
                    }

                    it("returns the original") {
                        expect(translatedTranslation).to(equal(size.width))
                    }
                }
            }
        }
    }
}
