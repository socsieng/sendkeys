import Foundation

public class PointValue: CustomStringConvertible {
    var point: CGPoint

    init(_ point: CGPoint) {
        self.point = point
    }

    public var description: String {
        return "\(point.x) \(point.y)"
    }
}

public class ControlPointValue: PointValue {
    var controlPoint1: CGPoint?

    init(_ controlPoint: CGPoint?, _ point: CGPoint) {
        super.init(point)
        self.controlPoint1 = controlPoint
    }

    override public var description: String {
        return "\(controlPoint1 != nil ? "\(controlPoint1!.x) \(controlPoint1!.y)" : "") \(point.x) \(point.y)"
            .trimmingCharacters(in: [" "])
    }
}

public class ControlPointsValue: ControlPointValue {
    var controlPoint2: CGPoint

    init(_ controlPoint1: CGPoint?, _ controlPoint2: CGPoint, _ point: CGPoint) {
        self.controlPoint2 = controlPoint2
        super.init(controlPoint1, point)
    }

    override public var description: String {
        return
            "\(controlPoint1 != nil ? "\(controlPoint1!.x) \(controlPoint1!.y)" : "") \(controlPoint2.x) \(controlPoint2.y) \(point.x) \(point.y)"
            .trimmingCharacters(in: [" "])
    }
}

public class ArchCommandValue: PointValue {
    var radius: CGPoint
    var angle: Double
    var largeArc: Bool
    var sweep: Bool

    init(_ radius: CGPoint, _ angle: Double, _ largeArc: Bool, _ sweep: Bool, _ point: CGPoint) {
        self.radius = radius
        self.angle = angle
        self.largeArc = largeArc
        self.sweep = sweep
        super.init(point)
    }

    override public var description: String {
        return "\(radius.x) \(radius.y) \(angle) \(largeArc ? "1" : "0") \(sweep ? "1" : "0") \(point.x) \(point.y)"
    }
}

public class PathCommandBase: Equatable, CustomStringConvertible {
    var type: Character

    init(_ type: Character) {
        self.type = type
    }

    func decompose(from: CGPoint) -> [PathCommandBase] {
        return [self]
    }

    public func equals(_ comparison: PathCommandBase) -> Bool {
        return self.description == comparison.description
    }

    public static func == (lhs: PathCommandBase, rhs: PathCommandBase) -> Bool {
        return lhs.equals(rhs) && rhs.equals(lhs)
    }

    public var description: String {
        return "\(type)"
    }

    public var currentPoint: CGPoint? {
        return nil
    }

    public var isRelative: Bool {
        return type.isLowercase
    }

    public func makeAbsolute(_ point: CGPoint) {
        if isRelative {
            type = Character(type.uppercased())
        }
    }

    public func distanceFrom(point: CGPoint) -> Double {
        return 0
    }

    public func pointAlongPath(interval: Double, from: CGPoint) -> CGPoint {
        if currentPoint == nil {
            return from
        }
        return from + CGFloat(interval) * (currentPoint! - from)
    }
}

public class PathCommand<T>: PathCommandBase {
    var value: T

    init(_ type: Character, _ value: T) {
        self.value = value
        super.init(type)
    }

    override public var description: String {
        return "\(type) \(value)"
    }
}

public class NumericPathCommand: PathCommand<Double> {
    override func decompose(from: CGPoint) -> [PathCommandBase] {
        if type == "H" {
            return [PointPathCommand("L", PointValue(CGPoint(x: CGFloat(value), y: from.y)))]
        }
        if type == "V" {
            return [PointPathCommand("L", PointValue(CGPoint(x: from.x, y: CGFloat(value))))]
        }
        return []
    }

    override public func makeAbsolute(_ point: CGPoint) {
        if isRelative {
            super.makeAbsolute(point)

            if type == "H" {
                value = Double(point.x) + value
            }
            if type == "V" {
                value = Double(point.y) + value
            }
        }
    }

