import Foundation

public class MouseMoveCommand: MouseClickCommand {
    public override class var commandType: CommandType { return .mouseMove }

    private static let _expression = try! NSRegularExpression(pattern: "\\<m:((\\d+),(\\d+),)?(\\d+),(\\d+)(:([\\d.]+))?(:([a-z,]+))?\\>")
    public override class var expression: NSRegularExpression { return _expression }

    var x1: Int?
    var y1: Int?
    var x2: Int = 0
    var y2: Int = 0
    var duration: TimeInterval = 0

    override init() {
        super.init()
    }

    public init(x1: Int?, y1: Int?, x2: Int, y2: Int, duration: TimeInterval, modifiers: [String]) {
        super.init()

        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
        self.duration = duration
        self.modifiers = modifiers
    }

    required public init(arguments: [String?]) {
        super.init()
        self.x1 = Int(arguments[2] ?? "")
        self.y1 = Int(arguments[3] ?? "")
        self.x2 = Int(arguments[4]!)!
        self.y2 = Int(arguments[5]!)!
        self.duration = TimeInterval(arguments[7] ?? "0")!
        self.modifiers = arguments[9]?.components(separatedBy: ",").filter({ !$0.isEmpty }) ?? []
    }

    public override func execute() throws {
        mouseController.move(
            start: x1 == nil || y1 == nil ? nil : CGPoint(x: x1!, y: y1!),
            end: CGPoint(x: x2, y: y2),
            duration: duration,
            flags: try! KeyPresser.getModifierFlags(modifiers)
        )
    }

    public override func equals(_ comparison: Command) -> Bool {
        return super.equals(comparison) && {
            if let command = comparison as? MouseMoveCommand {
                return x1 == command.x1
                    && y1 == command.y1
                    && x2 == command.x2
                    && y2 == command.y2
                    && duration == command.duration
            }
            return false
        }()
    }
    
    public override func describeMembers() -> String {
        return "x1: \(x1?.description ?? "nil")), y1: \(y1?.description ?? "nil"), x2: \(x2), y2: \(y2), duration: \(duration)"
    }
}
