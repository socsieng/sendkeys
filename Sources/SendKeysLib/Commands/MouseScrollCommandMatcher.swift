import Foundation

public class MouseScrollCommandMatcher: CommandMatcher {
    public init() {
        super.init(try! NSRegularExpression(pattern: "\\<s:(-?\\d+),(-?\\d+)(:([.\\d]+))?(:([a-z,]+))?\\>"))
    }

    override public func createCommand(_ arguments: [String?]) -> Command {
        let x = arguments[1]
        let y = arguments[2]
        let duration = arguments[4]
        let modifiers = arguments[6]

        return Command(.mouseScroll, [
            x,
            y,
            duration,
            modifiers
        ])
    }
}