    override public func distanceFrom(point: CGPoint) -> Double {
        fatalError("Not implemented")
    }
}

public class PointPathCommand: PathCommand<PointValue> {
    override public func makeAbsolute(_ point: CGPoint) {
        if isRelative {
            super.makeAbsolute(point)

            value.point = point + value.point
        }
    }

    override public func distanceFrom(point: CGPoint) -> Double {
        if type == "L" {
            return value.point.distance(from: point)
        } else if type == "M" {
            return 0
        }
        fatalError("Not implemented")
    }

    override public var currentPoint: CGPoint? {
        return value.point
    }
}

public class ArcPathCommand: PathCommand<ArchCommandValue> {
    override func decompose(from: CGPoint) -> [PathCommandBase] {
        if from == value.point {
            return []
        }

        if value.radius.x == 0 || value.radius.y == 0 {
            return [PointPathCommand("L", PointValue(value.point))]
        }

        let midpointDistance = CGFloat(0.5) * (from - value.point)
        var matrix = AffineTransform()
        matrix.rotate(byDegrees: CGFloat(value.angle))
        let tranformedMidpoint = matrix.transform(midpointDistance)
        var rx = value.radius.x
        var ry = value.radius.y
        let squareRx = rx * rx
        let squareRy = ry * ry
        let squareX = tranformedMidpoint.x * tranformedMidpoint.x
        let squareY = tranformedMidpoint.y * tranformedMidpoint.y

        let radiiScale = squareX / squareRx + squareY / squareRy
        if radiiScale > 1 {
            rx *= sqrt(radiiScale)
            ry *= sqrt(radiiScale)
        }

        matrix = AffineTransform()
        matrix.scale(x: 1 / rx, y: 1 / ry)
        matrix.rotate(byDegrees: CGFloat(-value.angle))
        var point1 = matrix.transform(from)
        var point2 = matrix.transform(value.point)
        var delta = point2 - point1
        let d = delta.x * delta.x + delta.y * delta.y

        var scaleFactor = sqrt(max(1 / d - 0.25, 0))
        if value.sweep == value.largeArc {
            scaleFactor = -scaleFactor
        }

        delta = scaleFactor * delta
        let center = 0.5 * (point1 + point2) + CGPoint(x: -delta.y, y: delta.x)

        let theta1 = Double(atan2(point1.y - center.y, point1.x - center.x))
        let theta2 = Double(atan2(point2.y - center.y, point2.x - center.x))
        var thetaArc = Double(theta2 - theta1)
        if thetaArc < 0 && value.sweep {
            thetaArc += Double.pi * 2.0
        } else if thetaArc > 0 && !value.sweep {
            thetaArc -= Double.pi * 2.0
        }

        matrix = AffineTransform()
        matrix.rotate(byDegrees: CGFloat(value.angle))
        matrix.scale(x: rx, y: ry)
        let segments = Int(ceil(fabs(thetaArc / Double.pi / 2)))

        var commands: [PathCommandBase] = []

        for i in 0...segments - 1 {
            let startTheta = theta1 + (Double(i) * thetaArc) / Double(segments)
            let endTheta = theta1 + ((Double(i) + 1.0) * thetaArc) / Double(segments)
            let t = CGFloat((8.0 / 6.0) * tan(0.25 * (endTheta - startTheta)))
            // if (!std::isfinite(t))
            //     return false;
            let sinStartTheta = CGFloat(sin(startTheta))
            let cosStartTheta = CGFloat(cos(startTheta))
            let sinEndTheta = CGFloat(sin(endTheta))
            let cosEndTheta = CGFloat(cos(endTheta))
            point1 = CGPoint(
                x: cosStartTheta - t * sinStartTheta + center.x,
                y: sinStartTheta + t * cosStartTheta + center.y
            )
            var targetPoint = CGPoint(
                x: cosEndTheta + center.x,
                y: sinEndTheta + center.y
            )
            point2 = CGPoint(x: targetPoint.x + t * sinEndTheta, y: targetPoint.y - t * cosEndTheta)

            point1 = matrix.transform(point1)
            point2 = matrix.transform(point2)
            targetPoint = matrix.transform(targetPoint)

            commands.append(CubicBezierPathCommand("C", ControlPointsValue(point1, point2, targetPoint)))
        }

        return commands
    }

