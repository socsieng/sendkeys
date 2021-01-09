import Foundation

public class NewlineCommand: KeyPressCommand {
    private static let _expression = try! NSRegularExpression(pattern: "\\r?\\n")
    public override class var expression: NSRegularExpression { return _expression }

    public override init() {
        super.init()
        self.key = "return"
    }

    required public convenience init(arguments: [String?]) {
        self.init()
    }
}
