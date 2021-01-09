import Foundation

class Animator {
    typealias AnimationCallback = (_ progress: Double) -> Void

    let duration: TimeInterval
    let frequency: TimeInterval
    let animateFn: AnimationCallback

    init(_ duration: TimeInterval, _ frequency: TimeInterval, _ animateFn: @escaping AnimationCallback) {
        self.duration = duration
        self.frequency = frequency
        self.animateFn = animateFn
    }

    func animate() {
        let startDate = Date()

        while -startDate.timeIntervalSinceNow < duration {
            let progress = min(-startDate.timeIntervalSinceNow as Double / duration as Double, 1)
            let easedValue = easeInOut(progress)

            Sleeper.sleep(seconds: frequency)
            animateFn(easedValue)
        }

        animateFn(1)
    }

    func easeInOut(_ x: Double) -> Double {
        return x < 0.5 ? 2 * x * x : 1 - pow(-2 * x + 2, 2) / 2
    }
}
