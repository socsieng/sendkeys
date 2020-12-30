import Foundation

public class ContinuationCommandMatcher: CommandMatcher {
    public init() {
        super.init(try! NSRegularExpression(pattern: "\\<\\\\\\>"))
    }
    
    override public func createCommand(_ arguments: [String?]) -> Command {
        return Command(.continuation, [])
    }
}
