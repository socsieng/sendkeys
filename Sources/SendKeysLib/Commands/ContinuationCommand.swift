import Foundation

public class ContinuationCommand: Command {
    public override class var commandType: CommandType { return .continuation }

    private static let _expression = try! NSRegularExpression(pattern: "\\<\\\\\\>")
    public override class var expression: NSRegularExpression { return _expression }

    public override init() {
        super.init()
    }

    required public init(arguments: [String?]) {
        super.init(arguments: arguments)
    }
}
