import Foundation

public class PathParser {
    private var index: Int
    private let data: [Character]
    private var previousType: Character?

    init(_ data: String) {
        self.index = 0
        self.data = Array(data)
    }

    public func parse() -> [PathCommandBase] {
        readIgnored()
        var commands: [PathCommandBase] = []

        while case let current = readCommand(false), current != nil {
            previousType = current!.type
            commands.append(current!)
        }

        return commands
    }

    private func readCommand(_ usePrevious: Bool) -> PathCommandBase? {
        let type = usePrevious ? previousType : index < data.count ? data[index] : nil
        var command: PathCommandBase

        if type == nil {
            return nil
        }

        if !usePrevious {
            index += 1
        }

        switch type {
        case "a", "A":
            let radius = readPoint()
            let rotation = readDouble()
            let largeArc = readInt() != 0
            let sweep = readInt() != 0
            let point = readPoint()

            command = ArcPathCommand(type!, ArchCommandValue(radius, rotation, largeArc, sweep, point))
        case "c", "C":
            let point1 = readPoint()
            let point2 = readPoint()
            let point = readPoint()

            command = CubicBezierPathCommand(type!, ControlPointsValue(point1, point2, point))
        case "h", "H", "v", "V":
            command = NumericPathCommand(type!, readDouble())
        case "l", "L", "m", "M":
            command = PointPathCommand(type!, PointValue(readPoint()))
        case "q", "Q":
            let point1 = readPoint()
            let point = readPoint()

            command = QuadraticBezierPathCommand(type!, ControlPointValue(point1, point))
        case "s", "S":
            let point2 = readPoint()
            let point = readPoint()

            command = CubicBezierPathCommand(type!, ControlPointsValue(nil, point2, point))
        case "t", "T":
            let point = readPoint()

            command = QuadraticBezierPathCommand(type!, ControlPointValue(nil, point))
        case "z", "Z":
            command = PathCommandBase(type!)
        default:
            index -= 1
            if previousType != nil {
                return readCommand(true)
            } else {
                return nil
            }
        }

        readIgnored()

        return command
    }

    private func readIgnored() {
        var current: Character
        while index < data.count {
            current = data[index]
            if " \r\n\t,".contains(current) {
                index += 1
            } else {
                break
            }
        }
    }

    private func readDouble() -> Double {
        var current: Character

        readIgnored()

        let start = index
        while index < data.count {
            current = data[index]
            if "+-0123456789eE.".contains(current) {
                index += 1
            } else {
                break
            }
        }

        let end = index

        readIgnored()

        if start == index {
            fatalError("Unable to read Double")
        }

        return Double(String(data[start..<end]))!
    }

    private func readInt() -> Int {
        var current: Character

        readIgnored()

        let start = index
        while index < data.count {
            current = data[index]
            if "+-0123456789eE".contains(current) {
                index += 1
            } else {
                break
            }
        }

        let end = index

        readIgnored()

        if start == index {
            fatalError("Unable to read Int")
        }

        return Int(String(data[start..<end]))!
    }

    private func readPoint() -> CGPoint {
        return CGPoint(x: readDouble(), y: readDouble())
    }
}
