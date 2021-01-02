import Foundation

public class PauseCommand: Command {
    public override class var commandType: CommandType { return .pause }
    
    private static let _expression = try! NSRegularExpression(pattern: "\\<p:([\\d.]+)\\>")
    public override class var expression: NSRegularExpression { return _expression }
    
    var duration: TimeInterval = 0
    
    init(duration: TimeInterval) {
        super.init()
        
        self.duration = duration
    }
    
    required public init(arguments: [String?]) {
        super.init()
        
        self.duration = TimeInterval(arguments[1]!)!
    }

    public override func execute() throws {
        Sleeper.sleep(seconds: duration)
    }
    
    public override func equals(_ comparison: Command) -> Bool {
        return super.equals(comparison) && {
            if let command = comparison as? PauseCommand {
                return duration == command.duration
            }
            return false
        }()
    }
    
    public override func describeMembers() -> String {
        return "duration: \(duration)"
    }
}
