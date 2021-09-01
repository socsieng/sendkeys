import Foundation

public class MouseDragCommand: MouseMoveCommand {
    public override class var commandType: CommandType { return .mouseDrag }

    private static let _expression = try! NSRegularExpression(
        pattern: "\\<d:((-?[.\\d]+),(-?[.\\d]+),)?(-?[.\\d]+),(-?[.\\d]+)(:([\\d.]+))?(:([a-z]+))?(:([a-z,]+))?\\>")
    public override class var expression: NSRegularExpression { return _expression }

    public init(
        x1: Double?, y1: Double?, x2: Double, y2: Double, duration: TimeInterval, button: String?, modifiers: [String]
    ) {
        super.init()

        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
        self.duration = duration
        self.button = button
        self.modifiers = modifiers
    }

    required public init(arguments: [String?]) {
        super.init()
        self.x1 = Double(arguments[2] ?? "")
        self.y1 = Double(arguments[3] ?? "")
        self.x2 = Double(arguments[4]!)!
        self.y2 = Double(arguments[5]!)!
        self.duration = TimeInterval(arguments[7] ?? "0")!
        self.button = arguments[9] ?? "left"
        self.modifiers = arguments[11]?.components(separatedBy: ",").filter({ !$0.isEmpty }) ?? []
    }

    public override func describeMembers() -> String {
        return
            "x1: \(x1?.description ?? "nil")), y1: \(y1?.description ?? "nil"), x2: \(x2), y2: \(y2), duration: \(duration), button: \(button ?? "''")), modifiers: \(modifiers)"
    }

    public override func execute() throws {
        try! mouseController!.drag(
            start: x1 == nil || y1 == nil ? nil : CGPoint(x: x1!, y: y1!),
            end: CGPoint(x: x2, y: y2),
            duration: duration,
            button: getMouseButton(button: button!),
            flags: try! KeyPresser.getModifierFlags(modifiers)
        )
    }
}
