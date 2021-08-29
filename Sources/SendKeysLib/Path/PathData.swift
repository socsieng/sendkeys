import Foundation

struct SegmentInfo {
    var startLength: Double
    var length: Double
    var startPoint: CGPoint
    var command: PathCommandBase

    init(_ startLength: Double, _ length: Double, _ startPoint: CGPoint, _ command: PathCommandBase) {
        self.startLength = startLength
        self.length = length
        self.startPoint = startPoint
        self.command = command
    }
}

public class PathData {
    public let commands: [PathCommandBase]
    private let segments: [SegmentInfo]

    convenience init(_ data: String) {
        self.init(data, CGPoint.zero)
    }

    init(_ data: String, _ startPoint: CGPoint) {
        commands = PathData.normalize(PathParser(data).parse(), startPoint)
        segments = PathData.getSegments(commands, startPoint)
    }

    private static func normalize(_ commands: [PathCommandBase], _ startPoint: CGPoint) -> [PathCommandBase] {
        var currentPoint = startPoint
        var pathStart = currentPoint
        var previousCubic: CubicBezierPathCommand?
        var previousQuadratic: QuadraticBezierPathCommand?

        return commands.flatMap { command -> [PathCommandBase] in
            command.makeAbsolute(currentPoint)

            if command.type == "Z" {
                return [PointPathCommand("L", PointValue(pathStart))]
            }
            if command.type == "M", let pointCommand = command as? PointPathCommand {
                pathStart = pointCommand.value.point
            }
            if let cubicCommand = command as? CubicBezierPathCommand {
                if command.type == "S" {
                    if previousCubic != nil {
                        // reflect
                        cubicCommand.value.controlPoint1 = 2 * currentPoint - previousCubic!.value.controlPoint2
                    } else {
                        cubicCommand.value.controlPoint1 = currentPoint
                    }
                }
                previousCubic = cubicCommand
            }
            if let quadtraticCommand = command as? QuadraticBezierPathCommand {
                if command.type == "T" {
                    if previousQuadratic != nil {
                        // reflect
                        quadtraticCommand.value.controlPoint1 =
                            2 * currentPoint - (previousQuadratic!.value.controlPoint1 ?? CGPoint.zero)
                    } else {
                        quadtraticCommand.value.controlPoint1 = currentPoint
                    }
                }
                previousQuadratic = quadtraticCommand
            }

            let newCommands: [PathCommandBase] = command.decompose(from: currentPoint)

            if command.currentPoint != nil {
                currentPoint = command.currentPoint!
            } else if newCommands.last?.currentPoint != nil {
                currentPoint = (newCommands.last?.currentPoint)!
            }

            return newCommands
        }
    }

    static func getSegments(_ commands: [PathCommandBase], _ startPoint: CGPoint) -> [SegmentInfo] {
        var total = 0.0
        var previousPoint = startPoint

        var segments: [SegmentInfo] = []

        for command in commands {
            let length = command.distanceFrom(point: previousPoint)

            if length >= 0 {
                segments.append(SegmentInfo(total, length, previousPoint, command))
            }

            if command.currentPoint != nil {
                previousPoint = command.currentPoint!
            }

            total += length
        }

        return segments
    }

    func getTotalDistance() -> Double {
        let last = segments.last

        if last == nil {
            return 0.0
        }

        return last!.startLength + last!.length
    }

    func getPointAtInterval(_ interval: Double) -> CGPoint {
        let targetLength = getTotalDistance() * max(min(interval, 1), 0)
        let index = segments.firstIndex { segment in
            return segment.startLength > targetLength
        }

        var segment: SegmentInfo?
        if index ?? 0 <= 0 {
            segment = segments.last
        } else {
            segment = segments[index! - 1]
        }

        if segment == nil {
            return CGPoint.zero
        }

        return segment!.command.pointAlongPath(
            interval: (targetLength - segment!.startLength) / segment!.length, from: segment!.startPoint)
    }
}
