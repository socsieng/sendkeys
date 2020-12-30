import Foundation

public class DefaultCommandMatcher: CommandMatcher {
    public init() {
        super.init(try! NSRegularExpression(pattern: "."))
    }

    override public func createCommand(_ arguments: [String?]) -> Command {
        return Command(.keyPress, [arguments[0]!])
    }
}
