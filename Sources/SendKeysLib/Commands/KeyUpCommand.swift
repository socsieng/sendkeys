import Foundation

public class KeyUpCommand: KeyPressCommand {
    public override class var commandType: CommandType { return .keyUp }
    
    private static let _expression = try! NSRegularExpression(pattern: "\\<ku:(.|[\\w]+)(:([,\\w⌘^⌥⇧]+))?\\>")
    public override class var expression: NSRegularExpression { return _expression }
    
    public override init (key: String, modifiers: [String]) {
        super.init(key: key, modifiers: modifiers)
    }
    
    required public init(arguments: [String?]) {
        super.init(arguments: arguments)
    }

    public override func execute() throws {
        let _ = try! keyPresser!.keyUp(key: key!, modifiers: modifiers)
    }
}
