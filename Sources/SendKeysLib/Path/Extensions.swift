import AppKit
import Foundation

extension CGPoint {
    // Vector math
    public static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }

    public static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }

    public static func * (left: CGFloat, right: CGPoint) -> CGPoint {
        return CGPoint(x: left * right.x, y: left * right.y)
    }

    public static func * (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x * right.x, y: left.y * right.y)
    }

    public func distance(from: CGPoint) -> Double {
        let delta = self - from
        let sqr = delta * delta
        return sqrt(Double(sqr.x + sqr.y))
    }
}
