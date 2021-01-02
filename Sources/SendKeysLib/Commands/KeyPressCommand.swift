import Foundation

public class KeyPressCommand: Command {
    public override class var commandType: CommandType { return .keyPress }
    
    private static let _expression = try! NSRegularExpression(pattern: "\\<[ck]:(.|[\\w]+)(:([,\\w⌘^⌥⇧]+))?\\>")
    public override class var expression: NSRegularExpression { return _expression }
    
    var key: String?
    var modifiers: [String] = []
    
    let keyPresser = KeyPresser()
    
    override init() {
        super.init()
    }
    
    public init (key: String, modifiers: [String]) {
        super.init()
        
        self.key = key
        self.modifiers = modifiers
    }
    
    required public init(arguments: [String?]) {
        super.init()
        
        self.key = arguments[1]!
        self.modifiers = arguments[3]?.components(separatedBy: ",").filter({ !$0.isEmpty }) ?? []
    }

    public override func execute() throws {
        try! keyPresser.keyPress(key: key!, modifiers: modifiers)
    }
    
    public override func equals(_ comparison: Command) -> Bool {
        return super.equals(comparison) && {
            if let command = comparison as? KeyPressCommand {
                return key == command.key
                    && modifiers == command.modifiers
            }
            return false
        }()
    }
    
    public override func describeMembers() -> String {
        return "key: \(key ?? "''")), modifiers: \(modifiers)"
    }
}
