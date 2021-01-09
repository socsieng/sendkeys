import Foundation

public class MouseClickCommand: Command, RequiresMouseController {
    public override class var commandType: CommandType { return .mouseClick }

    private static let _expression = try! NSRegularExpression(pattern: "\\<m:([a-z]+)(:([a-z,]+))?(:(\\d+))?\\>")
    public override class var expression: NSRegularExpression { return _expression }

    var button: String?
    var modifiers: [String] = []
    var clicks: Int = 1

    var mouseController: MouseController?

    override init() {
        super.init()
    }

    public init(button: String?, modifiers: [String], clicks: Int) {
        super.init()

        self.button = button
        self.modifiers = modifiers
        self.clicks = clicks
    }

    required public init(arguments: [String?]) {
        super.init()

        self.button = arguments[1]!
        self.modifiers = arguments[3]?.components(separatedBy: ",").filter({ !$0.isEmpty }) ?? []
        self.clicks = Int(arguments[5] ?? "1")!
    }

    public override func execute() throws {
        try! mouseController!.click(
            nil,
            button: getMouseButton(button: button!),
            flags: try! KeyPresser.getModifierFlags(modifiers),
            clickCount: clicks
        )
    }

    public override func equals(_ comparison: Command) -> Bool {
        return super.equals(comparison)
            && {
                if let command = comparison as? MouseClickCommand {
                    return button == command.button
                        && modifiers == command.modifiers
                        && clicks == command.clicks
                }
                return false
            }()
    }

    public override func describeMembers() -> String {
        return "button: \(button ?? "''")), modifiers: \(modifiers), clicks: \(clicks)"
    }

    func getMouseButton(button: String) throws -> CGMouseButton {
        switch button {
        case "left":
            return CGMouseButton.left
        case "center":
            return CGMouseButton.center
        case "right":
            return CGMouseButton.right
        default:
            throw RuntimeError("Unknown mouse button: \(button)")
        }
    }
}
