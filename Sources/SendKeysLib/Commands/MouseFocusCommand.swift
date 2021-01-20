import Foundation

public class MouseFocusCommand: MouseClickCommand {
    public override class var commandType: CommandType { return .mouseScroll }

    // <mf:centerX,centerY:radiusX[,radiusY]:angleFrom,angleTo:duration>
    private static let _expression = try! NSRegularExpression(
        pattern: "\\<mf:(-?\\d+),(-?\\d+):(\\d+)(,(\\d+))?:(-?[.\\d]+),(-?[.\\d]+):([.\\d]+)\\>")
    public override class var expression: NSRegularExpression { return _expression }

    var x: Int
    var y: Int
    var rx: Int
    var ry: Int
    var from: Double
    var to: Double
    var duration: TimeInterval

    public init(x: Int, y: Int, rx: Int, ry: Int, angleFrom: Double, angleTo: Double, duration: TimeInterval) {
        self.x = x
        self.y = y
        self.rx = rx
        self.ry = ry
        self.from = angleFrom
        self.to = angleTo
        self.duration = duration

        super.init()
    }

    required public init(arguments: [String?]) {
        self.x = Int(arguments[1]!)!
        self.y = Int(arguments[2]!)!
        self.rx = Int(arguments[3]!)!
        self.ry = Int(arguments[5] ?? arguments[3]!)!
        self.from = Double(arguments[6]!)!
        self.to = Double(arguments[7]!)!
        self.duration = TimeInterval(arguments[8]!)!

        super.init()
    }

    public override func execute() throws {
        mouseController!.circle(CGPoint(x: x, y: y), CGPoint(x: rx, y: ry), from, to, duration)
    }

    public override func describeMembers() -> String {
        return "x: \(x), y: \(y), rx: \(rx), ry: \(ry), from: \(from), to: \(to), duration: \(duration)"
    }

    public override func equals(_ comparison: Command) -> Bool {
        return super.equals(comparison)
            && {
                if let command = comparison as? MouseFocusCommand {
                    return x == command.x
                        && y == command.y
                        && rx == command.rx
                        && ry == command.ry
                        && from == command.from
                        && to == command.to
                        && duration == command.duration
                }
                return false
            }()
    }
}
