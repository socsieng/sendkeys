import Foundation

public class MouseClickCommandMatcher: CommandMatcher {
    public init() {
        super.init(try! NSRegularExpression(pattern: "\\<m:([a-z]+)(:([a-z,]+))?(:(\\d+))?\\>"))
    }

    override public func createCommand(_ arguments: [String?]) -> Command {
        let button = arguments[1]
        let modifiers = arguments[3]
        let clicks = arguments[5]

        return Command(.mouseClick, [
            button!,
            modifiers,
            clicks ?? "1"
        ])
    }
}
