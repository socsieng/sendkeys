import Foundation

public class PauseCommandMatcher: CommandMatcher {
    public init() {
        super.init(try! NSRegularExpression(pattern: "\\<p:([\\d.]+)\\>"))
    }
    
    override public func createCommand(_ arguments: [String?]) -> Command {
        return Command(.pause, [arguments[1]!])
    }
}
