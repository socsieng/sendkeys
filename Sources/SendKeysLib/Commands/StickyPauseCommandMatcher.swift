import Foundation

public class StickyPauseCommandMatcher: CommandMatcher {
    public init() {
        super.init(try! NSRegularExpression(pattern: "\\<P:([\\d.]+)\\>"))
    }

    override public func createCommand(_ arguments: [String?]) -> Command {
        return Command(.stickyPause, [arguments[1]!])
    }
}
