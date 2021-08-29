import Foundation

public class MousePathCommand: MouseClickCommand {
    public override class var commandType: CommandType { return .mousePath }

    private static let _expression = try! NSRegularExpression(
        pattern: "\\<mpath:([^:\\>]+)(:(-?[\\d.]+),(-?[\\d.]+)(,(-?[\\d.]+),(-?[\\d.]+))?)?:([\\d.]+)(:([a-z,]+))?\\>")
    public override class var expression: NSRegularExpression { return _expression }

    var path: String
    var offsetX: Double = 0
    var offsetY: Double = 0
    var scaleX: Double = 1
    var scaleY: Double = 1
    var duration: TimeInterval = 0

    public init(
        path: String, offsetX: Double, offsetY: Double, scaleX: Double, scaleY: Double, duration: TimeInterval,
        modifiers: [String]
    ) {
        self.path = path
        self.offsetX = offsetX
        self.offsetY = offsetY
        self.scaleX = scaleX
        self.scaleY = scaleY
        self.duration = duration

        super.init()
        self.modifiers = modifiers
    }

    required public init(arguments: [String?]) {
        self.path = arguments[1]!
        self.offsetX = Double(arguments[3] ?? "0")!
        self.offsetY = Double(arguments[4] ?? "0")!
        self.scaleX = Double(arguments[6] ?? "1")!
        self.scaleY = Double(arguments[7] ?? "1")!
        self.duration = TimeInterval(arguments[8] ?? "0")!

        super.init()
        self.modifiers = arguments[9]?.components(separatedBy: ",").filter({ !$0.isEmpty }) ?? []
    }

    public override func execute() throws {
        mouseController!.move(
            start: nil,
            path: path,
            offset: CGPoint(x: offsetX, y: offsetY),
            scale: CGPoint(x: scaleX, y: scaleY),
            duration: duration,
            flags: try! KeyPresser.getModifierFlags(modifiers)
        )
    }

    public override func equals(_ comparison: Command) -> Bool {
        return super.equals(comparison)
            && {
                if let command = comparison as? MousePathCommand {
                    return path == command.path
                        && offsetX == command.offsetX
                        && offsetY == command.offsetY
                        && scaleX == command.scaleX
                        && scaleY == command.scaleY
                        && duration == command.duration
                }
                return false
            }()
    }

    public override func describeMembers() -> String {
        return
            "path: \(path), offsetX: \(offsetX), offsetY: \(offsetY), scaleX: \(scaleX), scaleY: \(scaleY), duration: \(duration)"
    }
}
