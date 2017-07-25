import UIKit

class RecordButton: UIButton {
    static let borderWidth: CGFloat = 6.0
    static let recordGrowDuration: TimeInterval = 0.6
    static let recordShrinkDuration: TimeInterval = 0.3
    static let recordButtonScale: CGFloat = 62.4
    static let outerBorderScale: CGFloat = 1.352

    var animator: AnimatorProtocol = Animator()

    private var circleBorder: CALayer!
    private var innerCircle: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        drawButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawButton()
    }

    private func drawButton() {
        backgroundColor = UIColor.clear

        circleBorder = CALayer()
        circleBorder.backgroundColor = UIColor.clear.cgColor
        circleBorder.borderWidth = RecordButton.borderWidth
        circleBorder.borderColor = UIColor.white.cgColor
        circleBorder.bounds = self.bounds
        circleBorder.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        circleBorder.cornerRadius = self.frame.size.width / 2
        layer.insertSublayer(circleBorder, at: 0)
    }

    func indicateRecording() {
        innerCircle = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        innerCircle.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        innerCircle.backgroundColor = UIColor.red
        innerCircle.clipsToBounds = true
        innerCircle.layer.cornerRadius = innerCircle.frame.size.width / 2
        self.addSubview(innerCircle)

        animator.animate(withDuration: RecordButton.recordGrowDuration, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.innerCircle.transform = CGAffineTransform(scaleX: RecordButton.recordButtonScale, y: RecordButton.recordButtonScale)
            self?.circleBorder.setAffineTransform(CGAffineTransform(scaleX: RecordButton.outerBorderScale, y: RecordButton.outerBorderScale))
            self?.circleBorder.borderWidth = (RecordButton.borderWidth / RecordButton.outerBorderScale)
            }, completion: nil)
    }

    func indicateRecordingFinished() {
        animator.animate(withDuration: RecordButton.recordShrinkDuration, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.innerCircle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self?.circleBorder.setAffineTransform(CGAffineTransform(scaleX: 1.0, y: 1.0))
            self?.circleBorder.borderWidth = RecordButton.borderWidth
            }, completion: { [weak self] _ in
                self?.innerCircle.removeFromSuperview()
                self?.innerCircle = nil
        })
    }
}
