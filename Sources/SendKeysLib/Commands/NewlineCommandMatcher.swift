import Foundation

public class NewlineCommandMatcher: CommandMatcher {
    public init() {
        super.init(try! NSRegularExpression(pattern: "\\r?\\n"))
    }
    
    override public func createCommand(_ arguments: [String?]) -> Command {
        return Command(.keyPress, ["return"])
    }
}
