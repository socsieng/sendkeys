import Foundation

public class KeyDownCommandMatcher: CommandMatcher {
    public init() {
        super.init(try! NSRegularExpression(pattern: "\\<kd:(.|[\\w]+)(:([,\\w⌘^⌥⇧]+))?\\>"))
    }

    override public func createCommand(_ arguments: [String?]) -> Command {
        var args = [arguments[1]!]
        if arguments[3] != nil {
            args.append(arguments[3]!)
        }
        return Command(.keyDown, args)
    }
}