    override public var currentPoint: CGPoint? {
        return value.point
    }

    override public func makeAbsolute(_ point: CGPoint) {
        if isRelative {
            print("arc relative point: \(description)")
            super.makeAbsolute(point)

            value.point = point + value.point
            print("arc absolute point: \(description)")
        }
    }

    override public func distanceFrom(point: CGPoint) -> Double {
        fatalError("Not implemented")
    }
}

public class QuadraticBezierPathCommand: PathCommand<ControlPointValue> {
    override func decompose(from: CGPoint) -> [PathCommandBase] {
        let controlPoint = value.controlPoint1 ?? from
        return [
            CubicBezierPathCommand(
                "C",
                ControlPointsValue(
                    from + (2.0 / 3.0) * (controlPoint - from),
                    value.point + (2.0 / 3.0) * (controlPoint - value.point),
                    value.point
                ))
        ]
    }

    override public var currentPoint: CGPoint? {
        return value.point
    }

    override public func makeAbsolute(_ point: CGPoint) {
        if isRelative {
            super.makeAbsolute(point)

            if value.controlPoint1 != nil {
                value.controlPoint1 = point + value.controlPoint1!
            }
            value.point = point + value.point
        }
    }

    override public func distanceFrom(point: CGPoint) -> Double {
        fatalError("Not implemented")
    }
}

public class CubicBezierPathCommand: PathCommand<ControlPointsValue> {
    override public var currentPoint: CGPoint? {
        return value.point
    }

    override public func makeAbsolute(_ point: CGPoint) {
        if isRelative {
            super.makeAbsolute(point)

            if value.controlPoint1 != nil {
                value.controlPoint1 = point + value.controlPoint1!
            }
            value.controlPoint2 = point + value.controlPoint2
            value.point = point + value.point
        }
    }

    private func lengthValueAt(t: CGFloat, p0: CGFloat, c1: CGFloat, c2: CGFloat, p1: CGFloat) -> CGFloat {
        var value: CGFloat = 0.0

        // (1-t)^3 * p0 + 3 * (1-t)^2 * t * c1 + 3 * (1-t) * t^2 * c2 + t^3 * p1
        value += pow(1 - t, 3) * p0
        value += 3 * pow(1 - t, 2) * t * c1
        value += 3 * (1 - t) * pow(t, 2) * c2
        value += pow(t, 3) * p1

        return value
    }

    private func poinAt(t: CGFloat, start: CGPoint) -> CGPoint {
        let x = lengthValueAt(
            t: t, p0: start.x, c1: value.controlPoint1?.x ?? start.x, c2: value.controlPoint2.x, p1: value.point.x)
        let y = lengthValueAt(
            t: t, p0: start.y, c1: value.controlPoint1?.y ?? start.y, c2: value.controlPoint2.y, p1: value.point.y)

        return CGPoint(x: x, y: y)
    }

    override public func distanceFrom(point: CGPoint) -> Double {
        var total = 0.0
        var previousPoint = point
        let segments = 1_000

        for i in 1...segments {
            let intervalPoint = poinAt(t: CGFloat(i) / CGFloat(segments), start: point)
            total += intervalPoint.distance(from: previousPoint)  // Command.distanceBetweenPoints(previousPoint, intervalPoint);

            previousPoint = intervalPoint
        }

        return Double(total)
    }

    override public func pointAlongPath(interval: Double, from: CGPoint) -> CGPoint {
        return poinAt(t: CGFloat(interval), start: from)
    }
}
