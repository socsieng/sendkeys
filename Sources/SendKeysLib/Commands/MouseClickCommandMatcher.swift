import Foundation

public class MouseClickCommandMatcher: CommandMatcher {
    public init() {
        super.init(try! NSRegularExpression(pattern: "\\<m:([a-z]+)(:(\\d+))?\\>"))
    }

    override public func createCommand(_ arguments: [String?]) -> Command {
        let button = arguments[1]
        let clicks = arguments[3]

        return Command(.mouseClick, [
            button!,
            clicks ?? "1"
        ])
    }
}
