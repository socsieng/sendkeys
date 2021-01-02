import Foundation

public class DefaultCommand: KeyPressCommand {
    private static let _expression = try! NSRegularExpression(pattern: ".")
    public override class var expression: NSRegularExpression { return _expression }
    
    public init(key: String) {
        super.init()
        
        self.key = key
    }
    
    required public init(arguments: [String?]) {
        super.init()
        self.key = arguments[0]!
    }
}
