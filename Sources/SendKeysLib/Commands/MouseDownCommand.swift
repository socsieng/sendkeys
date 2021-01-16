import Foundation

public class MouseDownCommand: MouseClickCommand {
    public override class var commandType: CommandType { return .mouseDown }

    private static let _expression = try! NSRegularExpression(pattern: "\\<md:([a-z]+)(:([a-z,]+))?\\>")
    public override class var expression: NSRegularExpression { return _expression }

    override init() {
        super.init()
    }

    public init(button: String?, modifiers: [String]) {
        super.init()

        self.button = button
        self.modifiers = modifiers
    }

    required public init(arguments: [String?]) {
        super.init()

        self.button = arguments[1]!
        self.modifiers = arguments[3]?.components(separatedBy: ",").filter({ !$0.isEmpty }) ?? []
    }

    public override func execute() throws {
        try! mouseController!.down(
            nil,
            button: getMouseButton(button: button!),
            flags: try! KeyPresser.getModifierFlags(modifiers)
        )
    }
}
