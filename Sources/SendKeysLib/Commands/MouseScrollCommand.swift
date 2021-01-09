import Foundation

public class MouseScrollCommand: MouseClickCommand {
    public override class var commandType: CommandType { return .mouseScroll }

    private static let _expression = try! NSRegularExpression(
        pattern: "\\<s:(-?\\d+),(-?\\d+)(:([.\\d]+))?(:([a-z,]+))?\\>")
    public override class var expression: NSRegularExpression { return _expression }

    var x: Int
    var y: Int
    var duration: TimeInterval

    public init(x: Int, y: Int, duration: TimeInterval, modifiers: [String]) {
        self.x = x
        self.y = y
        self.duration = duration

        super.init()
        self.modifiers = modifiers
    }

    required public init(arguments: [String?]) {
        self.x = Int(arguments[1]!)!
        self.y = Int(arguments[2]!)!
        self.duration = TimeInterval(arguments[4] ?? "0")!

        super.init()
        self.modifiers = arguments[6]?.components(separatedBy: ",").filter({ !$0.isEmpty }) ?? []
    }

    public override func execute() throws {
        mouseController!.scroll(
            CGPoint(x: x, y: y),
            duration,
            flags: try! KeyPresser.getModifierFlags(modifiers)
        )
    }

    public override func describeMembers() -> String {
        return "x: \(x), y: \(y), duration: \(duration), modifiers: \(modifiers)"
    }

    public override func equals(_ comparison: Command) -> Bool {
        return super.equals(comparison)
            && {
                if let command = comparison as? MouseScrollCommand {
                    return x == command.x
                        && y == command.y
                        && duration == command.duration
                }
                return false
            }()
    }
}
